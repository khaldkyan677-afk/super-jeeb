import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'driver_theme.dart';

class DriverMapScreen extends StatefulWidget {
  const DriverMapScreen({super.key});
  @override
  State<DriverMapScreen> createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  bool _online = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DJ.radarBg,
      body: SafeArea(
        child: Stack(
          children: [
            // خلفية الخريطة
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A0F14), Color(0xFF101820)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // شبكة الخريطة
            Positioned.fill(child: CustomPaint(painter: _GridPainter())),

            // الرأس
            Positioned(
              top: 0, left: 0, right: 0,
              child: _header(),
            ),

            // الرادار
            Center(child: _radar()),

            // نص
            Positioned(
              bottom: 140, left: 0, right: 0,
              child: Center(
                child: Text(
                  _online ? '... جاري البحث عن طلبات' : 'فعّل المفتاح لبدء الاستقبال',
                  style: GoogleFonts.cairo(color: _online ? Colors.white70 : Colors.white38, fontSize: 14),
                ),
              ),
            ),

            // زر
            Positioned(
              bottom: 60, left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    color: _online ? DJ.radarRed : DJ.radarSurface,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: _online ? [BoxShadow(color: DJ.radarRed.withValues(alpha: 0.5), blurRadius: 25, offset: const Offset(0, 6))] : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_online ? Icons.play_arrow_rounded : Icons.pause_rounded, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text(_online ? 'استلام طلب' : 'متوقف', style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ),

            // لوحة أسفل
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _bottomSheet(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: DJ.radarSurface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Text('رادار سوبر جيب', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
          const Spacer(),
          Text(_online ? 'ONLINE' : 'OFFLINE', style: GoogleFonts.cairo(
            color: _online ? DJ.success : Colors.white54,
            fontSize: 12, fontWeight: FontWeight.w800,
          )),
          const SizedBox(width: 10),
          Switch(
            value: _online,
            activeThumbColor: DJ.success,
            onChanged: (v) => setState(() => _online = v),
          ),
        ],
      ),
    );
  }

  Widget _radar() {
    return SizedBox(
      width: 260, height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الحلقة الخارجية
          Container(
            width: 240, height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _online ? DJ.radarRed : Colors.white24, width: 2),
            ),
          ),
          // حلقة وسطى
          Container(
            width: 160, height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _online ? DJ.radarRed.withValues(alpha: 0.4) : Colors.white12, width: 1),
            ),
          ),
          // حلقة داخلية
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _online ? DJ.radarRed.withValues(alpha: 0.6) : Colors.white12, width: 1),
            ),
          ),
          // القلب
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _online ? DJ.radarRed : DJ.radarSurface,
              boxShadow: _online ? [BoxShadow(color: DJ.radarRed.withValues(alpha: 0.6), blurRadius: 20)] : [],
            ),
            child: const Icon(Icons.wifi_tethering_rounded, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _bottomSheet() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: DJ.radarSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.apps_rounded, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Text('اختر نوع الخدمة', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _serviceType('سيارة', Icons.directions_car_rounded, true),
              const SizedBox(width: 8),
              _serviceType('حافلة', Icons.airport_shuttle_rounded, false),
              const SizedBox(width: 8),
              _serviceType('شاحنة', Icons.local_shipping_rounded, false),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(width: 10, height: 10, decoration: const BoxDecoration(color: DJ.success, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text('GPS مفعّل - جاري بث الموقع', style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _serviceType(String label, IconData icon, bool selected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? DJ.radarRed : DJ.radarBg,
          borderRadius: BorderRadius.circular(14),
          border: selected ? null : Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.white54, size: 24),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.cairo(
              color: selected ? Colors.white : Colors.white54,
              fontSize: 11, fontWeight: FontWeight.w700,
            )),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
