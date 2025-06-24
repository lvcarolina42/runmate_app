// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart';
import 'package:runmate_app/domain/api/client/api.dart';
import 'package:runmate_app/shared/constants/project_constants.dart';

class GoDefaultClient implements Api {
  @override
  late final Dio client;
  
  GoDefaultClient() {
    client = Dio()
      ..options.connectTimeout = const Duration(milliseconds: 80000)
      ..httpClientAdapter = GetPlatform.isWeb ? HttpClientAdapter() : IOHttpClientAdapter()
      ..options.baseUrl = goBaseUrl
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          
          print('[REQUEST]');
          print('URL: ${options.baseUrl}${options.path}');
          print('Headers: ${options.headers}');
          print('Body: ${options.data}');
          print('Query Parameters: ${options.queryParameters}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('[RESPONSE]');
          print('Status Code: ${response.statusCode}');
          print('Data: ${response.data}');
          handler.next(response);
        },
        onError: (DioException e, handler) {
          print('[ERROR]');
          print('Message: ${e.message}');
          print('Response: ${e.response?.data}');
          print('Status Code: ${e.response?.statusCode}');
          handler.next(e);
        }
      ));
  }
}
