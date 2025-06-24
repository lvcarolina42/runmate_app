import 'package:runmate_app/data/events/datasource/events_datasource.dart';
import 'package:runmate_app/data/events/dto/event_dto.dart';
import 'package:runmate_app/data/run/dto/run_dto.dart';
import 'package:runmate_app/domain/events/model/event_model.dart';
import 'package:runmate_app/domain/events/repository/events_repository.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/domain/utils/result.dart';
import 'package:runmate_app/domain/run/model/run.dart';
import 'package:runmate_app/data/run/datasource/run_datasource.dart';
import 'package:runmate_app/domain/run/repository/run_repository.dart';

class EventsRepositoryImpl implements EventsRepository {
  EventsDatasource datasource;

  EventsRepositoryImpl({required this.datasource});

  @override
  Future<Result<bool, Exception>> createEvent({required DateTime date, required String title}) async{
    try {
      await datasource.createEvent(body: EventDto.toDataResult(date: date, title: title));

      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<EventModel>, Exception>> getAllEvents() async {
    try {
      final queryParameters = {
        "user_id": SessionManager().currentUser!.id
      };

      final result = await datasource.getAllEvents(queryParameters: queryParameters);

      final events = EventDto.fromDataResultList(result);

      return Result.success(events);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<EventModel>, Exception>> getMyEvents({required String userId}) async {
    try {
      final result = await datasource.getMyEvents(id: userId);

      final events = EventDto.fromDataResultList(result);

      return Result.success(events);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<EventModel, Exception>> getEventById({required String eventId}) async {
    try {
      final result = await datasource.getEventById(id: eventId);

      final event = EventDto.fromDataResult(result);

      return Result.success(event);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> joinEvent({required String eventId, required String userId}) async {
    try {
      await datasource.joinEvent(body: {
        "event_id": eventId,
        "user_id": userId
      });

      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> leaveEvent({required String eventId, required String userId}) async {
    try {
      await datasource.leaveEvent(body: {
        "event_id": eventId,
        "user_id": userId
      });

      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }
}