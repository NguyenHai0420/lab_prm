import 'package:flutter/material.dart';
import '../models/city_location.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import '../widgets/city_search_modal.dart';
import '../widgets/forecast_detail_sheet.dart';
import '../widgets/metric_tile.dart';
import '../widgets/recommendation_card.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final WeatherService _weatherService = WeatherService();

  CityLocation _selectedCity = const CityLocation(
    name: 'Hanoi',
    country: 'Vietnam',
    latitude: 21.0245,
    longitude: 105.84117,
    admin1: 'Hanoi',
  );

  late Future<WeatherData> _weatherFuture;

  final List<CityLocation> _presetCities = const [
    CityLocation(name: 'Hà Nội', country: 'Vietnam', latitude: 21.0245, longitude: 105.84117),
    CityLocation(name: 'TP. Hồ Chí Minh', country: 'Vietnam', latitude: 10.8231, longitude: 106.6297),
    CityLocation(name: 'Đà Nẵng', country: 'Vietnam', latitude: 16.0544, longitude: 108.2022),
    CityLocation(name: 'Huế', country: 'Vietnam', latitude: 16.4637, longitude: 107.5909),
    CityLocation(name: 'Tokyo', country: 'Japan', latitude: 35.6895, longitude: 139.6917),
    CityLocation(name: 'London', country: 'United Kingdom', latitude: 51.5074, longitude: -0.1278),
    CityLocation(name: 'Paris', country: 'France', latitude: 48.8566, longitude: 2.3522),
    CityLocation(name: 'New York', country: 'United States', latitude: 40.7128, longitude: -74.0060),
  ];

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeather(_selectedCity);
    });
  }

  void _onCityChanged(CityLocation city) {
    setState(() {
      _selectedCity = city;
      _weatherFuture = _weatherService.fetchWeather(city);
    });
  }

  void _openCitySearch() {
    CitySearchModal.show(
      context: context,
      weatherService: _weatherService,
      onCitySelected: _onCityChanged,
    );
  }

  LinearGradient _getBackgroundGradient(WeatherData? data) {
    if (data == null) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFFEFF6FF)],
      );
    }

    if (!data.isDay) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
      );
    }

    if (data.recommendation.needUmbrella) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF334155), Color(0xFF475569), Color(0xFFE2E8F0)],
      );
    }

    if (data.temperature >= 32) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFC2410C), Color(0xFFEA580C), Color(0xFFFFF7ED)],
      );
    }

    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6), Color(0xFFF0FDF4)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherData>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        final weather = snapshot.data;
        final gradient = _getBackgroundGradient(weather);

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: gradient),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  _loadWeather();
                  await _weatherFuture;
                },
                color: Colors.blue.shade800,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    _buildAppBar(),
                    _buildPresetChipsBar(),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 16),
                              Text(
                                'Đang tải dữ liệu thời tiết...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (snapshot.hasError)
                      SliverFillRemaining(
                        child: _buildErrorState(snapshot.error),
                      )
                    else if (weather != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              _buildHeroWeatherCard(weather),
                              const SizedBox(height: 20),
                              _buildRecommendationSection(weather),
                              const SizedBox(height: 20),
                              _buildMetricsGrid(weather),
                              const SizedBox(height: 24),
                              _buildForecastHeader(),
                              const SizedBox(height: 12),
                              _buildForecastList(weather),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: InkWell(
        onTap: _openCitySearch,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _selectedCity.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Tìm thành phố',
          icon: const Icon(Icons.search_rounded, color: Colors.white),
          onPressed: _openCitySearch,
        ),
        IconButton(
          tooltip: 'Làm mới',
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          onPressed: _loadWeather,
        ),
      ],
    );
  }

  Widget _buildPresetChipsBar() {
    return SliverToBoxAdapter(
      child: Container(
        height: 42,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: _presetCities.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final city = _presetCities[index];
            final isSelected = city.name == _selectedCity.name;
            return ChoiceChip(
              label: Text(city.name),
              selected: isSelected,
              selectedColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue.shade900 : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              showCheckmark: false,
              side: BorderSide(
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3),
              ),
              onSelected: (_) => _onCityChanged(city),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroWeatherCard(WeatherData weather) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.cityName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      weather.country,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  weather.weatherIcon,
                  size: 42,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weather.temperature.round()}°',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.weatherDescription,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cảm giác như ${weather.apparentTemperature.round()}°C',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMinMaxPill('Cao nhất', '${weather.todayMaxTemp.round()}°C', Colors.deepOrange),
              _buildMinMaxPill('Thấp nhất', '${weather.todayMinTemp.round()}°C', Colors.blue.shade700),
              _buildMinMaxPill('Khả năng mưa', '${weather.todayPrecipProbability}%', Colors.teal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMinMaxPill(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildRecommendationSection(WeatherData weather) {
    final rec = weather.recommendation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.assistant_rounded, color: Colors.amber, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Gợi ý đồng hành thông minh',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RecommendationCard(
          icon: Icons.umbrella_rounded,
          title: rec.needUmbrella ? 'Cần mang theo ô / áo mưa' : 'Không cần mang ô',
          advice: rec.umbrellaAdvice,
          primaryColor: rec.needUmbrella ? const Color(0xFFDC2626) : const Color(0xFF059669),
          backgroundColor: Colors.white.withValues(alpha: 0.95),
          trailingBadge: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (rec.needUmbrella ? const Color(0xFFDC2626) : const Color(0xFF059669))
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              rec.needUmbrella ? 'CHÚ Ý MƯA' : 'TẠNH RÁO',
              style: TextStyle(
                color: rec.needUmbrella ? const Color(0xFFDC2626) : const Color(0xFF059669),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ),
        RecommendationCard(
          icon: Icons.checkroom_rounded,
          title: 'Gợi ý trang phục',
          advice: rec.outfitAdvice,
          primaryColor: const Color(0xFF2563EB),
          backgroundColor: Colors.white.withValues(alpha: 0.95),
        ),
        RecommendationCard(
          icon: Icons.directions_run_rounded,
          title: 'Hoạt động ngoài trời',
          advice: rec.activityAdvice,
          primaryColor: const Color(0xFF7C3AED),
          backgroundColor: Colors.white.withValues(alpha: 0.95),
        ),
        RecommendationCard(
          icon: Icons.wb_sunny_rounded,
          title: 'Cảnh báo tia cực tím (UV)',
          advice: rec.uvAdvice,
          primaryColor: const Color(0xFFD97706),
          backgroundColor: Colors.white.withValues(alpha: 0.95),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(WeatherData weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chỉ số thời tiết chi tiết',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.6,
          children: [
            MetricTile(
              icon: Icons.water_drop_rounded,
              label: 'Độ ẩm không khí',
              value: '${weather.humidity}%',
              subtitle: weather.humidity > 70 ? 'Khá ẩm' : 'Dễ chịu',
              color: Colors.blue.shade700,
            ),
            MetricTile(
              icon: Icons.air_rounded,
              label: 'Tốc độ gió',
              value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
              subtitle: weather.windSpeed > 25 ? 'Gió mạnh' : 'Gió nhẹ',
              color: Colors.teal.shade700,
            ),
            MetricTile(
              icon: Icons.wb_twilight_rounded,
              label: 'Chỉ số UV hôm nay',
              value: weather.todayUvIndex.toStringAsFixed(1),
              subtitle: weather.todayUvIndex >= 6 ? 'Mức cao' : 'Mức an toàn',
              color: Colors.orange.shade800,
            ),
            MetricTile(
              icon: Icons.cloud_sync_rounded,
              label: 'Lượng mưa hiện tại',
              value: '${weather.precipitation} mm',
              subtitle: weather.precipitation > 0 ? 'Đang có mưa' : 'Không mưa',
              color: Colors.indigo.shade700,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForecastHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Dự báo 7 ngày tới',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
          ),
        ),
        Text(
          'Chạm để xem chi tiết',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastList(WeatherData weather) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: weather.dailyForecasts.length,
        separatorBuilder: (_, _) => Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final day = weather.dailyForecasts[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.dayLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    day.dateFormatted,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ],
              ),
            ),
            title: Row(
              children: [
                Icon(day.weatherIcon, size: 22, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    day.weatherDescription,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (day.precipProbability >= 30) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.water_drop, size: 12, color: Colors.blue.shade600),
                      Text(
                        '${day.precipProbability}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
                Text(
                  '${day.maxTemp.round()}°',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${day.minTemp.round()}°',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.black38),
              ],
            ),
            onTap: () {
              ForecastDetailSheet.show(context, day, weather.cityName);
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorState(Object? error) {
    final message = error is WeatherServiceException
        ? error.message
        : 'Không thể kết nối đến máy chủ thời tiết. Vui lòng kiểm tra lại kết nối mạng.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 48,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Lỗi kết nối thời tiết',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadWeather,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Thử lại ngay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
