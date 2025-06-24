import 'package:runmate_app/domain/utils/result.dart';
import 'package:runmate_app/domain/run/model/run.dart';
import 'package:runmate_app/domain/run/repository/run_repository.dart';

class GetRunByUserUseCase {
  final RunRepository repository;

  GetRunByUserUseCase({required this.repository});

  Future<Result<List<Run>, Exception>> call(String id) async {
    return await repository.getByUser(id);
  }
}