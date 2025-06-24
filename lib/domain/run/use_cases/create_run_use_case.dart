import 'package:runmate_app/domain/run/model/run.dart';
import 'package:runmate_app/domain/run/repository/run_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class CreateRunUseCase {
  final RunRepository repository;

  CreateRunUseCase({required this.repository});

  Future<Result<bool, Exception>> call({
    required Run run,
  }) async {
    return await repository.createRun(run: run);
  }
}