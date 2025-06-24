import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/domain/challenge/repository/challenge_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class GetAllChallengesUseCase {
  final ChallengeRepository repository;

  GetAllChallengesUseCase({required this.repository});

  Future<Result<List<ChallengeModel>, Exception>> call(String id) async {
    return await repository.getAllChallenges(userId: id);
  }
}