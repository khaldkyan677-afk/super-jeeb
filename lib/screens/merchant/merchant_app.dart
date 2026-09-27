import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import 'merchant_theme.dart';
import 'merchant_home.dart';
import 'merchant_orders.dart';
import 'merchant_products.dart';
import 'merchant_store.dart';
import 'merchant_account.dart';

class MerchantApp extends StatelessWidget {
  final bool skipLogin;
  const MerchantApp({super.key, this.skipLogin = false});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Jeeb Merchant',
      debugShowCheckedModeBanner: false,
      theme: MJ.theme(),
      home: skipLogin ? const MerchantShell() : const MerchantSplash(),
    );
  }
}

// ─────────────────────────────────────────
// Splash
// ─────────────────────────────────────────
class MerchantSplash extends StatefulWidget {
  const MerchantSplash({super.key});
  @override
  State<MerchantSplash> createState() => _MerchantSplashState();
}

class _MerchantSplashState extends State<MerchantSplash>
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
          MaterialPageRoute(builder: (_) => const MerchantLogin()));
    });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MJ.bg,
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
                    color: MJ.primary,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: MJ.shadow,
                  ),
                  child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 56),
                ),
                const SizedBox(height: 20),
                Text('Super Jeeb', style: MJ.h1.copyWith(fontSize: 26)),
                const SizedBox(height: 6),
                Text('تطبيق التاجر', style: MJ.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Login
// ─────────────────────────────────────────
class MerchantLogin extends StatefulWidget {
  const MerchantLogin({super.key});
  @override
  State<MerchantLogin> createState() => _MerchantLoginState();
}

class _MerchantLoginState extends State<MerchantLogin> {
  final _phone = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    if (_phone.text.isEmpty || _pass.text.isEmpty) {
      _showMsg('الرجاء إدخال البريد وكلمة المرور');
      return;
    }
    setState(() => _loading = true);
    final res = await ApiService.login(
      email: _phone.text.trim(),
      password: _pass.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);

    if (res.containsKey('error')) {
      _showMsg('فشل الدخول: ${res['error']}');
      return;
    }

    final token = res['token'] as String?;
    final role = res['role'] as String?;
    final status = res['status'] as String?;

    if (token == null) {
      _showMsg('استجابة غير صحيحة من السيرفر');
      return;
    }

    ApiService.setToken(token);

    if (role != 'merchant' && role != 'admin') {
      _showMsg('هذا الحساب ليس تاجراً. تواصل مع الإدارة.');
      return;
    }

    if (status != 'approved' && role != 'admin') {
      _showMsg('حسابك قيد المراجعة من الإدارة.');
      return;
    }

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const MerchantShell()));
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: GoogleFonts.cairo()), backgroundColor: MJ.danger),
    );
  }

  @override
  void dispose() { _phone.dispose(); _pass.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MJ.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: MJ.primary, borderRadius: BorderRadius.circular(24)),
                child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              Text('مرحباً بك في\nتطبيق التاجر', style: MJ.h1.copyWith(fontSize: 26)),
              const SizedBox(height: 8),
              Text('متجرك يتحرك معك', style: MJ.muted),
              const SizedBox(height: 32),
              _field(_phone, 'البريد الإلكتروني', Icons.email_rounded),
              const SizedBox(height: 14),
              _field(_pass, 'كلمة المرور', Icons.lock_outline_rounded, obscure: true),
              const SizedBox(height: 24),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MJ.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('تسجيل الدخول', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: Text('ليس لديك حساب؟ سجّل متجرك', style: GoogleFonts.cairo(color: MJ.primary, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, IconData icon, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(color: MJ.card, borderRadius: BorderRadius.circular(16), boxShadow: MJ.shadowSoft),
      child: TextField(
        controller: c,
        obscureText: obscure,
        style: GoogleFonts.cairo(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.cairo(color: MJ.textMuted),
          prefixIcon: Icon(icon, color: MJ.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Shell (5 Tabs)
// ─────────────────────────────────────────
class MerchantShell extends StatefulWidget {
  const MerchantShell({super.key});
  @override
  State<MerchantShell> createState() => _MerchantShellState();
}

class _MerchantShellState extends State<MerchantShell> {
  int _idx = 0;

  final _pages = const [
    MerchantHomeScreen(),
    MerchantOrdersScreen(),
    MerchantProductsScreen(),
    MerchantStoreScreen(),
    MerchantAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MJ.bg,
      body: IndexedStack(index: _idx, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: MJ.card, boxShadow: MJ.shadow),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _tab(0, Icons.home_rounded, 'الرئيسية'),
                _tab(1, Icons.receipt_long_rounded, 'الطلبات'),
                _tab(2, Icons.inventory_2_rounded, 'المنتجات'),
                _tab(3, Icons.storefront_rounded, 'المتجر'),
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
            Icon(icon, color: active ? MJ.primary : MJ.textMuted, size: 24),
            const SizedBox(height: 3),
            Text(label, style: GoogleFonts.cairo(
              fontSize: 10,
              color: active ? MJ.primary : MJ.textMuted,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            )),
          ],
        ),
      ),
    );
  }
}
