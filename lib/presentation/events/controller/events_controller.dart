import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/domain/events/use_cases/get_all_events_use_case.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/domain/events/model/event_model.dart';
import 'package:runmate_app/domain/events/use_cases/get_my_events_use_case.dart';
import 'package:runmate_app/domain/events/use_cases/join_event_use_case.dart';
import 'package:runmate_app/domain/events/use_cases/leave_event_use_case.dart';
import 'package:runmate_app/domain/events/use_cases/create_events_use_case.dart';

part 'events_controller.g.dart';

class EventsController = EventsControllerStore with _$EventsController;

abstract class EventsControllerStore extends DisposableInterface with Store {
  final JoinEventUseCase joinEventUseCase;
  final LeaveEventUseCase leaveEventUseCase;
  final GetMyEventsUseCase getMyEventsUseCase;
  final GetAllEventsUseCase getAllEventsUseCase;
  final CreateEventsUseCase createEventsUseCase;

  EventsControllerStore({
    required this.joinEventUseCase,
    required this.leaveEventUseCase,
    required this.getMyEventsUseCase,
    required this.getAllEventsUseCase,
    required this.createEventsUseCase,
  });

  @observable
  User? _user = SessionManager().currentUser;
  
  @computed
  User? get user => _user;

  @observable
  bool _isLoading = false;

  @computed
  bool get isLoading => _isLoading;

  @observable
  bool _hasError = false;

  @computed
  bool get hasError => _hasError;

  @observable
  ObservableList<EventModel> _myEvents = ObservableList<EventModel>();

  @computed
  ObservableList<EventModel> get myEvents => _myEvents;

  @observable
  ObservableList<EventModel> _allEvents = ObservableList<EventModel>();

  @computed
  ObservableList<EventModel> get allEvents => _allEvents;

  @override
  void onInit() {
    super.onInit();
    onInitialize();
  }

  Future<void> onInitialize() async {
    await getAllEvents();
    await getMyEvents();
  }

  @action
  Future<void> getAllEvents() async {
    _isLoading = true;
    final result = await getAllEventsUseCase();
    result.processResult(
      onSuccess: (data) {
        _allEvents = ObservableList.of(data);
      },
      onFailure: (error) {
        _hasError = true;
      },
    );
    _isLoading = false;
  }

  @action
  Future<void> getMyEvents() async {
    _isLoading = true;
    final result = await getMyEventsUseCase(userId: _user!.id);
    result.processResult(
      onSuccess: (data) {
        _myEvents = ObservableList.of(data);
      },
      onFailure: (error) {
        _hasError = true;
      },
    );
    _isLoading = false;
  }
  
  @action
  Future<void> joinEvent(String eventId) async {
    final result = await joinEventUseCase(eventId: eventId, userId: _user!.id);

    result.processResult(
      onSuccess: (data) {
        onInitialize();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.green,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Inscricao realizada com sucesso"),
          ),
        );
      },
      onFailure: (error) {
        _hasError = true;
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.red,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Inscricao nao realizada"),
          ),
        );
      },
    );
  }
  
  @action
  Future<void> leaveEvent(String eventId) async {
    final result = await leaveEventUseCase(eventId: eventId, userId: _user!.id);

    result.processResult(
      onSuccess: (data) {
        onInitialize();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.green,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Saida realizada com sucesso"),
          ),
        );
      },
      onFailure: (error) {
        _hasError = true;
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.red,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Saida nao realizada"),
          ),
        );
      },
    );
  }

  @action
  Future<void> createEvent({required DateTime date, required String title}) async {
    final result = await createEventsUseCase(date: date, title: title);

    result.processResult(
      onSuccess: (data) {
        onInitialize();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.green,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Evento criado com sucesso"),
          ),
        );
      },
      onFailure: (error) {
        _hasError = true;
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            elevation: 16,
            backgroundColor: Colors.red,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Text("Evento nao criado"),
          ),
        );
      },
    );
  }
}

