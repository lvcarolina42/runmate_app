import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/presentation/login/controller/login_controller.dart';

class LoginModule extends Bindings {
  @override
  void dependencies() {
    Get.put(
      LoginController(
        loginUseCase: GetIt.I(),
        updateTokenUseCase: GetIt.I(),
      )
    );
  }
}
