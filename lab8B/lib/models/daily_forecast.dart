import 'package:flutter/material.dart';

class DailyForecast {
  final DateTime date;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;
  final double uvIndex;
  final int precipProbability;

  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
    required this.uvIndex,
    required this.precipProbability,
  });

  String get dayLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = target.difference(today).inDays;

    if (difference == 0) return 'Hôm nay';
    if (difference == 1) return 'Ngày mai';

    switch (date.weekday) {
      case DateTime.monday:
        return 'Thứ 2';
      case DateTime.tuesday:
        return 'Thứ 3';
      case DateTime.wednesday:
        return 'Thứ 4';
      case DateTime.thursday:
        return 'Thứ 5';
      case DateTime.friday:
        return 'Thứ 6';
      case DateTime.saturday:
        return 'Thứ 7';
      case DateTime.sunday:
        return 'Chủ Nhật';
      default:
        return '${date.day}/${date.month}';
    }
  }

  String get dateFormatted {
    final dayStr = date.day.toString().padLeft(2, '0');
    final monthStr = date.month.toString().padLeft(2, '0');
    return '$dayStr/$monthStr';
  }

  String get weatherDescription {
    switch (weatherCode) {
      case 0:
        return 'Trời quang đãng';
      case 1:
        return 'Ít mây';
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
        return 'Mưa rất to';
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
