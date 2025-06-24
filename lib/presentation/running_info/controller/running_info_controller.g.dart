// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'running_info_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RunningInfoController on RunningInfoControllerStore, Store {
  Computed<String>? _$timeComputed;

  @override
  String get time => (_$timeComputed ??= Computed<String>(() => super.time,
          name: 'RunningInfoControllerStore.time'))
      .value;
  Computed<String>? _$distanceComputed;

  @override
  String get distance =>
      (_$distanceComputed ??= Computed<String>(() => super.distance,
              name: 'RunningInfoControllerStore.distance'))
          .value;
  Computed<String>? _$averageSpeedComputed;

  @override
  String get averageSpeed =>
      (_$averageSpeedComputed ??= Computed<String>(() => super.averageSpeed,
              name: 'RunningInfoControllerStore.averageSpeed'))
          .value;
  Computed<String>? _$paceComputed;

  @override
  String get pace => (_$paceComputed ??= Computed<String>(() => super.pace,
          name: 'RunningInfoControllerStore.pace'))
      .value;
  Computed<List<LatLng>>? _$routeCoordinatesComputed;

  @override
  List<LatLng> get routeCoordinates => (_$routeCoordinatesComputed ??=
          Computed<List<LatLng>>(() => super.routeCoordinates,
              name: 'RunningInfoControllerStore.routeCoordinates'))
      .value;

  late final _$_argsAtom =
      Atom(name: 'RunningInfoControllerStore._args', context: context);

  @override
  RunningInfoArgs get _args {
    _$_argsAtom.reportRead();
    return super._args;
  }

  @override
  set _args(RunningInfoArgs value) {
    _$_argsAtom.reportWrite(value, super._args, () {
      super._args = value;
    });
  }

  @override
  String toString() {
    return '''
time: ${time},
distance: ${distance},
averageSpeed: ${averageSpeed},
pace: ${pace},
routeCoordinates: ${routeCoordinates}
    ''';
  }
}
