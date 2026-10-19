class WeatherRecommendation {
  final bool needUmbrella;
  final String umbrellaAdvice;
  final String outfitAdvice;
  final String activityAdvice;
  final String uvAdvice;

  const WeatherRecommendation({
    required this.needUmbrella,
    required this.umbrellaAdvice,
    required this.outfitAdvice,
    required this.activityAdvice,
    required this.uvAdvice,
  });

  factory WeatherRecommendation.generate({
    required double apparentTemperature,
    required double precipitation,
    required int weatherCode,
    required double uvIndex,
    required double windSpeed,
    required int precipProbability,
  }) {
    final isRainyCode = (weatherCode >= 51 && weatherCode <= 67) ||
        (weatherCode >= 80 && weatherCode <= 82) ||
        (weatherCode >= 95 && weatherCode <= 99);

    final needUmbrella = precipitation > 0.1 || isRainyCode || precipProbability >= 40;

    final String umbrellaAdvice;
    if (needUmbrella) {
      if (precipProbability >= 70 || precipitation > 1.0) {
        umbrellaAdvice = 'Hãy mang theo ô hoặc áo mưa! Xác suất mưa rất cao hoặc đang có mưa.';
      } else {
        umbrellaAdvice = 'Nên chuẩn bị sẵn một chiếc ô gấp trong balo phòng mưa bất chợt.';
      }
    } else {
      umbrellaAdvice = 'Không cần mang ô. Bầu trời tạnh ráo, xác suất mưa thấp.';
    }

    final String outfitAdvice;
    if (apparentTemperature >= 33) {
      outfitAdvice = 'Nắng nóng gay gắt: Mặc đồ mỏng nhẹ, vải cotton thoáng khí, thấm hút mồ hôi.';
    } else if (apparentTemperature >= 25) {
      outfitAdvice = 'Thời tiết ấm áp: Áo phông ngắn tay, quần thoải mái và giày năng động.';
    } else if (apparentTemperature >= 19) {
      outfitAdvice = 'Tiết trời mát mẻ: Áo thun dài tay hoặc khoác thêm một chiếc cardigan nhẹ.';
    } else if (apparentTemperature >= 13) {
      outfitAdvice = 'Trời lạnh: Áo len dày vừa phải, áo khoác gió hoặc áo bomber cản gió.';
    } else {
      outfitAdvice = 'Rất rét: Áo phao đại hàn nhiều lớp, khăn quàng cổ, găng tay và mũ ấm.';
    }

    final String activityAdvice;
    if (weatherCode >= 95 && weatherCode <= 99) {
      activityAdvice = 'Cảnh báo dông sét nguy hiểm: Tuyệt đối ở trong nhà, tránh di chuyển dưới cây lớn.';
    } else if (precipitation > 3.0 || (weatherCode >= 63 && weatherCode <= 65)) {
      activityAdvice = 'Mưa lớn: Đường trơn trượt, ưu tiên hoạt động thư giãn hoặc làm việc trong nhà.';
    } else if (apparentTemperature > 36) {
      activityAdvice = 'Nguy cơ sốc nhiệt: Tránh thể thao ngoài trời giờ cao điểm trưa, bổ sung đủ nước.';
    } else if (windSpeed > 35) {
      activityAdvice = 'Gió to giật mạnh: Cẩn thận khi lái xe máy ngoài đường lớn, hạn chế chơi cầu lông.';
    } else if (apparentTemperature >= 18 && apparentTemperature <= 28 && !needUmbrella) {
      activityAdvice = 'Thời tiết tuyệt vời: Rất lý tưởng để chạy bộ, đạp xe, dạo phố hoặc dã ngoại.';
    } else {
      activityAdvice = 'Thời tiết ổn định: Phù hợp cho các hoạt động thường ngày ngoài trời.';
    }

    final String uvAdvice;
    if (uvIndex >= 8) {
      uvAdvice = 'Tia UV cực mạnh (chỉ số ${uvIndex.toStringAsFixed(1)}): Bôi kem chống nắng SPF50+, đeo kính râm.';
    } else if (uvIndex >= 5) {
      uvAdvice = 'Tia UV mức trung bình (chỉ số ${uvIndex.toStringAsFixed(1)}): Nên che chắn khi ra nắng trên 30 phút.';
    } else {
      uvAdvice = 'Tia UV an toàn (chỉ số ${uvIndex.toStringAsFixed(1)}): Mức bức xạ thấp, an toàn cho da.';
    }

    return WeatherRecommendation(
      needUmbrella: needUmbrella,
      umbrellaAdvice: umbrellaAdvice,
      outfitAdvice: outfitAdvice,
      activityAdvice: activityAdvice,
      uvAdvice: uvAdvice,
    );
  }
}
