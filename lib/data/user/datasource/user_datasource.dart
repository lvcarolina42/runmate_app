import 'dart:async';

import 'package:runmate_app/data/api/go_api_handler_impl.dart';
import 'package:runmate_app/shared/statics/endpoints.dart';

class UserDatasource {
  final GoApiHandlerImpl apiHandler;

  UserDatasource({required this.apiHandler});

  Future<dynamic> login({dynamic body}) async {
    return await apiHandler.post(Endpoints.auth, body);
  }

  Future<dynamic> register({dynamic body}) async {
    return await apiHandler.post(Endpoints.users, body);
  }

  Future<dynamic> getUser({required String username}) async {
    return await apiHandler.get("${Endpoints.users}/$username");
  }

  Future<dynamic> getUserById({required String id}) async {
    return await apiHandler.get("${Endpoints.users}/$id");
  }

  Future<dynamic> getUsers({required String id}) async {
    final queryParameters = {"user_id": id};
    return await apiHandler.get(Endpoints.users, queryParameters: queryParameters);
  }

  Future<dynamic> getFriends({required String id}) async {
    return await apiHandler.get("${Endpoints.users}/$id/friends");
  }

  Future<dynamic> follow({required dynamic body}) async {
    return await apiHandler.post("/friends", body);
  }

  Future<dynamic> unfollow({required dynamic body}) async {
    return await apiHandler.delete("/friends", body);
  }

  Future<dynamic> updateToken({required dynamic body, required String userId}) async {
    return await apiHandler.put("${Endpoints.users}/$userId/fcm", body);
  }

  Future<dynamic> updateGoal({required dynamic body, required String userId}) async {
    return await apiHandler.put("${Endpoints.users}/$userId/goal", body);
  }

  Future<dynamic> deleteGoal({required String userId}) async {
    return await apiHandler.delete("${Endpoints.users}/$userId/goal");
  }
}
