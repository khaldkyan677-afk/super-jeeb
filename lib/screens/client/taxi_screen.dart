import 'package:flutter/material.dart';
import '../../services/active_trip.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'wallet_screen.dart';
import 'trip_history_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;

class TaxiScreen extends StatefulWidget {
  const TaxiScreen({super.key});
  @override
  State<TaxiScreen> createState() => _TaxiScreenState();
}

class _TaxiScreenState extends State<TaxiScreen> {
  bool _chatOpen = false;
  String _driverName = '';
  final List<Map<String, String>> _chatMessages = [];
  final List<Map<String, dynamic>> _tripHistory = [];
  int _currentRating = 0;
  String _currentFeedback = '';
  final List<Map<String, dynamic>> _myReports = [];
  bool _isOsrmLoading = false;
  List<LatLng> _routePoints = [];
  int _osrmDurationSec = 0;
  double _driverDistance = 0;

  static const Color navy = Color(0xFF2B2D42);
  static const Color red = Color(0xFFEF233C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF25D366);
  static const Color yellow = Color(0xFFF0C107);

  LatLng? _currentPosition;
  LatLng? _pickupLatLng;
  LatLng? _dropoffLatLng;
  String? _pickup;
  String? _dropoff;
  String _city = 'صنعاء';
  String _currency = 'YER_OLD';
  String _selectedCarType = 'economy';
  String _paymentMethod = 'cash';
  bool _isLoading = false;
  bool _isLocating = true;
  bool _showDriverInfo = false;
  double? _distanceKm;
  double? _calculatedFare;
  String _pin = '';
  bool _isNight = false;
  bool _hasLuggage = false;
  bool _isWaiting = false;
  final MapController _mapController = MapController();

  final Map<String, List<double>> _cityBounds = {
    'صنعاء': [15.15, 15.55, 44.00, 44.40],
    'عدن': [12.70, 13.05, 44.75, 45.10],
    'تعز': [13.40, 13.75, 43.85, 44.25],
    'الحديدة': [14.60, 15.00, 42.75, 43.25],
    'إب': [13.85, 14.10, 44.00, 44.30],
    'ذمار': [14.45, 14.70, 44.20, 44.55],
    'مأرب': [15.35, 15.60, 45.20, 45.55],
    'المكلا': [14.45, 14.65, 48.95, 49.25],
  };

  final Map<String, String> _cityCurrency = {
    'صنعاء': 'YER_OLD',
    'الحديدة': 'YER_OLD',
    'إب': 'YER_OLD',
    'ذمار': 'YER_OLD',
    'عدن': 'YER_NEW',
    'تعز': 'YER_NEW',
    'مأرب': 'YER_NEW',
    'المكلا': 'YER_NEW',
  };

  final Map<String, Map<String, double>> _pricing = {
    'YER_OLD': {
      'economy_base': 200, 'economy_km': 120,
      'comfort_base': 350, 'comfort_km': 200,
      'moto_base': 100, 'moto_km': 70,
      'injez_base': 500, 'injez_km': 300,
    },
    'YER_NEW': {
      'economy_base': 600, 'economy_km': 360,
      'comfort_base': 1050, 'comfort_km': 600,
      'moto_base': 300, 'moto_km': 210,
      'injez_base': 1500, 'injez_km': 900,
    },
  };

  Map<String, Map<String, dynamic>> get _carTypes => {
    'economy': {'name': 'اقتصادي', 'icon': Icons.directions_car, 'color': red, 'eta': '5 دقائق', 'baseKey': 'economy_base', 'kmKey': 'economy_km'},
    'comfort': {'name': 'مريح', 'icon': Icons.local_taxi, 'color': navy, 'eta': '3 دقائق', 'baseKey': 'comfort_base', 'kmKey': 'comfort_km'},
    'moto': {'name': 'مُتر', 'icon': Icons.two_wheeler, 'color': Colors.orange, 'eta': 'دقيقتين', 'baseKey': 'moto_base', 'kmKey': 'moto_km'},
    'injez': {'name': 'إنجيز', 'icon': Icons.airport_shuttle, 'color': Colors.green, 'eta': '7 دقائق', 'baseKey': 'injez_base', 'kmKey': 'injez_km'},
  };

  double _getBase() => _pricing[_currency]![_carTypes[_selectedCarType]!['baseKey']]!;
  double _getPerKm() => _pricing[_currency]![_carTypes[_selectedCarType]!['kmKey']]!;
  String get _currencyLabel => _currency == 'YER_NEW' ? 'جديد' : 'قديم';

