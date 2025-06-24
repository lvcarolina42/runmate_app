import 'package:runmate_app/domain/chat/model/message_model.dart';
import 'package:runmate_app/domain/chat/repository/chat_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase({required this.repository});

  Future<Result<List<MessageModel>, Exception>> call({
    required String challengeId,
  }) async {
    return await repository.getMessages(challengeId: challengeId);
  }
}