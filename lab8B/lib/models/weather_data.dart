import 'package:flutter/material.dart';
import 'daily_forecast.dart';
import 'weather_recommendation.dart';

class WeatherData {
  final String cityName;
  final String country;
  final String? admin1;
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double windSpeed;
  final double precipitation;
  final int weatherCode;
  final bool isDay;
  final DateTime time;
  final List<DailyForecast> dailyForecasts;
  final WeatherRecommendation recommendation;

  const WeatherData({
    required this.cityName,
    required this.country,
    this.admin1,
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
    required this.isDay,
    required this.time,
    required this.dailyForecasts,
    required this.recommendation,
  });

  factory WeatherData.fromJson({
    required Map<String, dynamic> json,
    required String cityName,
    required String country,
    String? admin1,
  }) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final daily = json['daily'] as Map<String, dynamic>? ?? {};

    final temp = (current['temperature_2m'] as num?)?.toDouble() ?? 0.0;
    final apparentTemp = (current['apparent_temperature'] as num?)?.toDouble() ?? temp;
    final hum = (current['relative_humidity_2m'] as num?)?.toInt() ?? 0;
    final wind = (current['wind_speed_10m'] as num?)?.toDouble() ?? 0.0;
    final precip = (current['precipitation'] as num?)?.toDouble() ?? 0.0;
    final wCode = (current['weather_code'] as num?)?.toInt() ?? 0;
    final isDayVal = ((current['is_day'] as num?)?.toInt() ?? 1) == 1;
    final parsedTime = DateTime.tryParse(current['time'] as String? ?? '') ?? DateTime.now();

    final times = (daily['time'] as List<dynamic>?) ?? [];
    final weatherCodes = (daily['weather_code'] as List<dynamic>?) ?? [];
    final maxTemps = (daily['temperature_2m_max'] as List<dynamic>?) ?? [];
    final minTemps = (daily['temperature_2m_min'] as List<dynamic>?) ?? [];
    final uvIndices = (daily['uv_index_max'] as List<dynamic>?) ?? [];
    final precipProbs = (daily['precipitation_probability_max'] as List<dynamic>?) ?? [];

    final forecasts = <DailyForecast>[];
    final count = times.length;

    for (int i = 0; i < count; i++) {
      final date = DateTime.tryParse(times[i].toString()) ?? DateTime.now().add(Duration(days: i));
      final code = i < weatherCodes.length ? (weatherCodes[i] as num).toInt() : wCode;
      final maxT = i < maxTemps.length ? (maxTemps[i] as num).toDouble() : temp;
      final minT = i < minTemps.length ? (minTemps[i] as num).toDouble() : temp;
      final uv = i < uvIndices.length ? (uvIndices[i] as num).toDouble() : 0.0;
      final prob = i < precipProbs.length ? (precipProbs[i] as num).toInt() : 0;

      forecasts.add(
        DailyForecast(
          date: date,
          weatherCode: code,
          maxTemp: maxT,
          minTemp: minT,
          uvIndex: uv,
          precipProbability: prob,
        ),
      );
    }

    final todayUv = forecasts.isNotEmpty ? forecasts.first.uvIndex : 0.0;
    final todayProb = forecasts.isNotEmpty ? forecasts.first.precipProbability : 0;

    final recommendation = WeatherRecommendation.generate(
      apparentTemperature: apparentTemp,
      precipitation: precip,
      weatherCode: wCode,
      uvIndex: todayUv,
      windSpeed: wind,
      precipProbability: todayProb,
    );

    return WeatherData(
      cityName: cityName,
      country: country,
      admin1: admin1,
      temperature: temp,
      apparentTemperature: apparentTemp,
      humidity: hum,
      windSpeed: wind,
      precipitation: precip,
      weatherCode: wCode,
      isDay: isDayVal,
      time: parsedTime,
      dailyForecasts: forecasts,
      recommendation: recommendation,
    );
  }

  double get todayMaxTemp =>
      dailyForecasts.isNotEmpty ? dailyForecasts.first.maxTemp : temperature;

  double get todayMinTemp =>
      dailyForecasts.isNotEmpty ? dailyForecasts.first.minTemp : temperature;

  double get todayUvIndex =>
      dailyForecasts.isNotEmpty ? dailyForecasts.first.uvIndex : 0.0;

  int get todayPrecipProbability =>
      dailyForecasts.isNotEmpty ? dailyForecasts.first.precipProbability : 0;

  String get weatherDescription {
    switch (weatherCode) {
      case 0:
        return 'Trời quang đãng';
      case 1:
        return 'Hầu như trời quang';
      case 2:
        return 'Mây rải rác';
      case 3:
        return 'Nhiều mây u ám';
      case 45:
      case 48:
        return 'Có sương mù';
      case 51:
      case 53:
      case 55:
        return 'Mưa phùn';
      case 56:
      case 57:
        return 'Mưa phùn buốt giá';
      case 61:
        return 'Mưa nhẹ';
      case 63:
        return 'Mưa vừa';
      case 65:
        return 'Mưa to';
      case 66:
      case 67:
        return 'Mưa buốt lạnh';
      case 71:
      case 73:
      case 75:
      case 77:
        return 'Có tuyết rơi';
      case 80:
      case 81:
      case 82:
        return 'Mưa rào';
      case 85:
      case 86:
        return 'Tuyết rào';
      case 95:
        return 'Dông bão';
      case 96:
      case 99:
        return 'Dông kèm mưa đá';
      default:
        return 'Mây thay đổi';
    }
  }

  IconData get weatherIcon {
    if (!isDay && (weatherCode == 0 || weatherCode == 1)) {
      return Icons.nightlight_round;
    }
    switch (weatherCode) {
      case 0:
        return Icons.wb_sunny_rounded;
      case 1:
        return Icons.wb_sunny_outlined;
      case 2:
        return Icons.cloud_queue_rounded;
      case 3:
        return Icons.cloud_rounded;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
        return Icons.grain_rounded;
      case 61:
      case 63:
      case 65:
        return Icons.water_drop_rounded;
      case 71:
      case 73:
      case 75:
      case 77:
        return Icons.ac_unit_rounded;
      case 80:
      case 81:
      case 82:
        return Icons.umbrella_rounded;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }
}
