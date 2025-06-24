import 'dart:convert';

import 'package:runmate_app/data/chat/datasource/chat_datasource.dart';
import 'package:runmate_app/data/chat/dto/message_dto.dart';
import 'package:runmate_app/domain/chat/model/message_model.dart';
import 'package:runmate_app/domain/chat/repository/chat_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasource datasource;

  ChatRepositoryImpl({required this.datasource});

  @override
  Future<Result<Stream<MessageModel>, Exception>> connectChat({
    required String challengeId,
  }) async {
    try {
      final stream = await datasource.connectWebSocket(challengeId);
      final mappedStream = stream.map(
            (event) => MessageDto.fromDataResult(event),
          );
      return Result.success(mappedStream);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> disconnectChat({
    required String challengeId,
  }) async {
    try {
      datasource.disconnect();
      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<MessageModel>, Exception>> getMessages({
    required String challengeId,
  }) async {
    try {
      final response = await datasource.getPreviousMessages(challengeId);
      final result = MessageDto.fromDataResultList(response);
      return Result.success(result);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Result<bool, Exception> sendMessage({
    required String userId,
    required String message,
  }) {
    try {
      final payload = jsonEncode({
        'content': message,
        'user_id': userId,
      });
      datasource.sendMessage(payload);
      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }
}
