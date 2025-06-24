import 'dart:async';

class AppListenerEvents {
  static final AppListenerEvents _instance = AppListenerEvents._internal();
  factory AppListenerEvents() => _instance;
  AppListenerEvents._internal();

  final Map<Type, List<FutureOr Function()>> _callbacks = {};

  void add(AppEvent event) {
    _callbacks.forEach((type, callbacks) {
      if (event.runtimeType == type) {
        for (var callback in callbacks) {
          callback();
        }
      }
    });
  }

  void on<T extends AppEvent>(FutureOr Function() callback) {
    _callbacks[T] ??= [];
    _callbacks[T]!.add(callback);
  }
}

sealed class AppEvent {}

class ChallengeEvent extends AppEvent {}

class UserEvent extends AppEvent {}

class RunEvent extends AppEvent {}
