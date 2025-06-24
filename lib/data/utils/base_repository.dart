

import 'package:runmate_app/domain/utils/result.dart';

class BaseRepository {
  Result<T, Exception> handleFailure<T>({
    dynamic error,
    StackTrace? trace,
    required String repositoryName,
  }) {
    if (error is Exception) {
      return Result.failure(error);
    } else {
      return Result.failure(
        Exception('Error in $repositoryName: $error'),
      );
    }
  }
}
