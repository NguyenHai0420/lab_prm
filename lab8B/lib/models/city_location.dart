class CityLocation {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final String? admin1;

  const CityLocation({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.admin1,
  });

  factory CityLocation.fromJson(Map<String, dynamic> json) {
    return CityLocation(
      name: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      admin1: json['admin1'] as String?,
    );
  }

  String get fullDisplayName {
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      return '$name, $admin1, $country';
    }
    if (country.isNotEmpty) {
      return '$name, $country';
    }
    return name;
  }
}
