import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/presentation/challenges/controller/challenges_controller.dart';

class ChallengesModule extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ChallengesController(
        joinTheChallengeUseCase: GetIt.I(),
        getAllChallengesUseCase: GetIt.I(),
        getActiveChallengesByUserUseCase: GetIt.I(),
      )
    );
  }
}
