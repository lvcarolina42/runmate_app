import 'package:runmate_app/domain/events/model/event_model.dart';
import 'package:runmate_app/domain/utils/result.dart';

abstract class EventsRepository {
  Future<Result<bool, Exception>> createEvent({required DateTime date, required String title});

  Future<Result<EventModel, Exception>> getEventById({
    required String eventId,
  });

  Future<Result<bool, Exception>> joinEvent({
    required String eventId,
    required String userId,
  });

  Future<Result<bool, Exception>> leaveEvent({
    required String eventId,
    required String userId,
  });

  Future<Result<List<EventModel>, Exception>> getAllEvents();

  Future<Result<List<EventModel>, Exception>> getMyEvents({required String userId});
}
