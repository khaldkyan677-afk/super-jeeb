import 'admin/admin_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'client/client_app.dart';

class WelcomeAfterLogin extends StatefulWidget {
  const WelcomeAfterLogin({super.key});
  @override
  State<WelcomeAfterLogin> createState() => _WelcomeAfterLoginState();
}

class _WelcomeAfterLoginState extends State<WelcomeAfterLogin> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _welcomeFade, _supermanFade, _logoScale, _logoOpacity,
      _pulse, _nameFade, _t1Fade, _t2Fade, _t3Fade, _speedLines;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 8000));
    _welcomeFade = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 15),
      TweenSequenceItem(tween: ConstantTween(1), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 15),
      TweenSequenceItem(tween: ConstantTween(0), weight: 50),
    ]).animate(_ctrl);
    _supermanFade = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0, end: 0.25), weight: 10),
      TweenSequenceItem(tween: ConstantTween(0.25), weight: 70),
    ]).animate(_ctrl);
    _speedLines = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(0), weight: 40),
    ]).animate(_ctrl);
    _logoOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 15),
      TweenSequenceItem(tween: ConstantTween(1), weight: 60),
    ]).animate(_ctrl);
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.5), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.05), weight: 12),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1), weight: 5),
      TweenSequenceItem(tween: ConstantTween(1), weight: 58),
    ]).animate(_ctrl);
    _pulse = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 4),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 6),
      TweenSequenceItem(tween: ConstantTween(0), weight: 50),
    ]).animate(_ctrl);
    _nameFade = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 12),
      TweenSequenceItem(tween: ConstantTween(1), weight: 38),
    ]).animate(_ctrl);
    _t1Fade = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1), weight: 30),
    ]).animate(_ctrl);
    _t2Fade = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1), weight: 20),
    ]).animate(_ctrl);
    _t3Fade = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: 80),
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1), weight: 10),
    ]).animate(_ctrl);
    _ctrl.forward();
    Timer(const Duration(milliseconds: 8300), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) { final e = FirebaseAuth.instance.currentUser?.email ?? ''; return e == 'khaled20010405@gmail.com' ? const AdminApp() : const ClientMainNav(); }),
        );
      }
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFEF233C);
    const dark = Color(0xFF0D0D12);
    return Scaffold(
      backgroundColor: dark,
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Stack(
            children: [
              // Superman faint background
              Center(child: Opacity(opacity: _supermanFade.value,
                child: Icon(Icons.shield, size: 320, color: Colors.white.withOpacity(0.08)))),
              // Speed lines
              Center(child: Opacity(opacity: _speedLines.value,
                child: SizedBox(width: 260, height: 260,
                  child: CustomPaint(painter: _SpeedLinesPainter(color: red))))),
              // Pulse
              Center(child: Opacity(opacity: _pulse.value,
                child: Container(width: 220, height: 220,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: red.withOpacity(0.6), blurRadius: 60, spreadRadius: 20)])))),
              // Welcome text
              Center(child: Opacity(opacity: _welcomeFade.value,
                child: const Text('أهلاً وسهلاً', style: TextStyle(color: Colors.white,
                  fontSize: 42, fontWeight: FontWeight.bold, fontFamily: 'Cairo')))),
              // Logo + Name + Phrases
              Align(
                alignment: Alignment.center,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Opacity(opacity: _logoOpacity.value,
                    child: Transform.scale(scale: _logoScale.value,
                      child: Container(width: 160, height: 160,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(36),
                          boxShadow: [BoxShadow(color: red.withOpacity(0.4), blurRadius: 30, spreadRadius: 4)]),
                        child: const Center(child: Text('S J', style: TextStyle(color: dark,
                          fontSize: 64, fontWeight: FontWeight.bold, fontFamily: 'Cairo')))))),
                  const SizedBox(height: 20),
                  Opacity(opacity: _nameFade.value,
                    child: const Text('Super_Jeep', style: TextStyle(color: Colors.white,
                      fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontFamily: 'Cairo'))),
                  const SizedBox(height: 28),
                  Opacity(opacity: _t1Fade.value,
                    child: const Text('قدّم كـ تاجر', style: TextStyle(color: red,
                      fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Cairo'))),
                  const SizedBox(height: 10),
                  Opacity(opacity: _t2Fade.value,
                    child: const Text('قدّم كـ مندوب', style: TextStyle(color: red,
                      fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Cairo'))),
                  const SizedBox(height: 10),
                  Opacity(opacity: _t3Fade.value,
                    child: const Text('معًا نكافح', style: TextStyle(color: Colors.white70,
                      fontSize: 18, fontFamily: 'Cairo'))),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SpeedLinesPainter extends CustomPainter {
  final Color color;
  _SpeedLinesPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.7)..strokeWidth = 1.2..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 24; i++) {
      final angle = (i / 24) * 6.28318;
      final p1 = Offset(center.dx + 80 * (i % 2 == 0 ? 1 : -1) * 0.9, center.dy + 80 * (i % 3 == 0 ? 1 : -1) * 0.7);
      final p2 = Offset(center.dx + 130 * (i % 2 == 0 ? -1 : 1), center.dy + 130 * (i % 3 == 0 ? -1 : 1));
      canvas.drawLine(Offset(p1.dx * 0.9 + center.dx * 0.1, p1.dy), Offset(p2.dx * 0.9 + center.dx * 0.1, p2.dy), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
