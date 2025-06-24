import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/repository/user_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class LoginUseCase {
  final UserRepository repository;

  LoginUseCase({required this.repository});

  Future<Result<User, Exception>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(username: email, password: password);
  }
}