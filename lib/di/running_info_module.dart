import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/presentation/running_info/controller/running_info_controller.dart';

class RunningInfoModule extends Bindings {
  @override
  void dependencies() {
    Get.put(
      RunningInfoController(
        createRunUseCase: GetIt.I(),
      )
    );
  }
}
