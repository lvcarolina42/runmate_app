import 'package:runmate_app/domain/chat/model/message_model.dart';
import 'package:runmate_app/domain/utils/result.dart';

abstract class ChatRepository {
  Future<Result<Stream<MessageModel>, Exception>> connectChat({
    required String challengeId,
  });

  Result<bool, Exception> sendMessage({
    required String userId,
    required String message,
  });

  Future<Result<List<MessageModel>, Exception>> getMessages({
    required String challengeId,
  });

  Future<Result<bool, Exception>> disconnectChat({
    required String challengeId,
  });
}
