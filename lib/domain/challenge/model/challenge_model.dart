import 'package:runmate_app/domain/user/model/user.dart';

enum ChallengeType {
  date("date"),
  distance("distance");

  final String value;

  const ChallengeType(this.value);
}

class ChallengeModel {
  final String id;
  final String title;
  final int? distance;
  final String createBy;
  final DateTime endDate;
  final bool? isFinished;
  final String description;
  final ChallengeType type;
  final DateTime startDate;
  final List<Ranking> ranking;

  ChallengeModel({
    this.distance,
    this.isFinished,
    required this.id,
    required this.type,
    required this.title,
    required this.ranking,
    required this.endDate,
    required this.createBy,
    required this.startDate,
    required this.description,
  });

  ChallengeModel.empty()
      : this(
          id: "",
          type: ChallengeType.date,
          title: "",
          endDate: DateTime.now(),
          createBy: "",
          startDate: DateTime.now(),
          description: "",
          ranking: [],
  );

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "type": type.value,
      "created_by": createBy,
      "description": description,
      "start_date": startDate.toUtc().toIso8601String(),
      "total_distance": type == ChallengeType.distance ? distance : null,
      "end_date": type == ChallengeType.date ? endDate.toUtc().toIso8601String() : null,
    };
  }
}

class Ranking {
  final User user;
  final int position;
  final int distance;

  Ranking({required this.user, required this.position, required this.distance});
}
