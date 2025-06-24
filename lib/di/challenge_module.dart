import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/presentation/challenge/controller/challenge_controller.dart';

class ChallengeModule extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ChallengeController(
        getChallengeByIdUseCase: GetIt.I(),
      )
    );
  }
}
