import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';
import '../theme/app_theme.dart';
import '../widgets/store_logo_animated.dart';
import '../widgets/location_picker.dart';
import '../services/location_service.dart';

class OnboardingLocationScreen extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback? onSkip;
  const OnboardingLocationScreen({super.key, required this.onComplete, this.onSkip});

  @override
  State<OnboardingLocationScreen> createState() => _OnboardingLocationScreenState();
}

class _OnboardingLocationScreenState extends State<OnboardingLocationScreen> {
  bool _isLoadingGps = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.dark.withOpacity(0.97),
      child: SafeArea(
        child: Stack(
          children: [
            // زر الإغلاق (تصفح بدون موقع)
            Positioned(
              top: 8, left: 8,
              child: IconButton(
                onPressed: () {
                  if (widget.onSkip != null) widget.onSkip!();
                },
                icon: const Icon(Icons.close, color: AppTheme.white, size: 26),
                tooltip: 'تصفح بدون موقع',
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              child: Column(
                children: [
                  const SizedBox(width: 160, height: 160, child: StoreLogoAnimated(size: 140)),
                  const SizedBox(height: 15),
                  Text('حدد موقعك',
                    style: TextStyle(color: AppTheme.white, fontSize: 26,
                      fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  const SizedBox(height: 10),
                  Text('لتجربة مميزة وأسعار مناسبة لمنطقتك',
                    style: TextStyle(color: Colors.white70, fontSize: 14,
                      fontFamily: 'Cairo', height: 1.6),
                    textAlign: TextAlign.center),
                  const SizedBox(height: 40),

                  _btn(icon: _isLoadingGps ? null : Icons.my_location,
                    label: _isLoadingGps ? 'جاري تحديد موقعك...' : 'استخدم موقعي الحالي',
                    subtitle: 'تجربة مخصصة حسب منطقتك',
                    primary: true, loading: _isLoadingGps,
                    onTap: _isLoadingGps ? null : _useGps),
                  const SizedBox(height: 12),
                  _btn(icon: Icons.edit_location_alt,
                    label: 'أدخل موقعك يدوياً',
                    subtitle: 'اختر المدينة والمديرية',
                    primary: false, onTap: _pickManually),
                  const SizedBox(height: 12),
                  _btn(icon: Icons.explore_outlined,
                    label: 'تصفح بدون موقع',
                    subtitle: 'ستعرض أسعار افتراضية',
                    primary: false, ghost: true,
                    onTap: () { if (widget.onSkip != null) widget.onSkip!(); }),

                  const SizedBox(height: 25),
                  Text('يمكنك تغيير الموقع لاحقاً من الرئيسية',
                    style: TextStyle(color: Colors.white38, fontSize: 11,
                      fontFamily: 'Cairo'), textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn({
    required IconData? icon, required String label, required String subtitle,
    required bool primary, required VoidCallback? onTap,
    bool loading = false, bool ghost = false,
  }) {
    final bg = primary ? AppTheme.red : (ghost ? Colors.transparent : AppTheme.surface);
    final border = primary ? AppTheme.red : (ghost ? Colors.white24 : Colors.white12);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border)),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary ? AppTheme.white.withOpacity(0.2) : AppTheme.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12)),
            child: loading
              ? const SizedBox(width: 22, height: 22,
                  child: CircularProgressIndicator(color: AppTheme.white, strokeWidth: 2))
              : Icon(icon ?? Icons.location_on, color: primary ? AppTheme.white : AppTheme.red, size: 24)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(color: AppTheme.white, fontSize: 15,
              fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            const SizedBox(height: 3),
            Text(subtitle, style: TextStyle(
              color: primary ? Colors.white70 : Colors.white54,
              fontSize: 12, fontFamily: 'Cairo')),
          ])),
          Icon(Icons.arrow_forward_ios, color: primary ? AppTheme.white : Colors.white54, size: 14),
        ]),
      ),
    );
  }

  Future<void> _useGps() async {
    setState(() => _isLoadingGps = true);
    try {
      final Position pos;

      if (kIsWeb) {
        // ═══ الويب: المتصفح يعرض النافذة تلقائياً ═══
        pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 15),
        );
      } else {
        // ═══ الجوال: فحص كامل ═══
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) { _fail('خدمة الموقع غير مفعّلة، فعّلها من الإعدادات'); return; }

        LocationPermission perm = await Geolocator.checkPermission();
        if (perm == LocationPermission.denied) {
          perm = await Geolocator.requestPermission();
        }
        if (perm == LocationPermission.denied) { _fail('تم رفض إذن الموقع'); return; }
        if (perm == LocationPermission.deniedForever) {
          _fail('إذن الموقع مرفوض نهائياً، فعّله من الإعدادات'); return;
        }

        pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        ).timeout(const Duration(seconds: 15));
      }

      final d = _detect(pos.latitude, pos.longitude);
      await LocationService.save(
        city: d['city']!, district: d['district']!,
        currency: d['currency']!, lat: pos.latitude, lng: pos.longitude,
      );
      if (mounted) widget.onComplete();
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('denied') || msg.contains('permission')) {
        _fail('تم رفض إذن الموقع، افتحه من إعدادات المتصفح');
      } else if (msg.contains('timeout')) {
        _fail('فشل تحديد الموقع — تأكد من الإنترنت');
      } else {
        _fail('فشل تحديد الموقع، حاول مرة أخرى');
      }
    }
  }

  Map<String, String> _detect(double lat, double lng) {
    if (lat >= 15.30 && lat <= 15.50 && lng >= 44.10 && lng <= 44.25)
      return {'city': 'صنعاء', 'district': 'شملان', 'currency': 'قديم'};
    if (lat >= 15.30 && lat <= 15.40 && lng >= 44.20 && lng <= 44.30)
      return {'city': 'صنعاء', 'district': 'حدة', 'currency': 'قديم'};
    if (lat >= 12.85 && lat <= 12.95 && lng >= 44.95 && lng <= 45.10)
      return {'city': 'عدن', 'district': 'المنصورة', 'currency': 'جديد'};
    return {'city': 'صنعاء', 'district': 'شملان', 'currency': 'قديم'};
  }

  void _fail(String msg) {
    if (mounted) setState(() => _isLoadingGps = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: TextStyle(fontFamily: 'Cairo', color: AppTheme.white)),
      backgroundColor: AppTheme.red, duration: const Duration(seconds: 3)));
  }

  Future<void> _pickManually() async {
    final r = await showModalBottomSheet<Map<String, String>>(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => LocationPicker(currentCity: LocationService.city));
    if (r != null && mounted) {
      await LocationService.save(city: r['city'] ?? 'صنعاء', district: '',
        currency: r['currency'] ?? 'قديم');
      widget.onComplete();
    }
  }
}
