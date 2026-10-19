import 'package:flutter_test/flutter_test.dart';
import 'package:lab8b/models/city_location.dart';
import 'package:lab8b/models/weather_recommendation.dart';

void main() {
  test('CityLocation fromJson parsing test', () {
    final json = {
      'name': 'Hanoi',
      'country': 'Vietnam',
      'latitude': 21.0245,
      'longitude': 105.84117,
      'admin1': 'Hanoi',
    };

    final city = CityLocation.fromJson(json);

    expect(city.name, 'Hanoi');
    expect(city.country, 'Vietnam');
    expect(city.latitude, 21.0245);
    expect(city.longitude, 105.84117);
  });

  test('WeatherRecommendation rainy advice test', () {
    final rec = WeatherRecommendation.generate(
      apparentTemperature: 28,
      precipitation: 2.5,
      weatherCode: 63,
      uvIndex: 3.0,
      windSpeed: 10,
      precipProbability: 80,
    );

    expect(rec.needUmbrella, true);
    expect(rec.umbrellaAdvice.contains('ô'), true);
  });

  test('WeatherRecommendation sunny and hot advice test', () {
    final rec = WeatherRecommendation.generate(
      apparentTemperature: 36,
      precipitation: 0.0,
      weatherCode: 0,
      uvIndex: 9.0,
      windSpeed: 8,
      precipProbability: 5,
    );

    expect(rec.needUmbrella, false);
    expect(rec.uvAdvice.contains('SPF50+'), true);
    expect(rec.outfitAdvice.contains('mỏng nhẹ'), true);
  });
}
