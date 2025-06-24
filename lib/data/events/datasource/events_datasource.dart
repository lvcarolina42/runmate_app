import 'dart:async';
import 'package:runmate_app/data/api/go_api_handler_impl.dart';
import 'package:runmate_app/shared/statics/endpoints.dart';

class EventsDatasource {
  final GoApiHandlerImpl apiHandler;

  EventsDatasource({required this.apiHandler});

  Future<dynamic> createEvent({dynamic body}) async {
    return await apiHandler.post(Endpoints.events, body);
  }

  Future<dynamic> joinEvent({dynamic body}) async {
    return await apiHandler.put("${Endpoints.events}/join", body);
  }

  Future<dynamic> getMyEvents({String id = ""}) async {
    return await apiHandler.get("${Endpoints.users}/$id${Endpoints.events}");
  }

  Future<dynamic> getAllEvents({Map<String, dynamic>? queryParameters}) async {
    return await apiHandler.get(Endpoints.events, queryParameters: queryParameters);
  }

  Future<dynamic> getEventById({String id = ""}) async {
    return await apiHandler.get("${Endpoints.events}/$id");
  }

  Future<dynamic> leaveEvent({dynamic body}) async {
    return await apiHandler.put("${Endpoints.events}/quit", body);
  }
}
