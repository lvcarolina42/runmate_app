import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/presentation/running_info/controller/running_info_controller.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'running_controller.g.dart';

class RunningController = RunningControllerStore with _$RunningController;

abstract class RunningControllerStore extends DisposableInterface with Store {

  final List<LatLng> _routeCoordinates = [];

  StreamSubscription<Position>? _positionStream;

  @observable
  double _totalDistance = 0.0;

  @computed
  double get totalDistance => _totalDistance;

  @observable
  double _averageSpeed = 0.0;

  @observable
  double _pace = 0.0;

  @computed
  String get averageSpeed => "${_averageSpeed.toStringAsFixed(2)} km/h";

  @computed
  String get pace => "${_pace.toStringAsFixed(2)} min/km";

  @computed
  String get distanceInKm {
    final distanceInKm = _totalDistance / 1000;

    if (distanceInKm >= 1) {
      return "${distanceInKm.toStringAsFixed(2)} km";
    }

    return "${_totalDistance.toStringAsFixed(0)} m";
  }

  Timer? _timer;

  @observable
  Duration _elapsedTime = Duration.zero;

  @computed
  Duration get elapsedTime => _elapsedTime;

  @observable
  bool _isTracking = false;

  @computed
  bool get isTracking => _isTracking;

  double _currentDistanceForAudio = 0;

  int _currentTimeForAudioInSeconds = 0;

  final FlutterTts flutterTts = FlutterTts();

  int _distanceForAudio = 0;

  int _timeForAudio = 0;

  @override
  void onInit() {
    startTracking();
    onInitialize();
    super.onInit();
  }

  Future<void> onInitialize() async {
    await loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _distanceForAudio = prefs.getInt('distanceAudio') ?? 0;
    _timeForAudio = prefs.getInt('timeAudio') ?? 0;
  }

  void startTracking() {
    _isTracking = true;
    _totalDistance = 0;
    _elapsedTime = Duration.zero;
    _averageSpeed = 0;
    _routeCoordinates.clear();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        distanceFilter: 1,
        accuracy: LocationAccuracy.best,
      ),
    ).listen((Position position) {
      final point = LatLng(
        latitude: position.latitude, 
        longitude: position.longitude
      );
      _routeCoordinates.add(point);
      _updateDistance();
    });

    _startTimer();
  }

  void _updateDistance() {
    if (_routeCoordinates.length < 2) return;

    final p1 = _routeCoordinates[_routeCoordinates.length - 2];
    final p2 = _routeCoordinates.last;

    final distance = Geolocator.distanceBetween(
      p1.latitude, p1.longitude,
      p2.latitude, p2.longitude,
    );

    _totalDistance += distance;

    playAudioDistance(distance);

    _recalculateAverageSpeed();
  }

  Future<void> playAudioDistance(double distance) async {

    _currentDistanceForAudio += distance;

    if (_distanceForAudio > 0 && _currentDistanceForAudio >= _distanceForAudio) {
      _currentDistanceForAudio = 0;
      final totalDistanceInKm = _totalDistance / 1000;
      await flutterTts.setLanguage("pt-BR");

      if (totalDistanceInKm < 1) {
        await flutterTts.speak("Distância total percorrida: ${totalDistance.toStringAsFixed(0)} metros");
        return;
      }
      await flutterTts.speak("Distância total percorrida: ${totalDistanceInKm.toStringAsFixed(1)} quilômetros");
    }
  }

  Future<void> playAudioTime() async {

    _currentTimeForAudioInSeconds += 1;

    final timeInMinutes = _currentTimeForAudioInSeconds / 60;


    if (_timeForAudio > 0 && timeInMinutes >= _timeForAudio) {
      _currentTimeForAudioInSeconds = 0;
      await flutterTts.setLanguage("pt-BR");
      await flutterTts.speak("Tempo total percorrido: ${_elapsedTime.inMinutes} minutos");
    }
  }

  void _startTimer() {
    _elapsedTime = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedTime += const Duration(seconds: 1);
      playAudioTime();
      _recalculateAverageSpeed();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _recalculateAverageSpeed() {
    if (_elapsedTime.inSeconds == 0 || _totalDistance == 0) {
      _averageSpeed = 0;
      return;
    }

    final distanceInKm = _totalDistance / 1000;
    final timeInHours = _elapsedTime.inSeconds / 3600;
    final timeInMinutes = _elapsedTime.inSeconds / 60;
    _averageSpeed = distanceInKm / timeInHours;
    _pace = timeInMinutes / distanceInKm;
  }

  void stopTracking() {
    _positionStream?.cancel();
    _stopTimer();
    _isTracking = false;

    Get.offAndToNamed(
      Paths.runningInfo, 
      arguments: RunningInfoArgs(
        pace: pace,
        distance: distanceInKm,
        duration: _elapsedTime,
        averageSpeed: averageSpeed,
        routeCoordinates: _routeCoordinates,
      ),
    );
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  @override
  void onClose() {
    _stopTimer();
    _positionStream?.cancel();
    super.onClose();
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng({required this.latitude, required this.longitude});
}