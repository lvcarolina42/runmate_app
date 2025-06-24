import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/repository/user_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase({required this.repository});

  Future<Result<List<User>, Exception>> call({
    required String id,
  }) async {
    return await repository.getUsers(id: id);
  }
}