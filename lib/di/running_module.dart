import 'package:get/get.dart';
import 'package:runmate_app/presentation/running/controller/running_controller.dart';

class RunningModule extends Bindings {
  @override
  void dependencies() {
    Get.put(
      RunningController()
    );
  }
}
