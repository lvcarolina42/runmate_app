import 'dart:convert';

import 'package:runmate_app/data/api/data_result/remote_data_result.dart';
import 'package:runmate_app/data/user/dto/user_dto.dart';
import 'package:runmate_app/data/utils/extensions/map_extension.dart';
import 'package:runmate_app/domain/api/data_result/data_result.dart';
import 'package:runmate_app/domain/run/model/run.dart';
import 'package:runmate_app/domain/user/model/user.dart';

extension RunDto on Run {
  static List<Run> fromDataResultList(DataResult result) {
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
  
  static Run fromDataResult(Map<String, dynamic> result) {
    final User user = UserDTO.simpleFromDataResult(RemoteDataResult(data: result.getValueOrDefault(key: "user", defaultValue: {})));

    final DateTime date = result.getDateTime(
      key: 'date',
    );

    final List<CheckPoint> checkPoints = result.getValueOrDefault(
      key: 'coordinates',
      defaultValue: [],
    ).map((e) {
      e as Map<String, dynamic>;
      final lat = e.getValue(
        key: 'lat',
      );

      final long = e.getValue(
        key: 'long',
      );

      double latDouble = 0.0;
      double longDouble = 0.0;

      if (lat is double) {
        latDouble = lat;
      } else if (lat is int) {
        latDouble = lat.toDouble();
      }

      if (long is double) {
        longDouble = long;
      } else if (long is int) {
        longDouble = long.toDouble();
      }

      return CheckPoint(
        latitude: latDouble,
        longitude: longDouble,
      );
    }).toList();


    return Run(
      date: date,
      distance: result.getValueOrDefault(
        key: 'distance',
        defaultValue: 0,
      ),
      duration: Duration(seconds: result.getValueOrDefault(
        key: 'duration',
        defaultValue: 0,
      )),
      title: result.getValueOrDefault(
        key: 'title',
        defaultValue: '',
      ),
      id: result.getValueOrDefault(
        key: 'id',
        defaultValue: '',
      ),
      username: user.name,
      userId: result.getValueOrDefault(
        key: 'user_id',
        defaultValue: '',
      ),
      checkPoints: checkPoints,
    );
  }
}