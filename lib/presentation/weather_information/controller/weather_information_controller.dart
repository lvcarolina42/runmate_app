import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:runmate_app/shared/constants/project_constants.dart';
import 'package:weatherapi/weatherapi.dart';

part 'weather_information_controller.g.dart';

class WeatherInformationController = WeatherInformationControllerStore with _$WeatherInformationController;

abstract class WeatherInformationControllerStore extends DisposableInterface with Store {

  @observable
  bool _isLoading = false;

  @computed
  bool get isLoading => _isLoading;

  @observable
  double _latitude = 0;

  @observable
  double _longitude = 0;

  @observable
  CurrentWeather _currentWeather = CurrentWeather.empty();

  @computed
  CurrentWeather? get currentWeather => _currentWeather;

  @override
  void onInit() {
    super.onInit();
    onInitialize();
  }

  Future<void> onInitialize() async {
    await _determinePosition();
    await getWeatherInformation();
  }

  @action
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    final position = await Geolocator.getCurrentPosition();

    _latitude = position.latitude;
    _longitude = position.longitude;
  }

  @action
  Future<void> getWeatherInformation() async {
    _isLoading = true;
    WeatherRequest wr = WeatherRequest(weatherApiKey, language: Language.portuguese);
    final currentWeather = await wr.getForecastWeatherByLocation(_latitude, _longitude, forecastDays: 8);

    final forecast = currentWeather.forecast.sublist(1);

    final hours = getHourData(currentWeather.forecast.first.hour, forecast.first.hour);

    _currentWeather = CurrentWeather(
      temp: currentWeather.current.tempC ?? 0,
      city: currentWeather.location.name ?? "",
      icon: "https:${currentWeather.current.condition.icon}",
      description: currentWeather.current.condition.text ?? "",
      hours: hours.map((hour) => HourWeather(temp: hour.tempC ?? 0, time: hour.time ?? "", icon: "https:${hour.condition.icon}")).toList(),
      days: forecast.map((e) {
        final date = DateTime.parse(e.date ?? "");
        final format = DateFormat.EEEE('pt_BR');
        final dateOfWeek = format.format(date).replaceAll('.', '');
        final dateOfWeekFormat = dateOfWeek[0].toUpperCase() + dateOfWeek.substring(1);

        return DayWeather(
          description: e.day.condition.text ?? "",
          tempMax:  e.day.maxtempC ?? 0, 
          tempMin:  e.day.mintempC ?? 0, 
          dayWeek: dateOfWeekFormat, 
          icon: "https:${e.day.condition.icon}", 
          day: e.date ?? "",
        );
      }).toList(),
    );

    _isLoading = false;
  }

  List<HourData> getHourData(List<HourData> currentDay, List<HourData> nextDay) {
    final now = DateTime.now();
    final currentHour = now.hour;

    final List<HourData> result = [];

    for (int i = currentHour + 1; i < 24; i++) {
      result.add(currentDay[i]);
    }

    for (int i = 0; result.length < 24 && i < 24; i++) {
      result.add(nextDay[i]);
    }

    return result;
  }
}

class HourWeather {
  final double temp;
  final String time;
  final String icon;

  HourWeather({required this.temp, required this.time, required this.icon});

  factory HourWeather.empty() => HourWeather(temp: 12, time: "12:00", icon: "https://openweathermap.org/img/wn/10d@2x.png");

  String get hour => DateFormat('H').format(DateTime.parse(time));
}

class DayWeather {
  final double tempMax;
  final double tempMin;
  final String dayWeek;
  final String icon;
  final String day;
  final String description;

  DayWeather({required this.tempMax, required this.tempMin, required this.dayWeek, required this.icon, required this.day, required this.description});

  factory DayWeather.empty() => DayWeather(
    tempMax: 12, 
    tempMin: 12, 
    dayWeek: "Seg", 
    description: "Ensolarado",
    icon: "https://openweathermap.org/img/wn/10d@2x.png", 
    day: "Segunda"
  );
}

class CurrentWeather {
  final double temp;
  final String city;
  final String icon;
  final String description;
  final List<HourWeather> hours;
  final List<DayWeather> days;

  CurrentWeather({required this.temp, required this.city, required this.description, required this.hours, required this.days, required this.icon});

  factory CurrentWeather.empty() => CurrentWeather(
    temp: 12, 
    city: "Cidade", 
    icon: "https://openweathermap.org/img/wn/10d@2x.png",
    description: "Ensolarado", 
    hours: [
      HourWeather.empty(),
      HourWeather.empty(),
      HourWeather.empty(),
      HourWeather.empty(),
      HourWeather.empty(),
      HourWeather.empty(),
      HourWeather.empty(),
      HourWeather.empty(),
      HourWeather.empty(),
      HourWeather.empty(),
      HourWeather.empty(),
      HourWeather.empty(),
    ],
    days: [
      DayWeather.empty(),
      DayWeather.empty(),
      DayWeather.empty(),
      DayWeather.empty(),
      DayWeather.empty(),
      DayWeather.empty(),
      DayWeather.empty(),
    ],
  );
}