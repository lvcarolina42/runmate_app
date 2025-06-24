import 'package:runmate_app/domain/user/model/user.dart';

class MessageModel {
  final User user;
  final DateTime date;
  final String content;

  MessageModel({required this.user, required this.date, required this.content});
}
