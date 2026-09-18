import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedSJLogo extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;
  final VoidCallback? onAnimationComplete;

  const AnimatedSJLogo({
    super.key,
    this.size = 160,
    this.onTap,
    this.onAnimationComplete,
  });

  @override
  State<AnimatedSJLogo> createState() => _AnimatedSJLogoState();
}

class _AnimatedSJLogoState extends State<AnimatedSJLogo>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  // Logo appears
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  // Vehicles split
  late Animation<double> _bikeX;
  late Animation<double> _carX;

  // Shops appear
  late Animation<double> _shopOpacity;

  // Explosion
  late Animation<double> _explosionScale;
  late Animation<double> _explosionOpacity;

  // Final logo
  late Animation<double> _finalGlow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // ============ 1. Logo Appears (0.00 - 0.20) ============
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.20, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.15, curve: Curves.easeIn),
      ),
    );

    // ============ 2. Vehicles Split (0.20 - 0.50) ============
    _bikeX = Tween<double>(begin: 0.0, end: -1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.50, curve: Curves.easeOutCubic),
      ),
    );

    _carX = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.50, curve: Curves.easeOutCubic),
      ),
    );

    // ============ 3. Shops Appear (0.35 - 0.50) ============
    _shopOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.50, curve: Curves.easeIn),
      ),
    );

    // ============ 4. Explosion (0.70 - 0.82) ============
    _explosionScale = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 0.82, curve: Curves.easeOut),
      ),
    );

    _explosionOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 0.78, curve: Curves.easeOut),
      ),
    );

    // ============ 5. Final Logo Glow (0.82 - 1.0) ============
    _finalGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.82, 1.0, curve: Curves.easeIn),
      ),
    );

    // تشغيل الحركة
    _controller.forward().then((_) {
      widget.onAnimationComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: size * 2.5,
        height: size * 1.6,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // ======== المتاجر (يسار + يمين) ========
                Positioned(
                  left: size * 0.1,
                  child: Opacity(
                    opacity: _shopOpacity.value.clamp(0.0, 1.0),
                    child: _buildShop(Icons.storefront),
                  ),
                ),
                Positioned(
                  right: size * 0.1,
                  child: Opacity(
                    opacity: _shopOpacity.value.clamp(0.0, 1.0),
                    child: _buildShop(Icons.local_grocery_store),
                  ),
                ),

                // ======== الانفجار ========
                if (_controller.value > 0.68 && _controller.value < 0.85)
                  Opacity(
                    opacity: (1.0 - (_controller.value - 0.70) * 5).clamp(
                      0.0,
                      1.0,
                    ),
                    child: Transform.scale(
                      scale: _explosionScale.value,
                      child: _buildExplosion(size),
                    ),
                  ),

                // ======== الشعار الأولي (يظهر ثم يختفي) ========
                if (_controller.value < 0.30)
                  Opacity(
                    opacity: _logoOpacity.value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: _logoScale.value.clamp(0.0, 1.0),
                      child: _buildLogo(size * 0.9),
                    ),
                  ),

                // ======== الموتور (يخرج من الشعار → يسار → يعود) ========
                Transform.translate(
                  offset: Offset(_bikeX.value * size * 1.0, 0),
                  child: _buildVehicle(
                    Icons.delivery_dining,
                    const Color(0xFFEF233C),
                    size * 0.9,
                  ),
                ),

                // ======== السيارة (تخرج من الشعار → يمين → تعود) ========
                Transform.translate(
                  offset: Offset(_carX.value * size * 1.0, 0),
                  child: _buildVehicle(
                    Icons.directions_car,
                    const Color(0xFF25D366),
                    size * 0.9,
                  ),
                ),

                // ======== الشعار النهائي (يظهر بتوهج) ========
                if (_controller.value > 0.82)
                  Opacity(
                    opacity: _finalGlow.value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: 0.8 + _finalGlow.value * 0.3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // توهج ذهبي خارجي
                          Container(
                            width: size * 1.1,
                            height: size * 1.1,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFFD700,
                                  ).withValues(alpha: 0.6 * _finalGlow.value),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          // الشعار
                          _buildLogo(size * 0.9),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ==================== مكونات مساعدة ====================

  Widget _buildLogo(double s) {
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF0F0F0)],
        ),
        borderRadius: BorderRadius.circular(s * 0.25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: s * 0.15,
            offset: Offset(0, s * 0.05),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: s * 0.7,
          height: s * 0.7,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                bottom: 0,
                child: Text(
                  'S',
                  style: TextStyle(
                    fontSize: s * 0.55,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2B2D42),
                    height: 1,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Text(
                  'J',
                  style: TextStyle(
                    fontSize: s * 0.4,
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

  Widget _buildVehicle(IconData icon, Color color, double s) {
    return Container(
      width: s * 0.55,
      height: s * 0.55,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: s * 0.32),
    );
  }

  Widget _buildShop(IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD700).withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFFD700), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                blurRadius: 12,
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFFFFD700), size: 28),
        ),
        const SizedBox(height: 6),
        Container(
          width: 4,
          height: 20,
          color: const Color(0xFFFFD700).withValues(alpha: 0.5),
        ),
      ],
    );
  }

  Widget _buildExplosion(double s) {
    final particles = <Widget>[];
    const count = 12;
    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * math.pi) / count;
      final dx = math.cos(angle) * s * 0.7;
      final dy = math.sin(angle) * s * 0.7;
      particles.add(
        Transform.translate(
          offset: Offset(dx, dy),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: i.isEven
                  ? const Color(0xFFFFD700)
                  : const Color(0xFFEF233C),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      (i.isEven
                              ? const Color(0xFFFFD700)
                              : const Color(0xFFEF233C))
                          .withValues(alpha: 0.8),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        ...particles,
        Container(
          width: s * 0.6,
          height: s * 0.6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.9),
                const Color(0xFFFFD700).withValues(alpha: 0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
