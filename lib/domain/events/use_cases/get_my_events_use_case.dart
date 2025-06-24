import 'package:runmate_app/domain/events/model/event_model.dart';
import 'package:runmate_app/domain/events/repository/events_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class GetMyEventsUseCase {
  final EventsRepository repository;

  GetMyEventsUseCase({required this.repository});

  Future<Result<List<EventModel>, Exception>> call({required String userId}) async {
    return await repository.getMyEvents(userId: userId);
  }
}