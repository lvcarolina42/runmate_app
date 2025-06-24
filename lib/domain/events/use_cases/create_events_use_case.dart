import 'package:runmate_app/domain/events/model/event_model.dart';
import 'package:runmate_app/domain/events/repository/events_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class CreateEventsUseCase {
  final EventsRepository repository;

  CreateEventsUseCase({required this.repository});
  
  Future<Result<bool, Exception>> call({required DateTime date, required String title}) {
    return repository.createEvent(date: date, title: title);
  }
}