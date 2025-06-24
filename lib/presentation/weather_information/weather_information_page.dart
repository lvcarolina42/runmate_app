import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:runmate_app/presentation/weather_information/controller/weather_information_controller.dart';
import 'package:runmate_app/presentation/widgets/default_shimmer.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';
import 'package:runmate_app/shared/themes/app_text_themes.dart';

class WeatherInformationPage extends StatefulWidget {
  const WeatherInformationPage({super.key});

  @override
  State<WeatherInformationPage> createState() => _WeatherInformationPageState();
}

class _WeatherInformationPageState extends State<WeatherInformationPage> {
  final WeatherInformationController controller = Get.find<WeatherInformationController>();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return RefreshIndicator(
          onRefresh: controller.onInitialize,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CurrentWeatherWidget(currentWeather: controller.currentWeather!, isLoading: controller.isLoading),
                ),
                const SizedBox(height: 12),
                HourlyForecastWidget(currentWeather: controller.currentWeather!, isLoading: controller.isLoading),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DailyForecastWidget(currentWeather: controller.currentWeather!, isLoading: controller.isLoading),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class CurrentWeatherWidget extends StatelessWidget {
  final CurrentWeather currentWeather;
  final bool isLoading;

  const CurrentWeatherWidget({super.key, required this.currentWeather, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blue900,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultShimmer(isShimmerVisible: isLoading, child: Text(decode(currentWeather.city), style: titleLgMedium.customColor(AppColors.whiteBrand))),
          const SizedBox(height: 12),
          DefaultShimmer(
            isShimmerVisible: isLoading,
            child: Row(
              children: [
                if (!isLoading)
                  Image.network(currentWeather.icon, height: 64),
                if (isLoading)
                  const SizedBox(),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${currentWeather.temp}°C', style: titleLgMedium.customColor(AppColors.whiteBrand)),
                    Text(decode(currentWeather.description), style: bodySmRegular.customColor(AppColors.blue100)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HourlyForecastWidget extends StatelessWidget {
  final CurrentWeather currentWeather;
  final bool isLoading;

  const HourlyForecastWidget({super.key, required this.currentWeather, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Proximas horas', style: titleSmMedium.customColor(AppColors.blue100)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 128,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: currentWeather.hours.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              final hour = currentWeather.hours[index];
              return DefaultShimmer(
                isShimmerVisible: isLoading,
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.blue900,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(hour.hour, style: subtitleLgSemiBold.customColor(AppColors.whiteBrand)),
                      if (!isLoading)
                        Image.network(hour.icon, height: 64),
                      if (isLoading)
                        const SizedBox(),
                      const SizedBox(height: 8),
                      Text('${hour.temp.toStringAsFixed(0)}°C', style: bodyLgMedium.customColor(AppColors.whiteBrand)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DailyForecastWidget extends StatelessWidget {
  final CurrentWeather currentWeather;
  final bool isLoading;

  const DailyForecastWidget({super.key, required this.currentWeather, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Próximos Dias', style: titleSmMedium.customColor(AppColors.blue100)),
        const SizedBox(height: 12),
        ...currentWeather.days.map((day) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: DefaultShimmer(
              isShimmerVisible: isLoading,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blue900,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    if (!isLoading)
                      Image.network(day.icon, height: 48),
                    if (isLoading)
                      const SizedBox(),
                    const SizedBox(width: 16),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(day.dayWeek, style: subtitleLgMedium.customColor(AppColors.whiteBrand)),
                        Text(decode(day.description), style: bodyLgMedium.customColor(AppColors.blue100)),
                      ],
                    )),
                    Text('${day.tempMin.toStringAsFixed(0)}°C / ${day.tempMax.toStringAsFixed(0)}°C', style: subtitleLgMedium.customColor(AppColors.whiteBrand)),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 32),
      ],
    );
  }
}

String decode(String text) {
  final bytes = latin1.encode(text);
  return utf8.decode(bytes);
}