  @override
  void initState() {
    super.initState();
    _getLocation();
    _restoreActiveTrip();
  }

  Future<void> _restoreActiveTrip() async {
    final trip = await ActiveTrip.load();
    if (trip == null || !mounted) return;
    setState(() {
      _pin = trip['pin'] ?? '';
      _driverName = trip['driverName'] ?? '';
      _driverDistance = (trip['driverDistance'] as num?)?.toDouble() ?? 0.0;
      _calculatedFare = (trip['fare'] as num?)?.toDouble();
      _pickup = trip['pickup'];
      _dropoff = trip['dropoff'];
      _showDriverInfo = false;
    });
  }

  Future<void> _getLocation() async {
    setState(() => _isLocating = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) { _fallback(); return; }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _fallback(); return;
      }
      final pos = await Geolocator.getCurrentPosition();
      final latLng = LatLng(pos.latitude, pos.longitude);
      final city = _detectCity(pos.latitude, pos.longitude);
      setState(() {
        _currentPosition = latLng;
        _pickupLatLng = latLng;
        _pickup = 'موقعي الحالي';
        _city = city;
        _currency = _cityCurrency[city] ?? 'YER_OLD';
        _isLocating = false;
      });
      _mapController.move(latLng, 14);
    } catch (e) {
      _fallback();
    }
  }

  void _fallback() {
    final p = LatLng(15.3694, 44.1910);
    setState(() {
      _currentPosition = p;
      _pickupLatLng = p;
      _pickup = 'موقعي الحالي (افتراضي)';
      _city = 'صنعاء';
      _currency = 'YER_OLD';
      _isLocating = false;
    });
  }

  String _detectCity(double lat, double lng) {
    for (final e in _cityBounds.entries) {
      final b = e.value;
      if (lat >= b[0] && lat <= b[1] && lng >= b[2] && lng <= b[3]) return e.key;
    }
    return 'صنعاء';
  }

  double _distance(LatLng a, LatLng b) {
    const R = 6371.0;
    final dLat = _toRad(b.latitude - a.latitude);
    final dLon = _toRad(b.longitude - a.longitude);
    final h = math.sin(dLat/2)*math.sin(dLat/2) + math.cos(_toRad(a.latitude))*math.cos(_toRad(b.latitude))*math.sin(dLon/2)*math.sin(dLon/2);
    return R * 2 * math.atan2(math.sqrt(h), math.sqrt(1-h));
  }

  double _toRad(double d) => d * math.pi / 180;

  void _recalc() {
    if (_pickupLatLng != null && _dropoffLatLng != null) {
      _distanceKm = _distance(_pickupLatLng!, _dropoffLatLng!);
    } else {
      _distanceKm = null;
    }
    if (_distanceKm != null) {
      double total = _getBase() + (_distanceKm! * _getPerKm());
      if (_isNight) total *= 1.3;
      if (_hasLuggage) total += (_currency == 'YER_NEW' ? 600 : 200);
      if (_isWaiting) total += (_currency == 'YER_NEW' ? 300 : 100);
      _calculatedFare = total;
    } else {
      _calculatedFare = null;
    }
  }

  double _getKmCost() => _distanceKm != null ? (_distanceKm! * _getPerKm()) : 0;
  double _getExtras() {
    double e = 0;
    if (_isNight) e += (_getBase() + _getKmCost()) * 0.3;
    if (_hasLuggage) e += (_currency == 'YER_NEW' ? 600 : 200);
    if (_isWaiting) e += (_currency == 'YER_NEW' ? 300 : 100);
    return e;
  }
  String _getEta() {
    if (_distanceKm == null) return '--';
    final factor = _selectedCarType == 'moto' ? 1.8 : (_selectedCarType == 'injez' ? 3.0 : 2.5);
    final mins = (_distanceKm! * factor).round();
    return mins < 1 ? 'أقل من دقيقة' : '$mins دقيقة';
  }

  void _request() {
    if (_pickupLatLng == null || _dropoffLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدد موقع الانطلاق والوجهة'), backgroundColor: red));
      return;
    }
    setState(() { _isLoading = true; _pin = (1000 + math.Random().nextInt(9000)).toString(); });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() { _isLoading = false; _showDriverInfo = true; });
    });
    ActiveTrip.save(
      pin: _pin,
      driverName: _driverName,
      driverDistance: _driverDistance,
      fare: _calculatedFare ?? 0.0,
      pickup: _pickup ?? '',
      dropoff: _dropoff ?? '',
      carType: _carTypes[_selectedCarType]!['name'] as String,
    );
  }

  void _useCurrentLocation() {
    if (_currentPosition != null) {
      setState(() { _pickupLatLng = _currentPosition; _pickup = 'موقعي الحالي'; _recalc(); });
      _mapController.move(_currentPosition!, 14);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: navy,
        title: const Text('🚗 تاكسي', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: white),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TripHistoryScreen(trips: _tripHistory))),
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet, color: white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen())),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: yellow.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Center(child: Text('${_currencyLabel} • $_city', style: const TextStyle(color: yellow, fontSize: 11, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [_buildMapArea(), _buildBottomSheet()]),
      ),
    );
  }

  Widget _buildMapArea() {
    final center = _currentPosition ?? const LatLng(15.3694, 44.1910);
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 13,
              onTap: (_, point) {
                setState(() { _dropoffLatLng = point; _dropoff = 'موقع محدد على الخريطة'; _recalc(); });
                _fetchOsrmRoute();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.superjeeb.app',
              ),
              MarkerLayer(markers: [
                if (_pickupLatLng != null)
                  Marker(point: _pickupLatLng!, width: 40, height: 40, child: const Icon(Icons.radio_button_checked, color: green, size: 30)),
                if (_dropoffLatLng != null)
                  Marker(point: _dropoffLatLng!, width: 40, height: 40, child: const Icon(Icons.location_on, color: red, size: 35)),
              ]),
              if (_routePoints.isNotEmpty)
                PolylineLayer(polylines: [
                  Polyline(points: _routePoints, strokeWidth: 4, color: navy),
                ])
              else if (_pickupLatLng != null && _dropoffLatLng != null)
                PolylineLayer(polylines: [
                  Polyline(points: [_pickupLatLng!, _dropoffLatLng!], strokeWidth: 4, color: navy),
                ]),
            ],
          ),
          if (_isLocating)
            Container(
              color: Colors.black38,
              child: const Center(child: CircularProgressIndicator(color: white)),
            ),
          Positioned(
            top: 15, left: 15, right: 15,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10)]),
              child: Column(children: [
                _buildLocRow(Icons.radio_button_checked, green, _pickup ?? 'موقع الانطلاق', true),
                Divider(height: 8, color: Colors.grey.shade300),
                _buildLocRow(Icons.location_on, red, _dropoff ?? 'اضغط على الخريطة لتحديد الوجهة', false),
              ]),
            ),
          ),
          Positioned(
            bottom: 15, right: 15,
            child: FloatingActionButton.small(
              backgroundColor: white,
              onPressed: _useCurrentLocation,
              child: const Icon(Icons.my_location, color: navy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocRow(IconData icon, Color color, String text, bool isPickup) {
    final hasValue = !text.startsWith('موقع') && !text.startsWith('اضغط');
    return InkWell(
      onTap: () => _showManualInput(isPickup),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
        child: Row(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(text, style: TextStyle(fontSize: 13, color: hasValue ? navy : Colors.grey, fontWeight: FontWeight.w500)),
            Text('اضغط للتعديل / الكتابة اليدوية', style: TextStyle(fontSize: 10, color: navy.withOpacity(0.5))),
          ])),
          if (hasValue)
            InkWell(
              onTap: () => setState(() {
                if (isPickup) { _pickup = null; _pickupLatLng = null; }
                else { _dropoff = null; _dropoffLatLng = null; }
                _recalc();
              }),
              child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.close, size: 18, color: Colors.red)),
            ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: navy.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.edit, size: 16, color: navy),
          ),
        ]),
      ),
    );
  }

  Widget _buildBottomSheet() {
    if (_showDriverInfo) return _buildDriverInfo();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (_pin.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: green.withOpacity(0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: green)),
            child: Row(children: [
              const Icon(Icons.directions_car, color: green, size: 26),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🚗 $_driverName في الطريق إليك', style: const TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 13)),
                Text('الرمز: $_pin • اضغط للتفاصيل', style: TextStyle(fontSize: 11, color: navy.withOpacity(0.8))),
              ])),
              ElevatedButton(
                onPressed: () => setState(() => _showDriverInfo = true),
                style: ElevatedButton.styleFrom(backgroundColor: green, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                child: const Text('عرض', style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ]),
          ),
        if (_distanceKm != null && _calculatedFare != null) ...[
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [navy, navy.withOpacity(0.85)]), borderRadius: BorderRadius.circular(15)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Row(children: [Icon(Icons.route, color: green, size: 20), SizedBox(width: 8), Text('المسافة', style: TextStyle(color: white, fontSize: 13))]),
                Text('${_distanceKm!.toStringAsFixed(1)} كم', style: const TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 15)),
              ]),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Row(children: [Icon(Icons.schedule, color: yellow, size: 20), SizedBox(width: 8), Text('الوقت المتوقع', style: TextStyle(color: white, fontSize: 13))]),
                Text(_getOsrmEta(), style: const TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 15)),
              ]),
              Divider(color: white.withOpacity(0.3), height: 20),
              _priceRow('سعر الفتح', _getBase()),
              _priceRow('تكلفة ${_distanceKm!.toStringAsFixed(1)} كم', _getKmCost()),
              if (_getExtras() > 0) _priceRow('إضافات', _getExtras()),
              Divider(color: white.withOpacity(0.3), height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('الإجمالي', style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${_calculatedFare!.toStringAsFixed(0)} YER', style: const TextStyle(color: yellow, fontWeight: FontWeight.bold, fontSize: 20)),
              ]),
            ]),
          ),
          const SizedBox(height: 15),
        ],
        const Text('اختر نوع السيارة:', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 15)),
        const SizedBox(height: 10),
        ..._carTypes.entries.map((e) => _buildCarOption(e.key, e.value)),
        const SizedBox(height: 15),
        _buildPaymentMethod(),
        const SizedBox(height: 15),
        _buildSafetyRow(),
        const SizedBox(height: 15),
        if (_calculatedFare != null)
          Center(child: Text('💰 السعر المتوقع: ${_calculatedFare!.toStringAsFixed(0)} YER', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: red))),
        const SizedBox(height: 15),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () => _showExtrasDialog(),
          icon: const Icon(Icons.add_circle_outline, color: navy, size: 18),
          label: Text('➕ إضافات (${_extrasCount()})', style: const TextStyle(color: navy, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(side: const BorderSide(color: navy), padding: const EdgeInsets.symmetric(vertical: 10)),
        )),
        const SizedBox(height: 15),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: _isLoading ? null : _request,
          style: ElevatedButton.styleFrom(backgroundColor: red, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          child: _isLoading
              ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: white, strokeWidth: 2))
              : const Text('🚗 اطلب الكابتن الآن', style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.bold)),
        )),
      ]),
    );
  }

  Widget _buildChip(String label, bool selected, Function(bool) onChanged) {
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: selected ? white : navy, fontSize: 11)),
      selected: selected, onSelected: onChanged, selectedColor: red, backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(color: selected ? white : navy, fontSize: 11, fontWeight: FontWeight.w600),
    );
  }

  Widget _priceRow(String label, double value) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(color: white.withOpacity(0.8), fontSize: 12)),
      Text('${value.toStringAsFixed(0)} YER', style: const TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w500)),
    ]));
  }

  Widget _buildCarOption(String key, Map<String, dynamic> data) {
    final isSelected = _selectedCarType == key;
    double fullPrice = _pricing[_currency]![data['baseKey']]!;
    if (_distanceKm != null) fullPrice += _distanceKm! * _pricing[_currency]![data['kmKey']]!;
    final price = '${fullPrice.toStringAsFixed(0)} YER';
    return InkWell(
      onTap: () => setState(() { _selectedCarType = key; _recalc(); }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? red.withOpacity(0.08) : white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? red : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Row(children: [
          Icon(data['icon'] as IconData, color: data['color'] as Color, size: 35),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: navy)),
            Text('الوصول: ${data['eta']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ])),
          Text(price, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isSelected ? red : navy)),
        ]),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return InkWell(
      onTap: _showPaymentDialog,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
        child: Row(children: [
          Icon(_paymentMethod == 'cash' ? Icons.payments : Icons.account_balance_wallet, color: navy, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('طريقة الدفع', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text(_paymentMethodLabel(), style: const TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 13)),
          ])),
          const Icon(Icons.arrow_drop_down, color: navy),
        ]),
      ),
    );
  }

  String _paymentMethodLabel() {
    switch (_paymentMethod) {
      case 'cash': return '💵 كاش عند الاستلام';
      case 'wallet_app': return '📱 محفظتي';
      case 'official_account': return '🏦 حساب رسمي للتطبيق';
      default: return '💵 كاش';
    }
  }

  void _showPaymentDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 20),
          const Text('💳 اختر طريقة الدفع', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 18)),
          const SizedBox(height: 20),
          _paymentOption('cash', '💵 كاش عند الاستلام', 'ادفع للمندوب مباشرة'),
          _paymentOption('wallet_app', '📱 محفظتي', 'رصيدك الحالي: 1,500 YER'),
          _paymentOption('official_account', '🏦 الحساب الرسمي للتطبيق', 'رقم المحفظة الرسمي (من الأدمن)'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: const Row(children: [
              Icon(Icons.security, color: Colors.amber, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text('الدفع عبر محافظ التطبيق الرسمية آمن ومحمي من النصب', style: TextStyle(fontSize: 11, color: navy))),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _paymentOption(String value, String title, String subtitle) {
    final selected = _paymentMethod == value;
    return InkWell(
      onTap: () {
        if (value == 'official_account') {
          Navigator.pop(context);
          _showOfficialAccounts();
          return;
        }
        setState(() => _paymentMethod = value);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? red.withOpacity(0.08) : white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? red : Colors.grey.shade300, width: selected ? 2 : 1),
        ),
        child: Row(children: [
          Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: selected ? red : Colors.grey),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 13)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ])),
        ]),
      ),
    );
  }

  Widget _buildSafetyRow() {
    return Row(children: [
      Expanded(child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.emergency, color: red, size: 18),
        label: const Text('طوارئ', style: TextStyle(color: red, fontSize: 12)),
        style: OutlinedButton.styleFrom(side: const BorderSide(color: red)),
      )),
      const SizedBox(width: 10),
      Expanded(child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.share_location, color: navy, size: 18),
        label: const Text('شارك الرحلة', style: TextStyle(color: navy, fontSize: 12)),
        style: OutlinedButton.styleFrom(side: const BorderSide(color: navy)),
      )),
    ]);
  }

  Widget _buildDriverInfo() {
    if (_chatOpen) return _buildChatView();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: Column(children: [
        Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            const Icon(Icons.check_circle, color: green, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text('$_driverName قبل طلبك • يبعد عنك ${_driverDistance.toStringAsFixed(1)} كم', style: const TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 13))),
          ]),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: yellow.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            const Icon(Icons.access_time, color: Color(0xFFF0C107), size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text('سيصل إليك خلال ${_driverArrivalEta()}', style: const TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 13))),
          ]),
        ),
        const SizedBox(height: 15),
        Row(children: [
          const CircleAvatar(radius: 35, backgroundColor: navy, child: Icon(Icons.person, size: 40, color: white)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_driverName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: navy)),
            const SizedBox(height: 4),
            const Text('⭐⭐⭐⭐⭐ 4.9', style: TextStyle(color: Colors.amber, fontSize: 13)),
            const SizedBox(height: 4),
            const Text('تويوتا - 1234 ABC', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ])),
          IconButton(
            onPressed: _openChat,
            icon: const Icon(Icons.chat_bubble, color: green, size: 32),
          ),
        ]),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: green.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
          child: Column(children: [
            const Text('🔐 رمز التحقق (أعطه للمندوب عند الوصول)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: navy)),
            const SizedBox(height: 8),
            Text(_pin, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: green, letterSpacing: 8)),
          ]),
        ),
        const SizedBox(height: 15),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () => setState(() => _showDriverInfo = false),
          icon: const Icon(Icons.keyboard_arrow_down, color: navy),
          label: const Text('⬇️ إخفاء البانر (الرحلة محفوظة)', style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(side: const BorderSide(color: navy), padding: const EdgeInsets.symmetric(vertical: 12)),
        )),
        const SizedBox(height: 8),
                SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () {
            setState(() {
              _showDriverInfo = false; _pickup = null; _dropoff = null;
              _dropoffLatLng = null; _calculatedFare = null; _distanceKm = null;
              _pin = ''; _chatMessages.clear();
            });
          },
          icon: const Icon(Icons.cancel, color: red),
          label: const Text('إلغاء الرحلة', style: TextStyle(color: red)),
          style: OutlinedButton.styleFrom(side: const BorderSide(color: red), padding: const EdgeInsets.symmetric(vertical: 12)),
        )),
      ]),
    );
  }



  int _extrasCount() {
    int c = 0;
    if (_isNight) c++;
    if (_hasLuggage) c++;
    if (_isWaiting) c++;
    return c;
  }

  void _showExtrasDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text('➕ إضافات الرحلة', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 18)),
            const SizedBox(height: 20),
            _buildExtraTile('🌙 وقت الليل', '+30% على السعر', _isNight, (v) { setModalState(() {}); setState(() { _isNight = v; _recalc(); }); }),
            _buildExtraTile('🧳 أمتعة إضافية', '+${_currency == 'YER_NEW' ? 600 : 200} YER', _hasLuggage, (v) { setModalState(() {}); setState(() { _hasLuggage = v; _recalc(); }); }),
            _buildExtraTile('⏱️ وقت انتظار', '+${_currency == 'YER_NEW' ? 300 : 100} YER', _isWaiting, (v) { setModalState(() {}); setState(() { _isWaiting = v; _recalc(); }); }),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(backgroundColor: red, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('تم', style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 16)),
            )),
          ]),
        ),
      ),
    );
  }

  Widget _buildExtraTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: navy)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        value: value,
        activeColor: red,
        onChanged: onChanged,
      ),
    );
  }

  void _showManualInput(bool isPickup) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isPickup ? '📍 موقع الانطلاق' : '🎯 وجهة الوصول'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'اكتب العنوان يدوياً...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: red),
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                Navigator.pop(ctx);
                setState(() {
                  if (isPickup) _pickup = ctrl.text.trim();
                  else _dropoff = ctrl.text.trim();
                  final base = _currentPosition ?? LatLng(15.3694, 44.1910);
                  if (isPickup) {
                    _pickupLatLng = base;
                  } else {
                    _dropoffLatLng = LatLng(base.latitude + 0.03, base.longitude + 0.03);
                  }
                  _recalc();
                });
              }
            },
            child: const Text('تأكيد', style: TextStyle(color: white)),
          ),
        ],
      ),
    );
  }

  String _driverArrivalEta() {
    final mins = (_driverDistance / 0.5).round();
    return mins < 1 ? 'الآن' : '$mins دقيقة';
  }

  void _openChat() {
    if (!_showDriverInfo || _pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ لا يمكن الدردشة بدون طلب نشط'), backgroundColor: red),
      );
      return;
    }
    setState(() => _chatOpen = true);
    if (_chatMessages.isEmpty) {
      _chatMessages.add({'from': 'driver', 'text': 'السلام عليكم، أنا $_driverName في طريقي إليك'});
    }
  }

  void _closeChat() {
    setState(() => _chatOpen = false);
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _chatMessages.add({'from': 'me', 'text': text});
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _chatMessages.add({'from': 'driver', 'text': 'تمام، وصلت خلال دقائق'});
        });
      }
    });
  }

  Widget _buildChatView() {
    final ctrl = TextEditingController();
    return Container(
      height: 420,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(color: white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: Column(children: [
        Row(children: [
          IconButton(onPressed: _closeChat, icon: const Icon(Icons.arrow_back, color: navy)),
          const CircleAvatar(backgroundColor: navy, radius: 18, child: Icon(Icons.person, color: white, size: 20)),
          const SizedBox(width: 10),
          Expanded(child: Text('دردشة مع $_driverName', style: const TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 15))),
        ]),
        const Divider(),
        Expanded(child: ListView.builder(
          itemCount: _chatMessages.length,
          itemBuilder: (_, i) {
            final m = _chatMessages[i];
            final isMe = m['from'] == 'me';
            return Align(
              alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(10),
                constraints: const BoxConstraints(maxWidth: 250),
                decoration: BoxDecoration(
                  color: isMe ? yellow.withOpacity(0.3) : navy.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(m['text'] ?? '', style: const TextStyle(color: navy, fontSize: 13)),
              ),
            );
          },
        )),
        Row(children: [
          Expanded(child: TextField(
            controller: ctrl,
            decoration: InputDecoration(hintText: 'اكتب رسالة...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
            onSubmitted: (v) { _sendMessage(v); ctrl.clear(); },
          )),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () { _sendMessage(ctrl.text); ctrl.clear(); },
            icon: const Icon(Icons.send, color: green),
          ),
        ]),
      ]),
    );
  }

  void _showRatingDialog() {
    _currentRating = 0;
    _currentFeedback = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Row(children: [
            const CircleAvatar(backgroundColor: navy, radius: 20, child: Icon(Icons.person, color: white)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('قيّم $_driverName', style: const TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 15)),
              const Text('كيف كانت رحلتك؟', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ])),
          ]),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => IconButton(
              icon: Icon(i < _currentRating ? Icons.star : Icons.star_border, color: yellow, size: 40),
              onPressed: () => setModalState(() => _currentRating = i + 1),
            ))),
            const SizedBox(height: 10),
            Text(_ratingLabel(), style: const TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 14)),
            const SizedBox(height: 15),
            TextField(
              maxLines: 2,
              onChanged: (v) => _currentFeedback = v,
              decoration: InputDecoration(
                hintText: 'ملاحظات إضافية (اختياري)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ]),
          actions: [
            TextButton(
              onPressed: () { Navigator.pop(ctx); _resetAfterTrip(); },
              child: const Text('تخطي'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _currentRating > 0 ? green : Colors.grey),
              onPressed: _currentRating > 0 ? () {
                if (_tripHistory.isNotEmpty) {
                  _tripHistory[0]['rating'] = _currentRating;
                  _tripHistory[0]['feedback'] = _currentFeedback;
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('⭐ شكراً لتقييمك!'), backgroundColor: green),
                );
                _resetAfterTrip();
              } : null,
              child: const Text('إرسال', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  String _ratingLabel() {
    switch (_currentRating) {
      case 1: return '😞 سيء جداً';
      case 2: return '😕 سيء';
      case 3: return '😐 عادي';
      case 4: return '😊 جيد';
      case 5: return '🤩 ممتاز!';
      default: return 'اضغط على النجوم للتقييم';
    }
  }

  void _resetAfterTrip() {
    setState(() {
      _showDriverInfo = false;
      _pickup = null; _dropoff = null;
      _dropoffLatLng = null; _calculatedFare = null;
      _distanceKm = null; _pin = '';
      _chatMessages.clear();
      _currentRating = 0;
    });
  }

  void _showReportDialog({String? againstName, String? orderId}) {
    String selectedReason = '';
    final detailCtrl = TextEditingController();
    final List<String> reasons = [
      '🚗 المندوب تأخر كثيراً',
      '😠 سلوك غير لائق',
      '💰 طلب مبلغ إضافي',
      '🚧 لم يصل إلى الموقع',
      '📱 تحايل على الدردشة',
      '❌ رفض إكمال الرحلة',
      '🔧 مشكلة أخرى',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 20),
                Row(children: [
                  const Icon(Icons.report_problem, color: red, size: 28),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('🚨 رفع بلاغ', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 18)),
                    if (againstName != null) Text('ضد: $againstName', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ])),
                ]),
                const SizedBox(height: 20),
                const Text('اختر سبب البلاغ:', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 13)),
                const SizedBox(height: 10),
                ...reasons.map((r) => RadioListTile<String>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: r,
                  groupValue: selectedReason,
                  activeColor: red,
                  title: Text(r, style: const TextStyle(fontSize: 13, color: navy)),
                  onChanged: (v) => setModalState(() => selectedReason = v ?? ''),
                )),
                const SizedBox(height: 10),
                const Text('تفاصيل إضافية (اختياري):', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 13)),
                const SizedBox(height: 8),
                TextField(
                  controller: detailCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'اشرح المشكلة بالتفصيل...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: yellow.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Row(children: [
                    Icon(Icons.info_outline, color: yellow, size: 18),
                    SizedBox(width: 8),
                    Expanded(child: Text('سيتم مراجعة بلاغك خلال 24 ساعة', style: TextStyle(fontSize: 11, color: navy))),
                  ]),
                ),
                const SizedBox(height: 15),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(
                  onPressed: selectedReason.isEmpty ? null : () {
                    final now = DateTime.now();
                    _myReports.insert(0, {
                      'id': 'REP-${1000 + _myReports.length + 1}',
                      'reason': selectedReason,
                      'detail': detailCtrl.text.trim(),
                      'against': againstName ?? 'غير محدد',
                      'orderId': orderId ?? '--',
                      'status': 'pending',
                      'date': '${now.day}/${now.month}',
                      'time': '${now.hour}:${now.minute.toString().padLeft(2, "0")}',
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ تم رفع البلاغ بنجاح'), backgroundColor: green),
                    );
                  },
                  icon: const Icon(Icons.send, color: white),
                  label: const Text('إرسال البلاغ', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedReason.isEmpty ? Colors.grey : red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                )),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.emergency, color: red),
          SizedBox(width: 8),
          Text('🚨 طوارئ', style: TextStyle(color: red)),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('سيتم إرسال موقعك الحالي وأرقام الطوارئ:', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 15),
          _emergencyBtn('🚔 الشرطة', '194'),
          _emergencyBtn('🚑 الإسعاف', '191'),
          _emergencyBtn('🔥 الدفاع المدني', '191'),
          _emergencyBtn('📞 دعم Super Jeeb', '8000'),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📍 تم إرسال موقعك لفرق الطوارئ'), backgroundColor: red),
              );
            },
            icon: const Icon(Icons.location_on, color: white),
            label: const Text('إرسال موقعي الآن', style: TextStyle(color: white)),
            style: ElevatedButton.styleFrom(backgroundColor: red, minimumSize: const Size(double.infinity, 45)),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إغلاق')),
        ],
      ),
    );
  }

  Widget _emergencyBtn(String label, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        dense: true,
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(number, style: const TextStyle(color: red, fontWeight: FontWeight.bold, fontSize: 16)),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('📞 الاتصال بـ $number قريباً')));
        },
      ),
    );
  }

  void _shareTrip() {
    if (_pickup == null || _dropoff == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ حدد موقع الانطلاق والوجهة أولاً'), backgroundColor: red),
      );
      return;
    }
    final text = '''🚗 رحلة Super Jeeb

📍 من: $_pickup
🎯 إلى: $_dropoff
📏 المسافة: ${_distanceKm?.toStringAsFixed(1) ?? '--'} كم
💰 السعر: ${_calculatedFare?.toStringAsFixed(0) ?? '--'} YER

🔐 تابع رحلتي عبر تطبيق Super Jeeb''';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('📤 مشاركة الرحلة'),
        content: SingleChildScrollView(child: Text(text, style: const TextStyle(fontSize: 13))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: green),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ تم نسخ تفاصيل الرحلة'), backgroundColor: green),
              );
            },
            child: const Text('نسخ', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchOsrmRoute() async {
    if (_pickupLatLng == null || _dropoffLatLng == null) return;
    setState(() => _isOsrmLoading = true);
    try {
      final url = 'https://router.project-osrm.org/route/v1/driving/'
          '${_pickupLatLng!.longitude},${_pickupLatLng!.latitude};'
          '${_dropoffLatLng!.longitude},${_dropoffLatLng!.latitude}'
          '?overview=full&geometries=geojson';
      final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final double roadKm = (route['distance'] as num) / 1000.0;
          final int durationSec = (route['duration'] as num).toInt();
          final coords = route['geometry']['coordinates'] as List;
          final List<LatLng> points = coords.map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble())).toList();
          if (mounted) {
            setState(() {
              _distanceKm = roadKm;
              _routePoints = points;
              _osrmDurationSec = durationSec;
              _isOsrmLoading = false;
            });
            _recalcWithRoadDistance();
          }
        } else {
          setState(() => _isOsrmLoading = false);
        }
      } else {
        setState(() => _isOsrmLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isOsrmLoading = false);
    }
  }

  void _recalcWithRoadDistance() {
    if (_distanceKm == null) { _calculatedFare = null; return; }
    double total = _getBase() + (_distanceKm! * _getPerKm());
    if (_isNight) total *= 1.3;
    if (_hasLuggage) total += (_currency == 'YER_NEW' ? 600 : 200);
    if (_isWaiting) total += (_currency == 'YER_NEW' ? 300 : 100);
    _calculatedFare = total;
  }

  String _getOsrmEta() {
    if (_osrmDurationSec > 0) {
      final mins = (_osrmDurationSec / 60).ceil();
      return mins < 1 ? 'أقل من دقيقة' : '$mins دقيقة';
    }
    return _getEta();
  }

  void _showOfficialAccounts() {
    // هذه القائمة ستُجلب لاحقاً من الأدمن (API)
    final List<Map<String, String>> officialAccounts = [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 20),
          const Text('🏦 الحسابات الرسمية للتطبيق', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 18)),
          const SizedBox(height: 15),
          if (officialAccounts.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
              child: const Column(children: [
                Icon(Icons.info_outline, color: Colors.grey, size: 40),
                SizedBox(height: 10),
                Text('لم تتم إضافة حسابات رسمية بعد', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                SizedBox(height: 5),
                Text('سيتم تفعيل هذه الميزة عند إضافة الحسابات من لوحة الأدمن', style: TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
              ]),
            )
          else
            ...officialAccounts.map((acc) => Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: green),
                title: Text(acc['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(acc['number'] ?? ''),
                trailing: const Icon(Icons.content_copy, size: 18),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم نسخ رقم المحفظة'), backgroundColor: green)),
              ),
            )),
          const SizedBox(height: 15),
          if (officialAccounts.isNotEmpty)
            SizedBox(width: double.infinity, child: ElevatedButton.icon(
              onPressed: () { Navigator.pop(ctx); _showTransferDialog(); },
              icon: const Icon(Icons.swap_horiz, color: white),
              label: const Text('تحويل من محفظتي إلى حساب رسمي', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: green, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            )),
        ]),
      ),
    );
  }

  void _showTransferDialog() {
    final amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('💸 تحويل إلى حساب رسمي'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Row(children: [
              Icon(Icons.account_balance_wallet, color: green, size: 20),
              SizedBox(width: 8),
              Text('رصيد محفظتك: 1,500 YER', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: amountCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'المبلغ',
              prefixIcon: const Icon(Icons.attach_money, color: navy),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: green),
            onPressed: () {
              if (amountCtrl.text.trim().isNotEmpty) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ سيتم تحويل ${amountCtrl.text} YER قريباً'), backgroundColor: green),
                );
              }
            },
            child: const Text('تحويل', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
