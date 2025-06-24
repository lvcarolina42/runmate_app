import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/presentation/register/controller/register_controller.dart';

class RegisterModule extends Bindings {
  @override
  void dependencies() {
    Get.put(
      RegisterController(
        registerUseCase: GetIt.I(),
      )
    );
  }
}
