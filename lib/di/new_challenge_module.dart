import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/presentation/new_challenge/controller/new_challenge_controller.dart';

class NewChallengeModule extends Bindings {
  @override
  void dependencies() {
    Get.put(
      NewChallengeController(
        createChallengeUseCase: GetIt.I(),
      )
    );
  }
}
