import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/repository/user_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class RemoveFriendUseCase {
  final UserRepository repository;

  RemoveFriendUseCase({required this.repository});

  Future<Result<bool, Exception>> call({
    required String userId,
    required String friendId,
  }) async {
    return await repository.removeFriend(userid: userId, friendId: friendId);
  }
}