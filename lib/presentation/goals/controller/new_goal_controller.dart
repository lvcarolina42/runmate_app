import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/session_manager.dart';

part 'new_goal_controller.g.dart';

class NewGoalController = NewGoalControllerStore with _$NewGoalController;

abstract class NewGoalControllerStore extends DisposableInterface with Store {
  @observable
  User? _user = SessionManager().currentUser;

  @computed
  User? get user => _user;

  @observable
  String name = '';

  @observable
  String description = '';

  @action
  void setName(String value) => name = value;

  @action
  void setDescription(String value) => description = value;

  Future<void> createGoal() async {
    final dio = Dio(); 
    final data = {
      'userId': _user?.id,
      'mondayGoal': 0,
      'tuesdayGoal': 0,
      'wednesdayGoal': 0,
      'thursdayGoal': 0,
      'fridayGoal': 0,
      'saturdayGoal': 0,
      'sundayGoal': 0,
      'mondayDoed': 0,
      'tuesdayDoed': 0,
      'wednesdayDoed': 0,
      'thursdayDoed': 0,
      'fridayDoed': 0,
      'saturdayDoed': 0,
      'sundayDoed': 0,
      'createdAt': DateTime.now().toIso8601String(),
      'name': name,
      'description': description,
    };

    await dio.post('https://SEU_BACKEND_URL/api/race-goals', data: data);
  }

  @override
  void onClose() {}
}
