import 'package:runmate_app/domain/user/model/user.dart';

class EventModel {
  final String id;
  final String title;
  final DateTime date;
  final bool finished;
  List<User> participants;

  EventModel({
    required this.id,
    required this.date,
    required this.title,
    required this.finished,
    required this.participants,
  });
}
