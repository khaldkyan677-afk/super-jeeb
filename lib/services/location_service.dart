import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  // ═══ القيم الحالية ═══
  static String city = 'صنعاء';
  static String district = '';
  static String currency = 'قديم';
  static double? lat;
  static double? lng;
  static bool hasLocation = false;

  // ═══ حفظ الموقع ═══
  static Future<void> save({
    required String city,
    required String district,
    required String currency,
    double? lat,
    double? lng,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('loc_city', city);
    await p.setString('loc_district', district);
    await p.setString('loc_currency', currency);
    if (lat != null) await p.setDouble('loc_lat', lat);
    if (lng != null) await p.setDouble('loc_lng', lng);
    await p.setBool('loc_has', true);

    LocationService.city = city;
    LocationService.district = district;
    LocationService.currency = currency;
    LocationService.lat = lat;
    LocationService.lng = lng;
    LocationService.hasLocation = true;
  }

  // ═══ تحميل الموقع ═══
  static Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    LocationService.hasLocation = p.getBool('loc_has') ?? false;
    if (LocationService.hasLocation) {
      LocationService.city = p.getString('loc_city') ?? 'صنعاء';
      LocationService.district = p.getString('loc_district') ?? '';
      LocationService.currency = p.getString('loc_currency') ?? 'قديم';
      LocationService.lat = p.getDouble('loc_lat');
      LocationService.lng = p.getDouble('loc_lng');
    }
  }

  // ═══ مسح الموقع ═══
  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove('loc_city');
    await p.remove('loc_district');
    await p.remove('loc_currency');
    await p.remove('loc_lat');
    await p.remove('loc_lng');
    await p.remove('loc_has');

    LocationService.city = 'صنعاء';
    LocationService.district = '';
    LocationService.currency = 'قديم';
    LocationService.lat = null;
    LocationService.lng = null;
    LocationService.hasLocation = false;
  }

  // ═══ نص العرض ═══
  static String get displayText {
    if (district.isNotEmpty) return '$city • $district';
    return '$city • $currency';
  }
}
