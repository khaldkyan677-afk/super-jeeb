import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kRed = Color(0xFFEF233C);
const _kBg = Color(0xFF0D0D12);
const _kSurface = Color(0xFF1A1B26);
const _kGreen = Color(0xFF25D366);

class TrackOrderScreen extends StatefulWidget {
  final String serviceType;
  const TrackOrderScreen({super.key, required this.serviceType});
  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  int _step = 1;
  final _steps = ['تم الاستلام', 'الكابتن في الطريق', 'وصل للعميل'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text('تتبع ${widget.serviceType}', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMap(),
          const SizedBox(height: 16),
          _buildCaptain(),
          const SizedBox(height: 16),
          _buildTimeline(),
          const SizedBox(height: 20),
          _buildCancel(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [_kRed.withOpacity(0.2), _kSurface], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Center(child: Icon(Icons.map, color: _kRed.withOpacity(0.3), size: 100)),
          Positioned(top: 16, right: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _kGreen, borderRadius: BorderRadius.circular(10)), child: Text('مباشر', style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))),
          Positioned(bottom: 16, left: 16, right: 16, child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _kBg.withOpacity(0.85), borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.access_time, color: _kRed, size: 18), const SizedBox(width: 8), Text('الوصول خلال ~12 دقيقة', style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600))]))),
        ],
      ),
    );
  }

  Widget _buildCaptain() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(width: 56, height: 56, decoration: BoxDecoration(color: _kBg, shape: BoxShape.circle, border: Border.all(color: _kRed, width: 2)), child: const Icon(Icons.person, color: _kRed, size: 28)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('خالد الكابتن', style: GoogleFonts.cairo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.star, color: Color(0xFFF0C107), size: 14), const SizedBox(width: 4), Text('4.9', style: GoogleFonts.cairo(color: Colors.white, fontSize: 12)), const SizedBox(width: 8), const Icon(Icons.directions_car, color: Colors.grey, size: 14), const SizedBox(width: 4), Text('تويوتا - 1234', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12))]),
          ])),
          _circleBtn(Icons.phone, () {}),
          const SizedBox(width: 8),
          _circleBtn(Icons.chat_bubble_outline, () {}),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(width: 38, height: 38, decoration: BoxDecoration(color: _kRed.withOpacity(0.15), shape: BoxShape.circle), child: Icon(icon, color: _kRed, size: 18)));
  }

  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: List.generate(_steps.length, (i) {
          final done = i <= _step;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Column(
                  children: [
                    Container(width: 28, height: 28, decoration: BoxDecoration(color: done ? _kRed : _kBg, shape: BoxShape.circle, border: Border.all(color: done ? _kRed : Colors.grey, width: 2)), child: done ? const Icon(Icons.check, color: Colors.white, size: 16) : null),
                    if (i < _steps.length - 1) Container(width: 2, height: 24, color: done ? _kRed : Colors.grey[800]),
                  ],
                ),
                const SizedBox(width: 14),
                Text(_steps[i], style: GoogleFonts.cairo(color: done ? Colors.white : Colors.grey, fontSize: 14, fontWeight: done ? FontWeight.w700 : FontWeight.w500)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCancel() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: _kRed.withOpacity(0.4))),
        child: Center(child: Text('إلغاء الطلب', style: GoogleFonts.cairo(color: _kRed, fontWeight: FontWeight.w700))),
      ),
    );
  }
}
