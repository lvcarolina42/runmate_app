import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/repository/user_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class GetFriendsUseCase {
  final UserRepository repository;

  GetFriendsUseCase({required this.repository});

  Future<Result<List<User>, Exception>> call({
    required String id,
  }) async {
    return await repository.getFriends(id: id);
  }
}