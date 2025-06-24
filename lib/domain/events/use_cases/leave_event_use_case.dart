import 'package:runmate_app/domain/events/repository/events_repository.dart';
import 'package:runmate_app/domain/utils/result.dart';

class LeaveEventUseCase {
  final EventsRepository repository;

  LeaveEventUseCase({required this.repository});

  Future<Result<bool, Exception>> call({required String eventId, required String userId}) async {
    return await repository.leaveEvent(eventId: eventId, userId: userId);
  }
}