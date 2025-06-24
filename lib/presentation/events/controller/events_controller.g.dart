// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EventsController on EventsControllerStore, Store {
  Computed<User?>? _$userComputed;

  @override
  User? get user => (_$userComputed ??=
          Computed<User?>(() => super.user, name: 'EventsControllerStore.user'))
      .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: 'EventsControllerStore.isLoading'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'EventsControllerStore.hasError'))
          .value;
  Computed<ObservableList<EventModel>>? _$myEventsComputed;

  @override
  ObservableList<EventModel> get myEvents => (_$myEventsComputed ??=
          Computed<ObservableList<EventModel>>(() => super.myEvents,
              name: 'EventsControllerStore.myEvents'))
      .value;
  Computed<ObservableList<EventModel>>? _$allEventsComputed;

  @override
  ObservableList<EventModel> get allEvents => (_$allEventsComputed ??=
          Computed<ObservableList<EventModel>>(() => super.allEvents,
              name: 'EventsControllerStore.allEvents'))
      .value;

  late final _$_userAtom =
      Atom(name: 'EventsControllerStore._user', context: context);

  @override
  User? get _user {
    _$_userAtom.reportRead();
    return super._user;
  }

  @override
  set _user(User? value) {
    _$_userAtom.reportWrite(value, super._user, () {
      super._user = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: 'EventsControllerStore._isLoading', context: context);

  @override
  bool get _isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  late final _$_hasErrorAtom =
      Atom(name: 'EventsControllerStore._hasError', context: context);

  @override
  bool get _hasError {
    _$_hasErrorAtom.reportRead();
    return super._hasError;
  }

  @override
  set _hasError(bool value) {
    _$_hasErrorAtom.reportWrite(value, super._hasError, () {
      super._hasError = value;
    });
  }

  late final _$_myEventsAtom =
      Atom(name: 'EventsControllerStore._myEvents', context: context);

  @override
  ObservableList<EventModel> get _myEvents {
    _$_myEventsAtom.reportRead();
    return super._myEvents;
  }

  @override
  set _myEvents(ObservableList<EventModel> value) {
    _$_myEventsAtom.reportWrite(value, super._myEvents, () {
      super._myEvents = value;
    });
  }

  late final _$_allEventsAtom =
      Atom(name: 'EventsControllerStore._allEvents', context: context);

  @override
  ObservableList<EventModel> get _allEvents {
    _$_allEventsAtom.reportRead();
    return super._allEvents;
  }

  @override
  set _allEvents(ObservableList<EventModel> value) {
    _$_allEventsAtom.reportWrite(value, super._allEvents, () {
      super._allEvents = value;
    });
  }

  late final _$getAllEventsAsyncAction =
      AsyncAction('EventsControllerStore.getAllEvents', context: context);

  @override
  Future<void> getAllEvents() {
    return _$getAllEventsAsyncAction.run(() => super.getAllEvents());
  }

  late final _$getMyEventsAsyncAction =
      AsyncAction('EventsControllerStore.getMyEvents', context: context);

  @override
  Future<void> getMyEvents() {
    return _$getMyEventsAsyncAction.run(() => super.getMyEvents());
  }

  late final _$joinEventAsyncAction =
      AsyncAction('EventsControllerStore.joinEvent', context: context);

  @override
  Future<void> joinEvent(String eventId) {
    return _$joinEventAsyncAction.run(() => super.joinEvent(eventId));
  }

  late final _$leaveEventAsyncAction =
      AsyncAction('EventsControllerStore.leaveEvent', context: context);

  @override
  Future<void> leaveEvent(String eventId) {
    return _$leaveEventAsyncAction.run(() => super.leaveEvent(eventId));
  }

  late final _$createEventAsyncAction =
      AsyncAction('EventsControllerStore.createEvent', context: context);

  @override
  Future<void> createEvent({required DateTime date, required String title}) {
    return _$createEventAsyncAction
        .run(() => super.createEvent(date: date, title: title));
  }

  @override
  String toString() {
    return '''
user: ${user},
isLoading: ${isLoading},
hasError: ${hasError},
myEvents: ${myEvents},
allEvents: ${allEvents}
    ''';
  }
}
