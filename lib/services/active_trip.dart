import 'package:shared_preferences/shared_preferences.dart';

class ActiveTrip {
  static const _kActive = 'active_trip_exists';
  static const _kPin = 'active_pin';
  static const _kDriver = 'active_driver_name';
  static const _kDist = 'active_driver_distance';
  static const _kFare = 'active_fare';
  static const _kFrom = 'active_pickup';
  static const _kTo = 'active_dropoff';
  static const _kCar = 'active_car_type';

  static Future<void> save({
    required String pin,
    required String driverName,
    required double driverDistance,
    required double fare,
    required String pickup,
    required String dropoff,
    required String carType,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kActive, true);
    await p.setString(_kPin, pin);
    await p.setString(_kDriver, driverName);
    await p.setDouble(_kDist, driverDistance);
    await p.setDouble(_kFare, fare);
    await p.setString(_kFrom, pickup);
    await p.setString(_kTo, dropoff);
    await p.setString(_kCar, carType);
  }

  static Future<Map<String, dynamic>?> load() async {
    final p = await SharedPreferences.getInstance();
    if (p.getBool(_kActive) != true) return null;
    return {
      'pin': p.getString(_kPin) ?? '',
      'driverName': p.getString(_kDriver) ?? '',
      'driverDistance': p.getDouble(_kDist) ?? 0.0,
      'fare': p.getDouble(_kFare) ?? 0.0,
      'pickup': p.getString(_kFrom) ?? '',
      'dropoff': p.getString(_kTo) ?? '',
      'carType': p.getString(_kCar) ?? '',
    };
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kActive);
    await p.remove(_kPin);
    await p.remove(_kDriver);
    await p.remove(_kDist);
    await p.remove(_kFare);
    await p.remove(_kFrom);
    await p.remove(_kTo);
    await p.remove(_kCar);
  }

  static Future<bool> hasActive() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kActive) ?? false;
  }
}
