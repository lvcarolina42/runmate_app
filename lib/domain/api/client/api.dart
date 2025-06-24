import 'package:dio/dio.dart';

abstract class Api {
  final Dio client;
  Api({required this.client});
}
