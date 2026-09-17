import 'package:flutter/material.dart';
import 'screens/client/client_app.dart';
import 'screens/merchant/merchant_app.dart';
import 'screens/driver/driver_app.dart';
import 'screens/admin/admin_app.dart';
import 'widgets/sj_logo.dart';
import 'services/security_service.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';

void main() {
  // تهيئة بصمة الجهاز
  final deviceId = SecurityService.instance.generateDeviceId();
  SecurityService.instance.generateFingerprint(
    platform: 'web',
    model: 'browser',
    appVersion: '1.0.0',
  );
  ApiService.setDeviceId(deviceId);

  runApp(const SuperJeebApp());
}

class SuperJeebApp extends StatelessWidget {
  const SuperJeebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Jeeb',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1B1C2A),
        primaryColor: const Color(0xFF2B2D42),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2B2D42),
          secondary: const Color(0xFFEF233C),
        ),
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

// ============================================================
// 1. شاشة الترحيب والتسجيل الموحد
// ============================================================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _openAdmin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminGateScreen()),
    );
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    final auth = AuthService.instance;
    final success = await auth.signInWithGoogle();
    
    if (!context.mounted) return;
    
    if (success) {
      // التوجيه حسب الدور
      final role = auth.userRole;
      if (role == 'merchant') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const MerchantApp()));
      } else if (role == 'courier') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const DriverApp()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const ClientApp()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(auth.error ?? 'فشل تسجيل الدخول'),
            backgroundColor: const Color(0xFFEF233C)),
      );
    }
  }

  void _login(BuildContext context, String method) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(method: method),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // شعار SJ - ضغطة طويلة تفتح بوابة الأدمن
                GestureDetector(
                  onLongPress: () => _openAdmin(context),
                  child: const SJLogo(size: 130),
                ),
                const SizedBox(height: 25),
                const Text('Super Jeeb',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 10),
                const Text('يجيبها لحد عندك',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFEF233C),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 50),
                const Text('سجل دخولك للمتابعة',
                    style: TextStyle(color: Colors.white54, fontSize: 13)),
                const SizedBox(height: 25),

                // زر Google
                _buildSocialButton(
                  context,
                  icon: Icons.g_mobiledata,
                  label: 'المتابعة بحساب Google',
                  color: Colors.white,
                  textColor: const Color(0xFF2B2D42),
                  onTap: () => _loginWithGoogle(context),
                ),
                const SizedBox(height: 15),

                // زر الهاتف
                _buildSocialButton(
                  context,
                  icon: Icons.phone_iphone,
                  label: 'المتابعة برقم الهاتف',
                  color: const Color(0xFFEF233C),
                  textColor: Colors.white,
                  onTap: () => _login(context, 'phone'),
                ),

                const SizedBox(height: 40),
                const Text(
                  'بالمتابعة، أنت توافق على الشروط والأحكام',
                  style: TextStyle(color: Colors.white38, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 30),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 2. شاشة تسجيل الدخول
// ============================================================
class LoginScreen extends StatefulWidget {
  final String method;
  const LoginScreen({super.key, required this.method});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  String _error = '';

  void _sendOtp() {
    if (_phoneController.text.length < 9) {
      setState(() => _error = 'رقم الهاتف غير صحيح');
      return;
    }
    setState(() {
      _otpSent = true;
      _error = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('📱 تم إرسال رمز التحقق'),
          backgroundColor: Color(0xFF25D366)),
    );
  }

  void _verifyOtp() {
    if (_otpController.text.length < 4) {
      setState(() => _error = 'الرمز غير صحيح');
      return;
    }
    // بعد التحقق - يوجه للعميل كافتراضي
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ClientApp()),
    );
  }

  void _loginWithGoogle() {
    // محاكاة تسجيل Google
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ClientApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Icon(
                widget.method == 'google' ? Icons.g_mobiledata : Icons.phone_iphone,
                color: const Color(0xFFEF233C),
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                widget.method == 'google'
                    ? 'المتابعة بحساب Google'
                    : 'المتابعة برقم الهاتف',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.method == 'google'
                    ? 'سيتم فتح نافذة تسجيل Google'
                    : 'سنرسل لك رمز تحقق عبر الرسائل',
                style: const TextStyle(color: Colors.white54, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              if (widget.method == 'phone') ...[
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: !_otpSent,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '7XX XXX XXX',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.phone,
                        color: Color(0xFFEF233C)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFEF233C)),
                    ),
                  ),
                ),
                if (_otpSent) ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '----',
                      hintStyle: const TextStyle(
                          color: Colors.white38, letterSpacing: 10),
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFFEF233C)),
                      ),
                    ),
                  ),
                ],
              ],

              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(_error,
                      style: const TextStyle(
                          color: Color(0xFFEF233C), fontSize: 13)),
                ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF233C),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: widget.method == 'google'
                    ? _loginWithGoogle
                    : (_otpSent ? _verifyOtp : _sendOtp),
                child: Text(
                  widget.method == 'google'
                      ? 'متابعة'
                      : (_otpSent ? 'تحقق ودخول' : 'إرسال الرمز'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 3. بوابة الأدمن السرية
// ============================================================
class AdminGateScreen extends StatefulWidget {
  const AdminGateScreen({super.key});

  @override
  State<AdminGateScreen> createState() => _AdminGateScreenState();
}

class _AdminGateScreenState extends State<AdminGateScreen> {
  final _email1 = TextEditingController();
  final _email2 = TextEditingController();
  final _pass = TextEditingController();
  String _error = '';

  // البريدان المخصصان للأدمن
  static const String _adminEmail1 = 'khaled20010405@gmail.com';
  static const String _adminEmail2 = 'khaldkyan677@gmail.com';
  static const String _secretPassword = 'SJ2026KHALED';

  void _verify() {
    final e1 = _email1.text.trim().toLowerCase();
    final e2 = _email2.text.trim().toLowerCase();
    final p = _pass.text;

    if (e1 == _adminEmail1 &&
        e2 == _adminEmail2 &&
        p == _secretPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminApp()),
      );
    } else if (e1 == _adminEmail2 &&
        e2 == _adminEmail1 &&
        p == _secretPassword) {
      // يقبل الترتيب المعكوس
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminApp()),
      );
    } else {
      setState(() => _error = 'البيانات غير صحيحة');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B0013),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF233C).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield,
                    color: Color(0xFFEF233C), size: 50),
              ),
              const SizedBox(height: 25),
              const Text('بوابة الإدارة السيادية',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('تحقق مزدوج مطلوب',
                  style: TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 40),

              _buildField(_email1, Icons.email_outlined,
                  'البريد السيادي الأول'),
              const SizedBox(height: 15),
              _buildField(_email2, Icons.email_outlined,
                  'البريد السيادي الثاني'),
              const SizedBox(height: 15),
              _buildField(_pass, Icons.lock_outline,
                  'كلمة السر المشفرة', obscure: true),

              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(_error,
                      style: const TextStyle(
                          color: Color(0xFFEF233C), fontSize: 13)),
                ),

              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF233C),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: _verify,
                child: const Text('بث الرادار وتفعيل السيرفر',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('رجوع',
                    style: TextStyle(color: Colors.white60, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController c, IconData icon, String label,
      {bool obscure = false}) {
    return TextFormField(
      controller: c,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white60, size: 20),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white38, fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFEF233C)),
        ),
      ),
    );
  }
}
