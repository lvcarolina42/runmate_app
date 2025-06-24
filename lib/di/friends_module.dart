import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/presentation/friends/controller/friends_controller.dart';

class FriendsModule extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FriendsController(
        getUsersUseCase: GetIt.I(),
        addFriendUseCase: GetIt.I(),
        getFriendsUseCase: GetIt.I(),
        removeFriendUseCase: GetIt.I(),
      )
    );
  }
}
