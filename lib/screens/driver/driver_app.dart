import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'driver_theme.dart';
import 'driver_home.dart';
import 'driver_orders.dart';
import 'driver_map.dart';
import 'driver_earnings.dart';
import 'driver_account.dart';

class DriverApp extends StatelessWidget {
  final bool skipLogin;
  const DriverApp({super.key, this.skipLogin = false});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Jeeb Driver',
      debugShowCheckedModeBanner: false,
      theme: DJ.theme(),
      home: skipLogin ? const DriverShell() : const DriverSplash(),
    );
  }
}

class DriverShell extends StatefulWidget {
  const DriverShell({super.key});
  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _idx = 0;

  final _pages = const [
    DriverHomeScreen(),
    DriverOrdersScreen(),
    DriverMapScreen(),
    DriverEarningsScreen(),
    DriverAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DJ.bg,
      body: IndexedStack(index: _idx, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: DJ.card, boxShadow: DJ.shadow),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _tab(0, Icons.home_rounded, 'الرئيسية'),
                _tab(1, Icons.receipt_long_rounded, 'الطلبات'),
                _tab(2, Icons.map_rounded, 'الخريطة'),
                _tab(3, Icons.account_balance_wallet_rounded, 'الأرباح'),
                _tab(4, Icons.person_rounded, 'الحساب'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(int i, IconData icon, String label) {
    final active = _idx == i;
    return InkWell(
      onTap: () => setState(() => _idx = i),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? DJ.primary : DJ.textMuted, size: 24),
            const SizedBox(height: 3),
            Text(label, style: GoogleFonts.cairo(
              fontSize: 10,
              color: active ? DJ.primary : DJ.textMuted,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            )),
          ],
        ),
      ),
    );
  }
}

class DriverSplash extends StatefulWidget {
  const DriverSplash({super.key});
  @override
  State<DriverSplash> createState() => _DriverSplashState();
}

class _DriverSplashState extends State<DriverSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..forward();
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _c, curve: Curves.easeOutBack),
    );
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const DriverShell()));
    });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DJ.bg,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(
                    color: DJ.primary,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: DJ.shadow,
                  ),
                  child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 56),
                ),
                const SizedBox(height: 20),
                Text('Super Jeeb', style: DJ.h1.copyWith(fontSize: 26)),
                const SizedBox(height: 6),
                Text('تطبيق المندوب', style: DJ.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
