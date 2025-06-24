import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/presentation/chat/controller/chat_controller.dart';

class ChatModule extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ChatController(
        sendMessageUseCase: GetIt.I(),
        getMessagesUseCase: GetIt.I(),
        connectChatUseCase: GetIt.I(),
        disconnectChatUseCase: GetIt.I(),
      )
    );
  }
}
