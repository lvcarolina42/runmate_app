import 'package:runmate_app/domain/user/session_manager.dart';

class Run {
  final String id;
  final String title;
  final int distance;
  final String userId;
  final DateTime date;
  final String username;
  final Duration duration;
  final List<CheckPoint> checkPoints;

  Run({
    required this.id,
    required this.date,
    required this.title,
    required this.userId,
    required this.username,
    required this.duration,
    required this.distance,
    required this.checkPoints,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "distance": distance,
      "duration": duration.inSeconds,
      "date": date.toUtc().toIso8601String(),
      "user_id": SessionManager().currentUser?.id,
      "coordinates": checkPoints.map((e) => e.toJson()).toList(),
    };
  }
}

class CheckPoint {
  final double latitude;
  final double longitude;

  CheckPoint({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'long': longitude,
    };
  }
}
