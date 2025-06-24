import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/presentation/events/controller/events_controller.dart';
import 'package:runmate_app/presentation/home/controller/home_controller.dart';
import 'package:runmate_app/presentation/menu/controller/menu_controller.dart';
import 'package:runmate_app/presentation/profile/controller/profile_controller.dart';
import 'package:runmate_app/presentation/weather_information/controller/weather_information_controller.dart';

class MenuModule extends Bindings {
  @override
  void dependencies() {
    Get.put(
      MenuPageController()
    );
    Get.put(
      HomeController(
        getAllRunUseCase: GetIt.I(),
        getActiveChallengesByUserUseCase: GetIt.I(),
      ),
    );
    Get.put(
      WeatherInformationController()
    );
    Get.put(
      ProfileController(
        deleteGoalUseCase: GetIt.I(),
        updateGoalUseCase: GetIt.I(),
        getUserByIdUseCase: GetIt.I(),
        getRunByUserUseCase: GetIt.I(),
      ),
    );
    Get.put(
      EventsController(
        joinEventUseCase: GetIt.I(),
        leaveEventUseCase: GetIt.I(),
        getMyEventsUseCase: GetIt.I(),
        getAllEventsUseCase: GetIt.I(),
        createEventsUseCase: GetIt.I(),
      ),
    );
  }
}
