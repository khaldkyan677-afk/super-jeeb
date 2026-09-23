import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_theme.dart';

class LocationPicker extends StatefulWidget {
  final String currentCity;
  const LocationPicker({super.key, required this.currentCity});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoadingGps = false;

  // المدن + العملة (قديم/جديد)
  final List<Map<String, String>> _cities = [
    {'name': 'صنعاء', 'region': 'أمانة العاصمة', 'currency': 'قديم'},
    {'name': 'الحديدة', 'region': 'الحديدة', 'currency': 'قديم'},
    {'name': 'إب', 'region': 'إب', 'currency': 'قديم'},
    {'name': 'ذمار', 'region': 'ذمار', 'currency': 'قديم'},
    {'name': 'صعدة', 'region': 'صعدة', 'currency': 'قديم'},
    {'name': 'حجة', 'region': 'حجة', 'currency': 'قديم'},
    {'name': 'عمران', 'region': 'عمران', 'currency': 'قديم'},
    {'name': 'البيضاء', 'region': 'البيضاء', 'currency': 'قديم'},
    {'name': 'عدن', 'region': 'عدن', 'currency': 'جديد'},
    {'name': 'تعز - المدينة', 'region': 'تعز', 'currency': 'جديد'},
    {'name': 'تعز - الحوبان', 'region': 'تعز', 'currency': 'قديم'},
    {'name': 'تعز - الدمنة', 'region': 'تعز', 'currency': 'قديم'},
    {'name': 'المكلا', 'region': 'حضرموت', 'currency': 'جديد'},
    {'name': 'مأرب', 'region': 'مأرب', 'currency': 'جديد'},
    {'name': 'لحج', 'region': 'لحج', 'currency': 'جديد'},
    {'name': 'أبين', 'region': 'أبين', 'currency': 'جديد'},
    {'name': 'شبوة', 'region': 'شبوة', 'currency': 'جديد'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredCities {
    if (_searchQuery.isEmpty) return _cities;
    return _cities.where((c) =>
      (c['name'] ?? '').contains(_searchQuery) ||
      (c['region'] ?? '').contains(_searchQuery)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.charcoal,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(
            width: 50, height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 15),
          Row(children: [
            const Icon(Icons.location_on, color: AppTheme.red, size: 24),
            const SizedBox(width: 10),
            Text('اختر المدينة',
              style: TextStyle(color: AppTheme.white, fontSize: 18,
                fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          ]),
          const SizedBox(height: 15),

          // زر GPS
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoadingGps ? null : _useGpsLocation,
              icon: _isLoadingGps
                ? const SizedBox(width: 18, height: 18,
                    child: CircularProgressIndicator(color: AppTheme.white, strokeWidth: 2))
                : const Icon(Icons.my_location, color: AppTheme.white),
              label: Text(_isLoadingGps ? 'جاري تحديد موقعك...' : 'استخدم موقعي الحالي',
                style: TextStyle(color: AppTheme.white, fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // حقل البحث
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v.trim()),
            style: TextStyle(color: AppTheme.white, fontFamily: 'Cairo'),
            decoration: InputDecoration(
              hintText: 'ابحث عن مدينة أو مديرية...',
              hintStyle: TextStyle(color: Colors.white38, fontFamily: 'Cairo'),
              prefixIcon: const Icon(Icons.search, color: AppTheme.red),
              suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: Text('أو اختر يدوياً:',
              style: TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'Cairo')),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: _filteredCities.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off, color: Colors.white24, size: 50),
                      const SizedBox(height: 10),
                      Text('لا توجد نتائج',
                        style: TextStyle(color: Colors.white54, fontFamily: 'Cairo')),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredCities.length,
                  itemBuilder: (_, i) {
                    final city = _filteredCities[i];
                    final isSelected = city['name'] == widget.currentCity;
                    final isNew = city['currency'] == 'جديد';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.red.withOpacity(0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                          ? Border.all(color: AppTheme.red, width: 1.5)
                          : Border.all(color: Colors.white12),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.location_city,
                          color: isSelected ? AppTheme.red : Colors.white54),
                        title: Text(city['name'] ?? '',
                          style: TextStyle(color: AppTheme.white, fontFamily: 'Cairo',
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 15)),
                        subtitle: Text(city['region'] ?? '',
                          style: TextStyle(color: Colors.white54, fontFamily: 'Cairo',
                            fontSize: 11)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isNew
                              ? AppTheme.green.withOpacity(0.15)
                              : AppTheme.yellow.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(city['currency'] ?? '',
                            style: TextStyle(
                              color: isNew ? AppTheme.green : AppTheme.yellow,
                              fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        ),
                        onTap: () => Navigator.pop(context, {
                          'city': city['name'] ?? '',
                          'currency': city['currency'] ?? 'قديم',
                        }),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _useGpsLocation() async {
    setState(() => _isLoadingGps = true);
    try {
      // 1. هل خدمة الموقع مفعّلة؟
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() => _isLoadingGps = false);
          _showError('خدمة الموقع غير مفعّلة، فعّلها من إعدادات الجوال');
        }
        return;
      }

      // 2. طلب الإذن
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() => _isLoadingGps = false);
          _showError('تم رفض إذن الموقع');
        }
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() => _isLoadingGps = false);
          _showError('إذن الموقع مرفوض نهائياً، فعّله من الإعدادات');
        }
        return;
      }

      // 3. الحصول على الموقع
      final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(const Duration(seconds: 10));

      // 4. تحويل الإحداثيات إلى مدينة
      final cityName = _detectCityFromCoords(pos.latitude, pos.longitude);
      if (mounted) {
        setState(() => _isLoadingGps = false);
        Navigator.pop(context, cityName);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingGps = false);
        _showError('فشل تحديد الموقع: تأكد من الإنترنت والإذن');
      }
    }
  }

  Map<String, String> _detectCityFromCoords(double lat, double lng) {
    // إحداثيات تقريبية للمدن الرئيسية
    final Map<String, List<double>> cityBounds = {
      'صنعاء': [15.15, 15.55, 44.00, 44.40],
      'عدن': [12.70, 13.05, 44.75, 45.10],
      'تعز - المدينة': [13.55, 13.75, 43.95, 44.15],
      'تعز - الحوبان': [13.55, 13.75, 44.10, 44.30],
      'الحديدة': [14.60, 15.00, 42.75, 43.25],
      'إب': [13.85, 14.10, 44.00, 44.30],
      'ذمار': [14.45, 14.70, 44.20, 44.55],
      'المكلا': [14.45, 14.65, 48.95, 49.25],
      'مأرب': [15.35, 15.60, 45.20, 45.55],
    };

    for (final entry in cityBounds.entries) {
      final b = entry.value;
      if (lat >= b[0] && lat <= b[1] && lng >= b[2] && lng <= b[3]) {
        // ابحث عن العملة
        final city = _cities.firstWhere(
          (c) => (c['name'] ?? '').startsWith(entry.key.split(' - ').first),
          orElse: () => {'name': entry.key, 'currency': 'قديم'},
        );
        return {
          'city': city['name'] ?? entry.key,
          'currency': city['currency'] ?? 'قديم',
        };
      }
    }

    // إذا لم تتطابق → استخدم صنعاء
    return {'city': 'صنعاء', 'currency': 'قديم'};
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: TextStyle(fontFamily: 'Cairo', color: AppTheme.white)),
        backgroundColor: AppTheme.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
