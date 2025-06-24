import 'package:runmate_app/domain/run/model/run.dart';
import 'package:runmate_app/domain/utils/result.dart';

abstract class RunRepository {
  Future<Result<bool, Exception>> createRun({
    required Run run,
  });

  Future<Result<List<Run>, Exception>> getAllRun();

  Future<Result<List<Run>, Exception>> getByUser(String? id);
}
