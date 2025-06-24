import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/presentation/user_profile/controller/user_profile_controller.dart';

class UserProfileModule extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => UserProfileController(
        getRunByUserUseCase: GetIt.I(),
      )
    );
  }
}
