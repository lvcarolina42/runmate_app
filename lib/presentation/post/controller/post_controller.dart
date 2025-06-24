import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/run/model/run.dart';

part 'post_controller.g.dart';

class PostController = PostControllerStore with _$PostController;

abstract class PostControllerStore extends DisposableInterface with Store {
  @observable
  Run? _run;

  @computed 
  Run? get run => _run;

  @override
  void onInit() {
    super.onInit();
    _run = Get.arguments as Run;
  }
}

