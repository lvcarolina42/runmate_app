import 'package:runmate_app/domain/events/model/event_model.dart';
import 'package:runmate_app/domain/events/repository/events_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class GetEventByIdUseCase {
  final EventsRepository repository;

  GetEventByIdUseCase({required this.repository});

  Future<Result<EventModel, Exception>> call({required String eventId}) async {
    return await repository.getEventById(eventId: eventId);
  }
}