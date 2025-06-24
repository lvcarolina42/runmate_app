import 'dart:convert';

import 'package:runmate_app/data/api/data_result/remote_data_result.dart';
import 'package:runmate_app/data/user/dto/user_dto.dart';
import 'package:runmate_app/data/utils/extensions/map_extension.dart';
import 'package:runmate_app/domain/api/data_result/data_result.dart';
import 'package:runmate_app/domain/events/model/event_model.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/session_manager.dart';

extension EventDto on EventModel {
  static Map<String, dynamic> toDataResult({required DateTime date, required String title}) {
    return {
      "title": title,
      "date": date.toUtc().toIso8601String(),
      "created_by": SessionManager().currentUser!.id,
    };
  }

  static List<EventModel> fromDataResultList(DataResult result) {
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

    final runList = parsedList.map((e) => fromDataResult(e as Map<String, dynamic>)).toList();

    return runList;
  }
  
  static EventModel fromDataResult(Map<String, dynamic> result) {
    final List<User> users = UserDTO.fromDataResultList(RemoteDataResult(data: result.getValueOrDefault(key: "participants", defaultValue: [])));

    final DateTime date = result.getDateTime(
      key: 'date',
    );

    final String id = result.getValueOrDefault(
      key: 'id',
      defaultValue: '',
    );

    final bool isFinished = result.getValueOrDefault(
      key: 'finished',
      defaultValue: false,
    );
    
    final String title = result.getValueOrDefault(
      key: 'title',
      defaultValue: '',
    );

    return EventModel(
      id: id,
      date: date,
      title: title,
      participants: users,
      finished: isFinished,
    );
  }
}