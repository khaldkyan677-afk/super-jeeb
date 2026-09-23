import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import 'vehicle_widgets.dart';

class StoreLogoAnimated extends StatefulWidget {
  final double size;
  const StoreLogoAnimated({super.key, this.size = 220});

  @override
  State<StoreLogoAnimated> createState() => _StoreLogoAnimatedState();
}

class _StoreLogoAnimatedState extends State<StoreLogoAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _master;

  final List<IconData> _icons = [
    Icons.shopping_cart,
    Icons.local_pharmacy,
    Icons.restaurant,
    Icons.storefront,
    Icons.local_shipping,
    Icons.delivery_dining,
  ];

  final List<Color> _iconColors = [
    AppTheme.red,
    AppTheme.green,
    const Color(0xFFFFB300),
    AppTheme.red,
    const Color(0xFF4A90E2),
    AppTheme.green,
  ];

  @override
  void initState() {
    super.initState();
    _master = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    // تشغيل مرة واحدة فقط
    _master.forward();
  }

  @override
  void dispose() {
    _master.dispose();
    super.dispose();
  }

  double _progress(double start, double end) {
    final t = _master.value;
    if (t < start) return 0;
    if (t > end) return 1;
    return (t - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: widget.size,
        height: widget.size * 1.15,
        child: AnimatedBuilder(
          animation: _master,
          builder: (context, _) => _buildScene(),
        ),
      ),
    );
  }

  Widget _buildScene() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // ═══ الأيقونات الساقطة ═══
        for (int i = 0; i < _icons.length; i++) _buildFallingIcon(i),

        // ═══ المتجر ═══
        _buildStore(),

        // ═══ المركبات ═══
        _buildVehicle(0, const TaxiWidget(scale: 0.55), const Offset(-70, 55)),
        _buildVehicle(1, const ScooterWidget(scale: 0.55), const Offset(70, 55)),
        _buildVehicle(2, const BusWidget(scale: 0.45), const Offset(-95, 75)),
        _buildVehicle(3, const TruckWidget(scale: 0.5), const Offset(95, 75)),

        // ═══ الشخصيات ═══
        _buildWavingPerson(0, const Offset(-60, 85)),
        _buildWavingPerson(1, const Offset(0, 95)),
        _buildWavingPerson(2, const Offset(60, 85)),
      ],
    );
  }

  // ═══ الأيقونات الساقطة ═══
  Widget _buildFallingIcon(int index) {
    final start = index * 0.06;
    final end = start + 0.15;
    final progress = _progress(start, end);

    if (progress >= 1.0) {
      // استقرت داخل المتجر
      return Positioned(
        top: widget.size * 0.45 + (index % 3) * 18,
        left: widget.size * 0.28 + ((index ~/ 3) * 40) + (index % 3) * 15,
        child: RepaintBoundary(
          child: _iconCircle(_icons[index], _iconColors[index], 0.9),
        ),
      );
    }

    return Positioned(
      top: -40 + (widget.size * 0.55 + 40) * progress,
      left: widget.size * 0.28 + ((index ~/ 3) * 40) + (index % 3) * 15,
      child: RepaintBoundary(
        child: Opacity(
          opacity: progress.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.5 + progress * 0.4,
            
            child: _iconCircle(_icons[index], _iconColors[index], 1.0),
          ),
        ),
      ),
    );
  }

  Widget _iconCircle(IconData icon, Color color, double opacity) {
    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: color.withOpacity(0.9 * opacity),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }

  // ═══ المتجر ═══
  Widget _buildStore() {
    final p = _progress(0.25, 0.45);
    if (p <= 0) return const SizedBox.shrink();

    return RepaintBoundary(
      child: Opacity(
        opacity: p.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: 0.85 + p * 0.15,
          
          child: Container(
            width: widget.size * 0.68,
            height: widget.size * 0.58,
            decoration: BoxDecoration(
              color: AppTheme.charcoal,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.red.withOpacity(0.7), width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.red.withOpacity(0.3),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Super-Jeeb',
                    style: TextStyle(color: Colors.white, fontSize: 11,
                      fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ),
                const SizedBox(height: 6),
                Container(width: widget.size * 0.5, height: 3, color: Colors.white12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══ المركبات ═══
  Widget _buildVehicle(int index, Widget vehicle, Offset position) {
    final start = 0.45 + index * 0.06;
    final end = start + 0.2;
    final p = _progress(start, end);

    final fromLeft = position.dx < 0 ? -200.0 : 200.0;
    final currentX = fromLeft + (position.dx - fromLeft) * p;

    return Positioned(
      left: widget.size / 2 + currentX - 60,
      top: widget.size / 2 + position.dy,
      child: RepaintBoundary(
        child: Opacity(
          opacity: p.clamp(0.0, 1.0),
          child: vehicle,
        ),
      ),
    );
  }

  // ═══ الشخصيات ═══
  Widget _buildWavingPerson(int index, Offset position) {
    final start = 0.75 + index * 0.05;
    final end = start + 0.15;
    final p = _progress(start, end);

    // حركة التلويح تعتمد على الوقت (sin wave)
    final time = DateTime.now().millisecondsSinceEpoch / 300.0;
    final wave = (math.sin(time) + 1) * 0.5;

    return Positioned(
      left: widget.size / 2 + position.dx - 15,
      top: widget.size / 2 + position.dy,
      child: RepaintBoundary(
        child: Opacity(
          opacity: p.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.6 + p * 0.4,
            
            child: SizedBox(
              width: 30, height: 40,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0, left: 10,
                    child: Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4A574),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.charcoal, width: 1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12, left: 8,
                    child: Container(
                      width: 16, height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8 - wave * 4,
                    right: -2,
                    child: Transform.rotate(
                      angle: -0.4 + wave * 0.8,
                      child: Container(
                        width: 3, height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A574),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
