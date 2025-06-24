import 'package:dio/dio.dart';
import 'package:runmate_app/domain/api/data_result/data_result.dart';

abstract class ApiHandler {
  Future<DataResult> delete(String path, [Map<String, dynamic>? queryParameters]);
  
  Future<DataResult> post(String path, Map body, [Map<String, dynamic>? queryParameters]);

  Future<DataResult> put(String path, Map body, [Map<String, dynamic>? queryParameters]);

  Future<DataResult> get(
    String path, {
    Map? body,
    Options? options,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
  });
}
