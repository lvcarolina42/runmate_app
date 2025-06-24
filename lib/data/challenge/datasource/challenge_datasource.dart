import 'dart:async';
import 'package:runmate_app/data/api/go_api_handler_impl.dart';
import 'package:runmate_app/shared/statics/endpoints.dart';

class ChallengeDatasource {
  final GoApiHandlerImpl apiHandler;

  ChallengeDatasource({required this.apiHandler});
  
  Future<dynamic> create({dynamic body}) async {
    return await apiHandler.post(Endpoints.challenges, body);
  }

  Future<dynamic> joinTheChallenge({dynamic body}) async {
    return await apiHandler.put("${Endpoints.challenges}/join", body);
  }

  Future<dynamic> getChallengesByUser({String id = ""}) async {
    return await apiHandler.get("${Endpoints.users}/$id${Endpoints.challenges}");
  }

  Future<dynamic> getAllChallenges({Map<String, dynamic>? queryParameters}) async {
    return await apiHandler.get(Endpoints.challenges, queryParameters: queryParameters);
  }

  Future<dynamic> getChallengeById({String id = ""}) async {
    return await apiHandler.get("${Endpoints.challenges}/$id");
  }
}
