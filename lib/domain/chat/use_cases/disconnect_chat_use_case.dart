import 'package:runmate_app/domain/chat/repository/chat_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class DisconnectChatUseCase {
  final ChatRepository repository;

  DisconnectChatUseCase({required this.repository});


  Future<Result<bool, Exception>> call({
    required String challengeId,
  }) async {
    return await repository.disconnectChat(challengeId: challengeId);
  }
}