import 'dart:convert';
import 'package:runmate_app/data/user/dto/user_dto.dart';
import 'package:runmate_app/data/utils/extensions/map_extension.dart';
import 'package:runmate_app/domain/api/data_result/data_result.dart';
import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/data/api/data_result/remote_data_result.dart';

extension ChallengeDto on ChallengeModel {
  static List<ChallengeModel> fromDataResultList(DataResult result) {
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

    final challengeList = parsedList.map((e) => fromDataResult(e as Map<String, dynamic>)).toList();

    return challengeList;
  }

  static ChallengeModel fromDataResult(Map<dynamic, dynamic> result) {
    final DateTime startDate = result.getCompleteDateTime(
      key: 'start_date',
      defaultValue: '',
    ) ?? DateTime.now();

    final DateTime endDate = result.getCompleteDateTime(
      key: 'end_date',
      defaultValue: '',
    ) ?? DateTime.now();

    final List<Ranking> ranking = rankingFromDataResultList(result.getValueOrDefault(key: 'ranking', defaultValue: []));

    return ChallengeModel(
      ranking: ranking,
      endDate: endDate,
      startDate: startDate,
      id: result.getValueOrDefault(key: "id", defaultValue: ""),
      title: result.getValueOrDefault(key: "title", defaultValue: ""),
      createBy: result.getValueOrDefault(key: "create_by", defaultValue: ""),
      distance: result.getValueOrDefault(key: "total_distance", defaultValue: 0),
      isFinished: result.getValueOrDefault(key: "finished", defaultValue: false),
      description: result.getValueOrDefault(key: "description", defaultValue: ""),
      type: getChallengeType(result.getValueOrDefault(key: "type", defaultValue: "date")),
    );
  }

  static List<Ranking> rankingFromDataResultList(List<dynamic> result) {
    return result.map((e) {
      e as Map<String, dynamic>;

      return Ranking(
        distance: e.getValueOrDefault(key: "distance", defaultValue: 0),
        position: e.getValueOrDefault(key: "position", defaultValue: 0),
        user: UserDTO.simpleFromDataResult(RemoteDataResult(data: e.getValueOrDefault(key: "user", defaultValue: {}))),
      );
    }).toList();
  }

  static ChallengeType getChallengeType(String type) {
    switch (type) {
      case "date":
        return ChallengeType.date;
      case "distance":
        return ChallengeType.distance;
      default:
        return ChallengeType.date;
    }
  }
}