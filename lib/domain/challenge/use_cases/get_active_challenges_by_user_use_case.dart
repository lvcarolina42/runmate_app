import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/domain/challenge/repository/challenge_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class GetActiveChallengesByUserUseCase {
  final ChallengeRepository repository;

  GetActiveChallengesByUserUseCase({required this.repository});

  Future<Result<List<ChallengeModel>, Exception>> call(String id) async {
    return await repository.getActiveChallengesByUser(userId: id);
  }
}