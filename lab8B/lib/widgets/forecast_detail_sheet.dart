import 'package:flutter/material.dart';
import '../models/daily_forecast.dart';

class ForecastDetailSheet extends StatelessWidget {
  final DailyForecast forecast;
  final String cityName;

  const ForecastDetailSheet({
    super.key,
    required this.forecast,
    required this.cityName,
  });

  static void show(BuildContext context, DailyForecast forecast, String cityName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ForecastDetailSheet(
        forecast: forecast,
        cityName: cityName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final willRain = forecast.precipProbability >= 40 ||
        (forecast.weatherCode >= 51 && forecast.weatherCode <= 67) ||
        (forecast.weatherCode >= 80 && forecast.weatherCode <= 82);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${forecast.dayLabel} • ${forecast.dateFormatted}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dự báo chi tiết tại $cityName',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  forecast.weatherIcon,
                  size: 32,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text(
                      'Nhiệt độ cao nhất',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${forecast.maxTemp.round()}°C',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 35, color: Colors.grey.shade300),
                Column(
                  children: [
                    const Text(
                      'Nhiệt độ thấp nhất',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${forecast.minTemp.round()}°C',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 35, color: Colors.grey.shade300),
                Column(
                  children: [
                    const Text(
                      'Khả năng mưa',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${forecast.precipProbability}%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: willRain ? Colors.indigo : Colors.teal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Khuyến nghị cho ngày này',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.umbrella_rounded,
            color: willRain ? Colors.deepOrange : Colors.teal,
            title: willRain ? 'Cần mang theo ô / áo mưa' : 'Không cần mang ô',
            desc: willRain
                ? 'Xác suất mưa ${forecast.precipProbability}%, nên mang ô hoặc áo mưa khi đi ra ngoài.'
                : 'Trời khô ráo, khả năng mưa thấp (${forecast.precipProbability}%).',
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.wb_sunny_rounded,
            color: forecast.uvIndex >= 6 ? Colors.orange : Colors.blue,
            title: 'Chỉ số UV: ${forecast.uvIndex.toStringAsFixed(1)}',
            desc: forecast.uvIndex >= 6
                ? 'Bức xạ UV cao, hãy bôi kem chống nắng và hạn chế phơi nắng giữa trưa.'
                : 'Mức UV dịu nhẹ, thích hợp cho các hoạt động thể chất bình thường.',
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Đóng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
