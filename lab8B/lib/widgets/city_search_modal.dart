import 'package:flutter/material.dart';
import '../models/city_location.dart';
import '../services/weather_service.dart';

class CitySearchModal extends StatefulWidget {
  final WeatherService weatherService;
  final ValueChanged<CityLocation> onCitySelected;

  const CitySearchModal({
    super.key,
    required this.weatherService,
    required this.onCitySelected,
  });

  static Future<void> show({
    required BuildContext context,
    required WeatherService weatherService,
    required ValueChanged<CityLocation> onCitySelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CitySearchModal(
        weatherService: weatherService,
        onCitySelected: onCitySelected,
      ),
    );
  }

  @override
  State<CitySearchModal> createState() => _CitySearchModalState();
}

class _CitySearchModalState extends State<CitySearchModal> {
  final TextEditingController _controller = TextEditingController();
  List<CityLocation> _results = [];
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _popularSuggestions = [
    'Hà Nội',
    'Hồ Chí Minh',
    'Đà Nẵng',
    'Tokyo',
    'Seoul',
    'Paris',
    'London',
    'New York',
    'Sydney',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) {
      setState(() {
        _results = [];
        _errorMessage = null;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cities = await widget.weatherService.searchCities(clean);
      setState(() {
        _results = cities;
        _isLoading = false;
        if (cities.isEmpty) {
          _errorMessage = 'Không tìm thấy kết quả nào phù hợp với "$clean".';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75 + (bottomInset > 0 ? bottomInset : 0),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: 20 + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tìm kiếm thành phố',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: _performSearch,
            decoration: InputDecoration(
              hintText: 'Nhập tên thành phố (vd: Hanoi, Paris, Tokyo...)',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _results = [];
                          _errorMessage = null;
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) {
              if (val.isEmpty) {
                setState(() {
                  _results = [];
                  _errorMessage = null;
                });
              }
            },
          ),
          const SizedBox(height: 14),
          const Text(
            'Gợi ý nhanh:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _popularSuggestions.map((cityName) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(cityName),
                    backgroundColor: Colors.blue.shade50,
                    labelStyle: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    side: BorderSide(color: Colors.blue.shade100),
                    onPressed: () {
                      _controller.text = cityName;
                      _performSearch(cityName);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          const Divider(),
          Expanded(
            child: _buildResultsView(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Đang tìm kiếm...', style: TextStyle(color: Colors.black54)),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off_rounded, size: 48, color: Colors.orange.shade400),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.travel_explore_rounded, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'Nhập tên hoặc chọn gợi ý phía trên để bắt đầu tìm kiếm.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _results[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.location_on_rounded, color: Colors.blue.shade700),
          ),
          title: Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            item.fullDisplayName,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black45),
          onTap: () {
            Navigator.pop(context);
            widget.onCitySelected(item);
          },
        );
      },
    );
  }
}
