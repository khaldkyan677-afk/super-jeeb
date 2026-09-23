import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class WelcomeAfterLogin extends StatefulWidget {
  final Widget nextScreen;
  const WelcomeAfterLogin({super.key, required this.nextScreen});

  @override
  State<WelcomeAfterLogin> createState() => _WelcomeAfterLoginState();
}

class _WelcomeAfterLoginState extends State<WelcomeAfterLogin>
    with SingleTickerProviderStateMixin {
  late AnimationController _master;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _master = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );
    _master.forward();

    _navTimer = Timer(const Duration(milliseconds: 8100), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => widget.nextScreen,
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _master.dispose();
    super.dispose();
  }

  double _prog(double startMs, double endMs) {
    final t = _master.value * 8000;
    if (t < startMs) return 0;
    if (t > endMs) return 1;
    return (t - startMs) / (endMs - startMs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _master,
          builder: (context, _) => _buildScene(),
        ),
      ),
    );
  }

  Widget _buildScene() {
    return Stack(
      children: [
        _buildWelcomeText(),
        _buildSuperman(),
        _buildAssembledLogo(),
        _buildBrandName(),
        _buildTaglines(),
      ],
    );
  }

  // ═══ 1. أهلاً وسهلاً ═══
  Widget _buildWelcomeText() {
    final p1 = _prog(0, 800);
    final p2 = _prog(1200, 1800);
    final opacity = p1 * (1 - p2);
    if (opacity <= 0.01) return const SizedBox.shrink();

    return Center(
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: 0.9 + p1 * 0.1,
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('أهلاً وسهلاً',
                style: TextStyle(color: AppTheme.white, fontSize: 42,
                  fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              const SizedBox(height: 12),
              Container(width: 60 * opacity, height: 2, color: AppTheme.red),
            ],
          ),
        ),
      ),
    );
  }

  // ═══ 2. سوبرمان شفاف ═══
  Widget _buildSuperman() {
    final p = _prog(1500, 2500);
    if (p <= 0) return const SizedBox.shrink();

    return Positioned.fill(
      child: RepaintBoundary(
        child: Opacity(
          opacity: 0.12 * p,
          child: Center(
            child: CustomPaint(
              size: const Size(280, 320),
              painter: _SupermanSilhouettePainter(),
            ),
          ),
        ),
      ),
    );
  }

  // ═══ 3. تجميع الشعار ═══
  Widget _buildAssembledLogo() {
    final p = _prog(2000, 4500);
    if (p <= 0) return const SizedBox.shrink();

    final sProgress = _prog(2000, 3500);
    final jProgress = _prog(2300, 3800);
    final arrowProgress = _prog(2600, 4100);
    final speedOpacity = p < 1.0 ? p * 0.8 : 0.0;

    return Center(
      child: RepaintBoundary(
        child: SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (speedOpacity > 0.05)
                Opacity(
                  opacity: speedOpacity.clamp(0.0, 1.0),
                  child: CustomPaint(
                    size: const Size(280, 280),
                    painter: _SpeedLinesPainter(),
                  ),
                ),
              Container(
                width: 200 * (0.5 + p * 0.5),
                height: 200 * (0.5 + p * 0.5),
                decoration: BoxDecoration(
                  color: AppTheme.charcoal,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: AppTheme.red.withOpacity(0.9), width: 2.5),
                ),
              ),
              Transform.translate(
                offset: Offset(-80 * (1 - sProgress), 0),
                child: Opacity(
                  opacity: sProgress.clamp(0.0, 1.0),
                  child: Text('S',
                    style: TextStyle(color: AppTheme.white, fontSize: 110,
                      fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ),
              ),
              Transform.translate(
                offset: Offset(80 * (1 - jProgress), 0),
                child: Opacity(
                  opacity: jProgress.clamp(0.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40, top: 20),
                    child: Text('J',
                      style: TextStyle(color: AppTheme.red, fontSize: 90,
                        fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  ),
                ),
              ),
              Positioned(
                right: 35,
                top: 30 + 40 * (1 - arrowProgress),
                child: Opacity(
                  opacity: arrowProgress.clamp(0.0, 1.0),
                  child: const Icon(Icons.arrow_upward,
                    color: AppTheme.red, size: 26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══ 4. Super-Jeep ═══
  Widget _buildBrandName() {
    final p = _prog(5000, 6000);
    if (p <= 0) return const SizedBox.shrink();

    return Align(
      alignment: const Alignment(0, 0.42),
      child: Opacity(
        opacity: p.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 15 * (1 - p)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 32,
                    fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'Super-', style: TextStyle(color: AppTheme.white)),
                    TextSpan(text: 'Jeep', style: TextStyle(color: AppTheme.red)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(width: 80 * p, height: 2, color: AppTheme.red),
            ],
          ),
        ),
      ),
    );
  }

  // ═══ 5. 3 عبارات ═══
  Widget _buildTaglines() {
    final p1 = _prog(6000, 6600);
    final p2 = _prog(6500, 7100);
    final p3 = _prog(7000, 7600);
    if (p1 <= 0) return const SizedBox.shrink();

    return Align(
      alignment: const Alignment(0, 0.62),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tagline('قدّم كـ تاجر', p1),
          const SizedBox(height: 4),
          _tagline('قدّم كـ مندوب', p2),
          const SizedBox(height: 4),
          _tagline('معًا نكافح', p3),
        ],
      ),
    );
  }

  Widget _tagline(String text, double p) {
    return Opacity(
      opacity: p.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, 8 * (1 - p)),
        child: Text(text,
          style: TextStyle(color: Colors.white70, fontSize: 14,
            fontFamily: 'Cairo')),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Custom Painters
// ═══════════════════════════════════════════════════════════

class _SupermanSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppTheme.red..style = PaintingStyle.fill;
    final cx = size.width / 2;

    canvas.drawCircle(Offset(cx, 50), 22, paint);

    final path = Path()
      ..moveTo(cx, 80)
      ..lineTo(cx + 55, 130)
      ..lineTo(cx + 40, 240)
      ..lineTo(cx - 40, 240)
      ..lineTo(cx - 55, 130)
      ..close();
    canvas.drawPath(path, paint);

    final capePaint = Paint()
      ..color = AppTheme.red.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final capeLeft = Path()
      ..moveTo(cx - 40, 110)
      ..lineTo(cx - 90, 180)
      ..lineTo(cx - 75, 260)
      ..lineTo(cx - 40, 240)
      ..close();
    canvas.drawPath(capeLeft, capePaint);

    final capeRight = Path()
      ..moveTo(cx + 40, 110)
      ..lineTo(cx + 90, 180)
      ..lineTo(cx + 75, 260)
      ..lineTo(cx + 40, 240)
      ..close();
    canvas.drawPath(capeRight, capePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpeedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.red.withOpacity(0.7)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final angles = [0.0, 0.785, 1.571, 2.356, 3.14159, 3.927, 4.712, 5.498];

    for (int i = 0; i < angles.length; i++) {
      final a = angles[i];
      const startR = 110.0;
      final endR = 130.0 + (i % 3) * 10;
      final x1 = cx + startR * _c(a);
      final y1 = cy + startR * _s(a);
      final x2 = cx + endR * _c(a);
      final y2 = cy + endR * _s(a);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  double _c(double a) => math.cos(a);
  double _s(double a) => math.sin(a);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
