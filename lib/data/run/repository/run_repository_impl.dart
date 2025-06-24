import 'package:runmate_app/data/run/dto/run_dto.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/domain/utils/result.dart';
import 'package:runmate_app/domain/run/model/run.dart';
import 'package:runmate_app/data/run/datasource/run_datasource.dart';
import 'package:runmate_app/domain/run/repository/run_repository.dart';

class RunRepositoryImpl implements RunRepository {
  RunDatasource datasource;

  RunRepositoryImpl({required this.datasource});

  @override
  Future<Result<bool, Exception>> createRun({
    required Run run,
  }) async {
    try {
      final body = run.toJson();

      await datasource.create(body: body);

      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Run>, Exception>> getAllRun() async {
    try {
      final response = await datasource.getAll(id: SessionManager().currentUser!.id);

      final result = RunDto.fromDataResultList(response);

      return Result.success(result);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Run>, Exception>> getByUser(String? id) async {
    try {
      final response = await datasource.getByUser(id: id ?? "");

      final result = RunDto.fromDataResultList(response);

      return Result.success(result);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }
}
