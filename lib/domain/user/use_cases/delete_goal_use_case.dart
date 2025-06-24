import 'package:runmate_app/domain/user/repository/user_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class DeleteGoalUseCase {
  final UserRepository repository;

  DeleteGoalUseCase({required this.repository});

  Future<Result<bool, Exception>> call({
    required String id,
  }) async {
    return await repository.deleteGoal(userId: id);
  }
}