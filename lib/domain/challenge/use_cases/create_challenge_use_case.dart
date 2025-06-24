import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/domain/challenge/repository/challenge_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class CreateChallengeUseCase {
  final ChallengeRepository repository;

  CreateChallengeUseCase({required this.repository});

  Future<Result<bool, Exception>> call({
    required ChallengeModel challenge,
  }) async {
    return await repository.createChallenge(challenge: challenge);
  }
}