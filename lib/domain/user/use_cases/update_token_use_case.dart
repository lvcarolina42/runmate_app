import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:runmate_app/domain/user/repository/user_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class UpdateTokenUseCase {
  final UserRepository repository;

  UpdateTokenUseCase({required this.repository});

  Future<Result<bool, Exception>> call({
    required String userId,
  }) async {
    final fcm = await FirebaseMessaging.instance.getToken();

    if (fcm == null) {
      return Result.failure(Exception("FCM token is null"));
    }
    return await repository.updateToken(token: fcm, userId: userId);
  }
}