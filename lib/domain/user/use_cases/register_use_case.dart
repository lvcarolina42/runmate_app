import 'package:runmate_app/domain/utils/result.dart';
import 'package:runmate_app/domain/user/model/user_for_register.dart';
import 'package:runmate_app/domain/user/repository/user_repository.dart';

class RegisterUseCase {
  final UserRepository repository;

  RegisterUseCase({required this.repository});

  Future<Result<bool, Exception>> call({
    required UserForRegister userForRegister,
  }) async {
    return await repository.register(userForRegister: userForRegister);
  }
}