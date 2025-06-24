
import 'dart:convert';

import 'package:runmate_app/domain/api/data_result/data_result.dart';

class RemoteDataResult implements DataResult {
  final dynamic data;

  RemoteDataResult({required this.data});

  Map get jsonData {
    if (data is Map<String, dynamic>) {
      return data;
    } else if (data is String) {
      return jsonDecode(data);
    } else {
      throw Exception("Formato inesperado de result.data: ${data.runtimeType}");
    }
  }
}
