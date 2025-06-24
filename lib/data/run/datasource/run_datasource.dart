import 'dart:async';
import 'package:runmate_app/data/api/go_api_handler_impl.dart';
import 'package:runmate_app/shared/statics/endpoints.dart';

class RunDatasource {
  final GoApiHandlerImpl apiHandler;

  RunDatasource({required this.apiHandler});

  Future<dynamic> create({dynamic body}) async {
    return await apiHandler.post(Endpoints.activities, body);
  }

  Future<dynamic> getAll({required String id}) async {
    return await apiHandler.get("${Endpoints.users}/$id/friends/activities");
  }

  Future<dynamic> getByUser({String id = ""}) async {
    return await apiHandler.get("${Endpoints.users}/$id${Endpoints.activities}");
  }
}
