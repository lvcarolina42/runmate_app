import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:runmate_app/data/api/client/go_default_client.dart';
import 'package:runmate_app/data/api/data_result/remote_data_result.dart';
import 'package:runmate_app/domain/api/api_handler.dart';
import 'package:runmate_app/domain/api/data_result/data_result.dart';

class GoApiHandlerImpl implements ApiHandler {
  final GoDefaultClient api;
  GoApiHandlerImpl(this.api);

  @override
  Future<DataResult> delete(String path, [Map<String, dynamic>? queryParameters]) async {
    final response = await api.client.delete(path, queryParameters: queryParameters, data: queryParameters);
    return RemoteDataResult(data: response.data);
  }

  @override
  Future<DataResult> get(
    String path, {
    Map? body,
    Options? options,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await api.client.get(
      path,
      options: options,
      data: json.encode(body),
      cancelToken: cancelToken,
      queryParameters: queryParameters,
    );
    return RemoteDataResult(data: response.data);
  }

  @override
  Future<DataResult> post(String path, Map body, [Map<String, dynamic>? queryParameters]) async {
    final response = await api.client.post(path, data: json.encode(body), queryParameters: queryParameters);
    return RemoteDataResult(data: response.data);
  }

  @override
  Future<DataResult> put(String path, Map body, [Map<String, dynamic>? queryParameters]) async {
    final response = await api.client.put(path, data: json.encode(body), queryParameters: queryParameters);
    return RemoteDataResult(data: response.data);
  }
}
