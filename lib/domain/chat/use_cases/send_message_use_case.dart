import 'package:runmate_app/domain/chat/repository/chat_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase({required this.repository});


  Result<bool, Exception> call({
    required String userId,
    required String content,
  }) {
    return repository.sendMessage(userId: userId, message: content);
  }
}