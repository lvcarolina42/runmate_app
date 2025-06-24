import 'package:runmate_app/domain/user/repository/user_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class UpdateGoalUseCase {
  final UserRepository repository;

  UpdateGoalUseCase({required this.repository});

  Future<Result<bool, Exception>> call({
    required int days,
    required String id,
    required int distance,
  }) async {
    return await repository.updateGoal(
      userId: id,
      days: days,
      distance: distance,
    );
  }
}