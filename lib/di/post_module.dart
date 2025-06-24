import 'package:get/get.dart';
import 'package:runmate_app/presentation/post/controller/post_controller.dart';

class PostModule extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => PostController(),
    );
  }
}
