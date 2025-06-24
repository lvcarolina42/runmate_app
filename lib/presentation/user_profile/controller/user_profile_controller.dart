import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/run/model/run.dart';
import 'package:runmate_app/domain/run/use_cases/get_run_by_user_use_case.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/domain/user/use_cases/get_user_by_id_use_case.dart';
import 'package:runmate_app/shared/events/app_listener_events.dart';

part 'user_profile_controller.g.dart';

class UserProfileController = UserProfileControllerStore with _$UserProfileController;

abstract class UserProfileControllerStore extends DisposableInterface with Store {
  final GetRunByUserUseCase getRunByUserUseCase;
  // final GetUserByIdUseCase getUserByIdUseCase;

  UserProfileControllerStore({required this.getRunByUserUseCase});

  @observable
  User? _user;
  
  @computed
  User? get user => _user;

  @observable
  bool _isLoadingFeed = false;

  @computed
  bool get isLoadingFeed => _isLoadingFeed;

  @observable
  bool _hasErrorFeed = false;

  @computed
  bool get hasErrorFeed => _hasErrorFeed;

  @observable
  ObservableList<Run> _runs = ObservableList<Run>();

  @computed
  ObservableList<Run> get runs => _runs.reversed.toList().asObservable();

  @override
  void onInit() {
    super.onInit();
    onInitialize();
  }

  Future<void> onInitialize() async {
    await getUser();
    await getAllRun();
  }

  @action
  Future<void> getAllRun() async {
    final result = await getRunByUserUseCase(user?.id ?? "");

    result.processResult(
      onSuccess: (data) {
        _runs = data.asObservable();
      },
      onFailure: (error) {
        _hasErrorFeed = true;
      },
    );
  }

  @action
  Future<void> getUser() async {
    final result = Get.arguments as User;
    _user = result;
  }

  String getAvaragePace() {
    if (this.runs.isEmpty) {
      return '00:00:00';
    }
    final runs = this.runs;
    final totalDistanceInMeters = runs.fold(0.0, (sum, run) => sum + run.distance);
    final totalTimeInSeconds = runs.fold(0.0, (sum, run) => sum + run.duration.inSeconds);

    final averagePace = totalTimeInSeconds / (totalDistanceInMeters / 1000);

    final int hours = averagePace ~/ 3600;
    final int minutes = (averagePace % 3600) ~/ 60;
    final int seconds = int.parse((averagePace % 60).toStringAsFixed(0));

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String bestPace() {
    final runs = this.runs;
    if (this.runs.isEmpty) {
      return '00:00:00';
    }
    final bestRun = runs.reduce((a, b) => a.duration < b.duration ? a : b);
    
    final hours = bestRun.duration.inHours;
    final minutes = bestRun.duration.inMinutes % 60;
    final seconds = bestRun.duration.inSeconds % 60;
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

