import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/city_location.dart';
import '../models/weather_data.dart';

class WeatherServiceException implements Exception {
  final String message;
  const WeatherServiceException(this.message);

  @override
  String toString() => message;
}

class WeatherService {
  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  static const String _geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String _weatherBaseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<List<CityLocation>> searchCities(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return [];
    }

    final uri = Uri.parse('$_geocodingBaseUrl?name=${Uri.encodeComponent(cleanQuery)}&count=5&language=en&format=json');

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw WeatherServiceException('Lỗi máy chủ khi tìm kiếm thành phố (Mã lỗi: ${response.statusCode})');
      }

      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>?;

      if (results == null || results.isEmpty) {
        return [];
      }

      return results
          .map((item) => CityLocation.fromJson(item as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw const WeatherServiceException('Không có kết nối mạng. Vui lòng kiểm tra lại đường truyền Internet.');
    } on TimeoutException {
      throw const WeatherServiceException('Quá thời gian kết nối đến máy chủ. Vui lòng thử lại sau.');
    } on FormatException {
      throw const WeatherServiceException('Dữ liệu phản hồi từ máy chủ không hợp lệ.');
    } on WeatherServiceException {
      rethrow;
    } catch (e) {
      throw WeatherServiceException('Không thể tìm kiếm thành phố: $e');
    }
  }

  Future<WeatherData> fetchWeather(CityLocation location) async {
    final uri = Uri.parse(
      '$_weatherBaseUrl?latitude=${location.latitude}&longitude=${location.longitude}'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min,uv_index_max,precipitation_probability_max'
      '&timezone=auto',
    );

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        throw WeatherServiceException('Lỗi tải dữ liệu thời tiết (Mã lỗi: ${response.statusCode})');
      }

      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;

      return WeatherData.fromJson(
        json: data,
        cityName: location.name,
        country: location.country,
        admin1: location.admin1,
      );
    } on SocketException {
      throw const WeatherServiceException('Không thể kết nối Internet. Vui lòng kiểm tra kết nối mạng của bạn.');
    } on TimeoutException {
      throw const WeatherServiceException('Kết nối quá hạn khi tải dữ liệu thời tiết. Vui lòng bấm thử lại.');
    } on FormatException {
      throw const WeatherServiceException('Lỗi định dạng dữ liệu từ máy chủ.');
    } on WeatherServiceException {
      rethrow;
    } catch (e) {
      throw WeatherServiceException('Đã xảy ra lỗi không xác định: $e');
    }
  }

  Future<WeatherData> fetchWeatherByCityName(String cityName) async {
    final cities = await searchCities(cityName);
    if (cities.isEmpty) {
      throw WeatherServiceException('Không tìm thấy dữ liệu vị trí cho "$cityName". Vui lòng thử với tên thành phố khác.');
    }
    return fetchWeather(cities.first);
  }
}
