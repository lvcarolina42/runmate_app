// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'running_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RunningController on RunningControllerStore, Store {
  Computed<double>? _$totalDistanceComputed;

  @override
  double get totalDistance =>
      (_$totalDistanceComputed ??= Computed<double>(() => super.totalDistance,
              name: 'RunningControllerStore.totalDistance'))
          .value;
  Computed<String>? _$averageSpeedComputed;

  @override
  String get averageSpeed =>
      (_$averageSpeedComputed ??= Computed<String>(() => super.averageSpeed,
              name: 'RunningControllerStore.averageSpeed'))
          .value;
  Computed<String>? _$paceComputed;

  @override
  String get pace => (_$paceComputed ??= Computed<String>(() => super.pace,
          name: 'RunningControllerStore.pace'))
      .value;
  Computed<String>? _$distanceInKmComputed;

  @override
  String get distanceInKm =>
      (_$distanceInKmComputed ??= Computed<String>(() => super.distanceInKm,
              name: 'RunningControllerStore.distanceInKm'))
          .value;
  Computed<Duration>? _$elapsedTimeComputed;

  @override
  Duration get elapsedTime =>
      (_$elapsedTimeComputed ??= Computed<Duration>(() => super.elapsedTime,
              name: 'RunningControllerStore.elapsedTime'))
          .value;
  Computed<bool>? _$isTrackingComputed;

  @override
  bool get isTracking =>
      (_$isTrackingComputed ??= Computed<bool>(() => super.isTracking,
              name: 'RunningControllerStore.isTracking'))
          .value;

  late final _$_totalDistanceAtom =
      Atom(name: 'RunningControllerStore._totalDistance', context: context);

  @override
  double get _totalDistance {
    _$_totalDistanceAtom.reportRead();
    return super._totalDistance;
  }

  @override
  set _totalDistance(double value) {
    _$_totalDistanceAtom.reportWrite(value, super._totalDistance, () {
      super._totalDistance = value;
    });
  }

  late final _$_averageSpeedAtom =
      Atom(name: 'RunningControllerStore._averageSpeed', context: context);

  @override
  double get _averageSpeed {
    _$_averageSpeedAtom.reportRead();
    return super._averageSpeed;
  }

  @override
  set _averageSpeed(double value) {
    _$_averageSpeedAtom.reportWrite(value, super._averageSpeed, () {
      super._averageSpeed = value;
    });
  }

  late final _$_paceAtom =
      Atom(name: 'RunningControllerStore._pace', context: context);

  @override
  double get _pace {
    _$_paceAtom.reportRead();
    return super._pace;
  }

  @override
  set _pace(double value) {
    _$_paceAtom.reportWrite(value, super._pace, () {
      super._pace = value;
    });
  }

  late final _$_elapsedTimeAtom =
      Atom(name: 'RunningControllerStore._elapsedTime', context: context);

  @override
  Duration get _elapsedTime {
    _$_elapsedTimeAtom.reportRead();
    return super._elapsedTime;
  }

  @override
  set _elapsedTime(Duration value) {
    _$_elapsedTimeAtom.reportWrite(value, super._elapsedTime, () {
      super._elapsedTime = value;
    });
  }

  late final _$_isTrackingAtom =
      Atom(name: 'RunningControllerStore._isTracking', context: context);

  @override
  bool get _isTracking {
    _$_isTrackingAtom.reportRead();
    return super._isTracking;
  }

  @override
  set _isTracking(bool value) {
    _$_isTrackingAtom.reportWrite(value, super._isTracking, () {
      super._isTracking = value;
    });
  }

  @override
  String toString() {
    return '''
totalDistance: ${totalDistance},
averageSpeed: ${averageSpeed},
pace: ${pace},
distanceInKm: ${distanceInKm},
elapsedTime: ${elapsedTime},
isTracking: ${isTracking}
    ''';
  }
}
