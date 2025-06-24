import 'dart:convert';

import 'package:runmate_app/data/api/data_result/remote_data_result.dart';
import 'package:runmate_app/data/utils/extensions/map_extension.dart';
import 'package:runmate_app/domain/api/data_result/data_result.dart';
import 'package:runmate_app/domain/user/model/user.dart';

extension UserDTO on User {
  static List<User> fromDataResultList(DataResult result) {
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

    final userList = parsedList.map((e) => simpleFromDataResult(RemoteDataResult(data: e))).toList();

    return userList;
  }
  static User simpleFromDataResult(DataResult result) {
    result as RemoteDataResult;

    final data = result.jsonData as Map<String, dynamic>;

    final String id = data.getValueOrDefault(
      key: 'id',
      defaultValue: '',
    );

    final String email = data.getValueOrDefault(
      key: 'email',
      defaultValue: '',
    );

    final String username = data.getValueOrDefault(
      key: 'username',
      defaultValue: '',
    );

    final String name = data.getValueOrDefault(
      key: 'name',
      defaultValue: '',
    );

    final DateTime birthDate = data.getCompleteDateTime(
      key: 'birthdate',
      defaultValue: '',
    ) ?? DateTime.now();

    final int level = data.getValueOrDefault(
      key: 'level',
      defaultValue: 0,
    );

    final int xp = data.getValueOrDefault(
      key: 'xp',
      defaultValue: 0,
    );

    final int nextLevelXp = data.getValueOrDefault(
      key: 'next_level_xp',
      defaultValue: 0,
    );

    final Map<String, dynamic> goal = data.getValueOrDefault(
      key: 'goal',
      defaultValue: {},
    );

    final Goal goalObject = simpleGoalFromDataResult(goal);

    final teste = User(
      id: id,
      xp: xp,
      name: name,
      email: email,
      level: level,
      goal: goalObject,
      username: username,
      birthDate: birthDate,
      nextLevelXp: nextLevelXp,
    );

    return teste;
  }

  static Goal simpleGoalFromDataResult(Map<String, dynamic> result) {
    final Goal goal = Goal(
      daysPerWeek: result.getValueOrDefault(key: "days", defaultValue: 0),
      dailyDistanceInMeters: result.getValueOrDefault(key: "daily_distance", defaultValue: 0),
      weeklyDistances: weekActivityFromDataResultList(result.getValueOrDefault(key: "week_activities", defaultValue: [])),
    );

    return goal;
  }

  static List<WeekActivity> weekActivityFromDataResultList(List<dynamic> result) {
    return result.map((e) {
      e as Map<String, dynamic>;

      return WeekActivity(
        distanceInMeters: e.getValueOrDefault(key: "distance", defaultValue: 0),
        day: e.getCompleteDateTime(key: "date", defaultValue: "") ?? DateTime.now(),
      );
    }).toList();
  }
}