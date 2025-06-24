import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/domain/utils/result.dart';

abstract class ChallengeRepository {
  Future<Result<bool, Exception>> createChallenge({
    required ChallengeModel challenge,
  });

  Future<Result<bool, Exception>> joinTheChallenge({
    required String userId,
    required String challengeId,
  });

  Future<Result<ChallengeModel, Exception>> getChallenge({
    required String challengeId,
  });

  Future<Result<List<ChallengeModel>, Exception>> getActiveChallengesByUser({
    required String userId,
  });

  Future<Result<List<ChallengeModel>, Exception>> getAllChallenges({required String userId});
}
