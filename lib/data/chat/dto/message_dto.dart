import 'dart:convert';

import 'package:runmate_app/data/user/dto/user_dto.dart';
import 'package:runmate_app/data/utils/extensions/map_extension.dart';
import 'package:runmate_app/data/api/data_result/remote_data_result.dart';
import 'package:runmate_app/domain/api/data_result/data_result.dart';
import 'package:runmate_app/domain/chat/model/message_model.dart';

extension MessageDto on MessageModel {
  static List<MessageModel> fromDataResultList(DataResult result) {
    result as RemoteDataResult;
    
    final rawData = result.data;
    late final List<dynamic> parsedList;

    if (rawData is String) {
      parsedList = jsonDecode(rawData);
    } else if (rawData is List) {
      parsedList = rawData;
    } else {
      throw Exception("Formato inesperado de result.data: ${rawData.runtimeType}");
    }

    final messageList = parsedList.map((e) => fromDataResult(e as Map<String, dynamic>)).toList();

    return messageList;
  }
  static MessageModel fromDataResult(dynamic result) {

    result as Map<String, dynamic>;

    final DateTime date = result.getCompleteDateTime(
      key: 'date',
      defaultValue: '',
    ) ?? DateTime.now();

    return MessageModel(
      date: date,
      content: result.getValueOrDefault(key: "message", defaultValue: ""),
      user: UserDTO.simpleFromDataResult(RemoteDataResult(data: result.getValueOrDefault(key: "user", defaultValue: {}))),
    );
  }
}