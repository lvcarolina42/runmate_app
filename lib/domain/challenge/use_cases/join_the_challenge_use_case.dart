import 'package:runmate_app/domain/utils/result.dart';
import 'package:runmate_app/domain/challenge/repository/challenge_repository.dart';

class JoinTheChallengeUseCase {
  final ChallengeRepository repository;

  JoinTheChallengeUseCase({required this.repository});

  Future<Result<bool, Exception>> call({
    required String userId,
    required String challengeId,
  }) async {
    return await repository.joinTheChallenge(
      userId: userId,
      challengeId: challengeId,
    );
  }
}