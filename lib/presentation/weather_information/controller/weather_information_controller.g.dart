// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_information_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WeatherInformationController
    on WeatherInformationControllerStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: 'WeatherInformationControllerStore.isLoading'))
          .value;
  Computed<CurrentWeather?>? _$currentWeatherComputed;

  @override
  CurrentWeather? get currentWeather => (_$currentWeatherComputed ??=
          Computed<CurrentWeather?>(() => super.currentWeather,
              name: 'WeatherInformationControllerStore.currentWeather'))
      .value;

  late final _$_isLoadingAtom = Atom(
      name: 'WeatherInformationControllerStore._isLoading', context: context);

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

  late final _$_latitudeAtom = Atom(
      name: 'WeatherInformationControllerStore._latitude', context: context);

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

  late final _$_longitudeAtom = Atom(
      name: 'WeatherInformationControllerStore._longitude', context: context);

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

  late final _$_currentWeatherAtom = Atom(
      name: 'WeatherInformationControllerStore._currentWeather',
      context: context);

  @override
  CurrentWeather get _currentWeather {
    _$_currentWeatherAtom.reportRead();
    return super._currentWeather;
  }

  @override
  set _currentWeather(CurrentWeather value) {
    _$_currentWeatherAtom.reportWrite(value, super._currentWeather, () {
      super._currentWeather = value;
    });
  }

  late final _$_determinePositionAsyncAction = AsyncAction(
      'WeatherInformationControllerStore._determinePosition',
      context: context);

  @override
  Future<void> _determinePosition() {
    return _$_determinePositionAsyncAction
        .run(() => super._determinePosition());
  }

  late final _$getWeatherInformationAsyncAction = AsyncAction(
      'WeatherInformationControllerStore.getWeatherInformation',
      context: context);

  @override
  Future<void> getWeatherInformation() {
    return _$getWeatherInformationAsyncAction
        .run(() => super.getWeatherInformation());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
currentWeather: ${currentWeather}
    ''';
  }
}
