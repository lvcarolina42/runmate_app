import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/session_manager.dart';

part 'runner_stats_controller.g.dart';

class RunnerStatsController = RunnerStatsControllerStore with _$RunnerStatsController;

abstract class RunnerStatsControllerStore extends DisposableInterface with Store {

  @observable
  User? _user = SessionManager().currentUser;
  
  @computed
  User? get user => _user;

}

