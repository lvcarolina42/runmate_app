import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/run/model/run.dart';
import 'package:runmate_app/domain/run/use_cases/create_run_use_case.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/presentation/running/controller/running_controller.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/shared/events/app_listener_events.dart';

part 'running_info_controller.g.dart';

class RunningInfoController = RunningInfoControllerStore with _$RunningInfoController;

abstract class RunningInfoControllerStore extends DisposableInterface with Store {
  final CreateRunUseCase createRunUseCase;

  RunningInfoControllerStore({
    required this.createRunUseCase,
  });

  @observable
  RunningInfoArgs _args = RunningInfoArgs(
    pace: '',
    distance: '',
    averageSpeed: '',
    routeCoordinates: [],
    duration: Duration.zero,
  );

  @computed
  String get time {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(_args.duration.inHours)}:${twoDigits(_args.duration.inMinutes % 60)}:${twoDigits(_args.duration.inSeconds % 60)}";
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  @computed
  String get distance => _args.distance;

  @computed
  String get averageSpeed => _args.averageSpeed;

  @computed
  String get pace => _args.pace;

  @computed
  List<LatLng> get routeCoordinates => _args.routeCoordinates;

  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();

  @override
  void onInit() {
    final args = Get.arguments as RunningInfoArgs;
    _args = args;
    super.onInit();
  }

  int distanceInMeters() {
    final isKm = _args.distance.contains(" km");
    double distance = double.parse(_args.distance.replaceAll(" km", "").replaceAll(" m", ""));

    if (isKm) {
      distance *= 1000;
    }

    return distance.toInt();
  }

  Future<void> createRun() async {
    final user = SessionManager().currentUser!;

    final run = Run(
      id: "",
      userId: user.id,
      date: DateTime.now(),
      username: user.username,
      duration: _args.duration,
      distance: distanceInMeters(),
      title: titleController.text.trim(),
      checkPoints: _args.routeCoordinates.map((e) => CheckPoint(latitude: e.latitude, longitude: e.longitude)).toList(),
    );

    final result = await createRunUseCase(run: run);

    result.processResult(
      onSuccess: (data) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.green,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Corrida criada com sucesso"),
          ),
        );
        AppListenerEvents().add(RunEvent());
        Get.offAllNamed(Paths.menuPage);
      },
      onFailure: (error) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.red,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Nao foi possivel criar a corrida"),
          ),
        );
      },
    );
  }
}

class RunningInfoArgs {
  final String pace;
  final String distance;
  final Duration duration;
  final String averageSpeed;
  final List<LatLng> routeCoordinates;

  RunningInfoArgs({
    required this.pace,
    required this.duration,
    required this.distance,
    required this.averageSpeed,
    required this.routeCoordinates
  });
}