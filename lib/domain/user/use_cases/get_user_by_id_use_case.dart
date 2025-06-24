import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/repository/user_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class GetUserByIdUseCase {
  final UserRepository repository;

  GetUserByIdUseCase({required this.repository});

  Future<Result<User, Exception>> call() async {
    return await repository.getUserById();
  }
}