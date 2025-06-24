// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'running_monitor_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RunningMonitorController on RunningMonitorControllerStore, Store {
  Computed<mapbox.CameraOptions>? _$cameraComputed;

  @override
  mapbox.CameraOptions get camera =>
      (_$cameraComputed ??= Computed<mapbox.CameraOptions>(() => super.camera,
              name: 'RunningMonitorControllerStore.camera'))
          .value;
  Computed<mapbox.Position>? _$positionComputed;

  @override
  mapbox.Position get position =>
      (_$positionComputed ??= Computed<mapbox.Position>(() => super.position,
              name: 'RunningMonitorControllerStore.position'))
          .value;
  Computed<LatLng>? _$coordinatesComputed;

  @override
  LatLng get coordinates =>
      (_$coordinatesComputed ??= Computed<LatLng>(() => super.coordinates,
              name: 'RunningMonitorControllerStore.coordinates'))
          .value;

  late final _$_positionAtom =
      Atom(name: 'RunningMonitorControllerStore._position', context: context);

  @override
  mapbox.Position get _position {
    _$_positionAtom.reportRead();
    return super._position;
  }

  @override
  set _position(mapbox.Position value) {
    _$_positionAtom.reportWrite(value, super._position, () {
      super._position = value;
    });
  }

  late final _$_latitudeAtom =
      Atom(name: 'RunningMonitorControllerStore._latitude', context: context);

  @override
  double get _latitude {
    _$_latitudeAtom.reportRead();
    return super._latitude;
  }

  @override
  set _latitude(double value) {
    _$_latitudeAtom.reportWrite(value, super._latitude, () {
      super._latitude = value;
    });
  }

  late final _$_longitudeAtom =
      Atom(name: 'RunningMonitorControllerStore._longitude', context: context);

  @override
  double get _longitude {
    _$_longitudeAtom.reportRead();
    return super._longitude;
  }

  @override
  set _longitude(double value) {
    _$_longitudeAtom.reportWrite(value, super._longitude, () {
      super._longitude = value;
    });
  }

  @override
  String toString() {
    return '''
camera: ${camera},
position: ${position},
coordinates: ${coordinates}
    ''';
  }
}
