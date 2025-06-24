import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'running_monitor_controller.g.dart';

class RunningMonitorController = RunningMonitorControllerStore with _$RunningMonitorController;

abstract class RunningMonitorControllerStore extends DisposableInterface with Store {
  @computed
  mapbox.CameraOptions get camera => mapbox.CameraOptions(
    center: mapbox.Point(coordinates: _position),
    zoom: 16,
  );

  @observable
  mapbox.Position _position = mapbox.Position(0, 0);

  @computed
  mapbox.Position get position => _position;

  @observable
  double _latitude = 0;

  @observable
  double _longitude = 0;

  @computed
  LatLng get coordinates => LatLng(latitude: _latitude, longitude: _longitude);

  final TextEditingController distanceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int _distanceForAudio = 0;

  int _timeForAudio = 0;
  
  @override
  void onInit() {
    super.onInit();
    onInitialize();
  }

  Future<void> onInitialize() async {
    await _getCurrentPosition();
    await loadSettings();
  }

  mapbox.MapboxMap? _mapboxMap;
  set mapboxMap(mapbox.MapboxMap map) => _mapboxMap = map;

  void attachMap(mapbox.MapboxMap map) {
    _mapboxMap = map;

    reaction<mapbox.Position>(
      (_) => _position,
      (position) {
        _mapboxMap?.setCamera(camera);
      },
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {   
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _position = mapbox.Position(position.longitude, position.latitude);
      _latitude = position.latitude;
      _longitude = position.longitude;
    }).catchError((e) {
      debugPrint(e);
    });
  }
  
  Future<void> saveSettings() async {
    if (formKey.currentState!.validate()) {
      final distanceAudio = distanceController.text;
      final timeAudio = timeController.text;

      _distanceForAudio = int.tryParse(distanceAudio) ?? 0;
      _timeForAudio = int.tryParse(timeAudio) ?? 0;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('timeAudio', _timeForAudio);
      await prefs.setInt('distanceAudio', _distanceForAudio);
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _distanceForAudio = prefs.getInt('distanceAudio') ?? 0;
    _timeForAudio = prefs.getInt('timeAudio') ?? 0;

    distanceController.text = _distanceForAudio.toString();
    timeController.text = _timeForAudio.toString();
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng({required this.latitude, required this.longitude});
}
