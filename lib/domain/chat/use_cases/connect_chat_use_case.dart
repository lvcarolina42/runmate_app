import 'package:runmate_app/domain/chat/model/message_model.dart';
import 'package:runmate_app/domain/chat/repository/chat_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class ConnectChatUseCase {
  final ChatRepository repository;

  ConnectChatUseCase({required this.repository});


  Future<Result<Stream<MessageModel>, Exception>> call({
    required String challengeId,
  }) async {
    return await repository.connectChat(challengeId: challengeId);
  }
}