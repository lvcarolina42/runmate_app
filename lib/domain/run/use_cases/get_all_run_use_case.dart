import 'package:runmate_app/domain/utils/result.dart';
import 'package:runmate_app/domain/run/model/run.dart';
import 'package:runmate_app/domain/run/repository/run_repository.dart';

class GetAllRunUseCase {
  final RunRepository repository;

  GetAllRunUseCase({required this.repository});

  Future<Result<List<Run>, Exception>> call() async {
    return await repository.getAllRun();
  }
}