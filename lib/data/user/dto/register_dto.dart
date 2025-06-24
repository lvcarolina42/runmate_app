import 'package:runmate_app/data/api/data_result/remote_data_result.dart';
import 'package:runmate_app/data/utils/extensions/map_extension.dart';
import 'package:runmate_app/domain/api/api.dart';

extension RegisterDto on bool {
  static bool fromDataResult(DataResult result) {
    result as RemoteDataResult;

    final data = result.data as Map<String, dynamic>;

    final bool success = data.getValueOrDefault(
      key: 'success',
      defaultValue: false,
    );

    return success;
  }
}