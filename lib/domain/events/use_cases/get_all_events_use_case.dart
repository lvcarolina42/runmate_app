import 'package:runmate_app/domain/events/model/event_model.dart';
import 'package:runmate_app/domain/events/repository/events_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class GetAllEventsUseCase {
  final EventsRepository repository;

  GetAllEventsUseCase({required this.repository});

  Future<Result<List<EventModel>, Exception>> call() async {
    return await repository.getAllEvents();
  }
}