import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/domain/challenge/repository/challenge_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class GetChallengeByIdUseCase {
  final ChallengeRepository repository;

  GetChallengeByIdUseCase({required this.repository});

  Future<Result<ChallengeModel, Exception>> call({
    required String id,
  }) async {
    return await repository.getChallenge(challengeId: id);
  }
}