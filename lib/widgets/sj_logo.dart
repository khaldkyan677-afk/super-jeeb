import 'package:flutter/material.dart';

/// شعار Super Jeeb الموحد
class SJLogo extends StatelessWidget {
  final double size;
  final bool withShadow;

  const SJLogo({
    super.key,
    this.size = 120,
    this.withShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF0F0F0),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: size * 0.15,
                  offset: Offset(0, size * 0.05),
                ),
                BoxShadow(
                  color: const Color(0xFFEF233C).withValues(alpha: 0.15),
                  blurRadius: size * 0.25,
                  spreadRadius: size * 0.02,
                ),
              ]
            : null,
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.7,
          height: size * 0.7,
          child: Stack(
            children: [
              // S كبيرة
              Positioned(
                left: 0,
                bottom: 0,
                child: Text(
                  'S',
                  style: TextStyle(
                    fontSize: size * 0.55,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2B2D42),
                    height: 1,
                    letterSpacing: -size * 0.04,
                  ),
                ),
              ),
              // J صغيرة
              Positioned(
                right: 0,
                top: 0,
                child: Text(
                  'J',
                  style: TextStyle(
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFEF233C),
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// أيقونة دائرية للمتاجر
class StoreAvatar extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const StoreAvatar({
    super.key,
    this.icon = Icons.storefront,
    this.color = const Color(0xFF2B2D42),
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: size * 0.5,
          color: color,
        ),
      ),
    );
  }
}

/// خلفية متدرجة فخمة
class PremiumGradient extends StatelessWidget {
  final Widget child;
  final List<Color> colors;

  const PremiumGradient({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFF2B2D42),
      Color(0xFF1B1C2A),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
