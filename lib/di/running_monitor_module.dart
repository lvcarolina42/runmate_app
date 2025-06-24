import 'package:get/get.dart';
import 'package:runmate_app/presentation/running_monitor/controller/running_monitor_controller.dart';

class RunningMonitorModule extends Bindings {
  @override
  void dependencies() {
    Get.put(
      RunningMonitorController()
    );
  }
}
