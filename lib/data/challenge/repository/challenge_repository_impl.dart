import 'package:runmate_app/data/api/data_result/remote_data_result.dart';
import 'package:runmate_app/data/challenge/dto/challenge_dto.dart';
import 'package:runmate_app/domain/utils/result.dart';
import 'package:runmate_app/domain/challenge/model/challenge_model.dart';
import 'package:runmate_app/data/challenge/datasource/challenge_datasource.dart';
import 'package:runmate_app/domain/challenge/repository/challenge_repository.dart';

class ChallengeRepositoryImpl implements ChallengeRepository {
  ChallengeDatasource datasource;

  ChallengeRepositoryImpl({required this.datasource});

  @override
  Future<Result<bool, Exception>> createChallenge({required ChallengeModel challenge}) async {
    try {
      final body = challenge.toJson();

      await datasource.create(body: body);

      return Result.success(true);

    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<ChallengeModel>, Exception>> getActiveChallengesByUser({required String userId}) async {
    try {
      final response = await datasource.getChallengesByUser(id: userId);

      final result = ChallengeDto.fromDataResultList(response);

      return Result.success(result);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<ChallengeModel>, Exception>> getAllChallenges({required String userId}) async {
    try {
      final queryParameters = {
        "user_id": userId
      };
      
      final response = await datasource.getAllChallenges(queryParameters: queryParameters);

      final result = ChallengeDto.fromDataResultList(response);

      return Result.success(result);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<ChallengeModel, Exception>> getChallenge({required String challengeId}) async {
    try {
      final response = await datasource.getChallengeById(id: challengeId);

      response as RemoteDataResult;

      final result = ChallengeDto.fromDataResult(response.jsonData);

      return Result.success(result);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> joinTheChallenge({required String userId, required String challengeId}) async {
    try {
      final body = {
        "user_id": userId,
        "challenge_id": challengeId
      };

      await datasource.joinTheChallenge(body: body);

      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }
}