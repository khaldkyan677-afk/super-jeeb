import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/camera_service.dart';
import 'merchant_products.dart';
import 'merchant_account.dart';
import '../../widgets/sj_logo.dart';

class MerchantApp extends StatelessWidget {
  const MerchantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Jeeb Merchant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1B1C2A),
        primaryColor: const Color(0xFF2B2D42),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2B2D42),
          secondary: const Color(0xFFEF233C),
        ),
        useMaterial3: true,
      ),
      home: const MerchantSplash(),
    );
  }
}

class MerchantSplash extends StatefulWidget {
  const MerchantSplash({super.key});
  @override
  State<MerchantSplash> createState() => _MerchantSplashState();
}

class _MerchantSplashState extends State<MerchantSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _store;
  late Animation<double> _money;
  late Animation<double> _fade;
  bool _merged = false;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _store = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0, 0.6, curve: Curves.bounceOut),
      ),
    );
    _money = Tween<double>(begin: -150, end: 0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.7, 1, curve: Curves.easeIn),
      ),
    );
    _c.forward();
    _c.addListener(() {
      if (_c.value >= 0.7 && !_merged) setState(() => _merged = true);
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MerchantLogin()),
        );
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2D42),
      body: Stack(
        children: [
          if (!_merged) ...[
            Positioned(
              left: MediaQuery.of(context).size.width * 0.25,
              top: MediaQuery.of(context).size.height * 0.35 + _store.value,
              child: const Icon(
                Icons.desktop_mac,
                color: Colors.white,
                size: 100,
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.23,
              top: MediaQuery.of(context).size.height * 0.31 + _store.value,
              child: const Icon(
                Icons.store,
                color: Color(0xFFEF233C),
                size: 110,
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.1 + _money.value,
              top: MediaQuery.of(context).size.height * 0.42,
              child: const Icon(
                Icons.monetization_on,
                color: Color(0xFFFFD700),
                size: 55,
              ),
            ),
          ],
          if (_merged)
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SJLogo(size: 130),
                    const SizedBox(height: 25),
                    const Text(
                      'سوبر جيب | بوابة التجار',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'شركاء النجاح.. مبيعاتك أسرع!',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFEF233C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MerchantLogin extends StatefulWidget {
  const MerchantLogin({super.key});
  @override
  State<MerchantLogin> createState() => _MerchantLoginState();
}

class _MerchantLoginState extends State<MerchantLogin> {
  final _phone = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'S',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B2D42),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Text(
                        'J',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF233C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Super Jeeb Merchant',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 35),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone_iphone, color: Color(0xFFEF233C)),
                labelText: 'رقم الهاتف',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEF233C)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _pass,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFEF233C)),
                labelText: 'كلمة المرور',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEF233C)),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF233C),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MerchantDashboard()),
              ),
              child: const Text(
                'تسجيل الدخول وبث الرادار',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {},
              icon: const Icon(
                Icons.g_mobiledata,
                color: Colors.white,
                size: 30,
              ),
              label: const Text("متجر",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MerchantRegister()),
              ),
              child: const Text(
                '👋 انضم كشريك وسجّل متجرك',
                style: TextStyle(
                  color: Color(0xFFEF233C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MerchantRegister extends StatefulWidget {
  const MerchantRegister({super.key});
  @override
  State<MerchantRegister> createState() => _MerchantRegisterState();
}

class _MerchantRegisterState extends State<MerchantRegister> {
  String _type = 'مطاعم والكافيهات';
  String? _d1;
  String? _d2;
  String? _d3;
  String? _d4;

  final _cats = [
    'مطاعم والكافيهات',
    'صيدليات وأدوية',
    'سوبرماركت وتموينات',
    'مخابز ومعجنات',
    'بقالات وخضرة',
    'مكسرات وبهارات',
    'ملابس وأزياء',
    'عطورات وروائح',
    'مستحضرات تجميل',
    'إلكترونيات',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'تسجيل متجر جديد',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'البيانات الأساسية',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'الاسم التجاري للمحل',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _type,
              dropdownColor: const Color(0xFF2B2D42),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'تصنيف المتجر',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
              items: _cats
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (n) => setState(() => _type = n!),
            ),
            const SizedBox(height: 30),
            const Text(
              '📸 الوثائق',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                ImageUploadBox(
                  label: 'السجل التجاري',
                  activeColor: const Color(0xFF25D366),
                  onUploaded: (u) => setState(() => _d1 = u),
                ),
                ImageUploadBox(
                  label: 'رخصة البلدية',
                  activeColor: const Color(0xFF25D366),
                  onUploaded: (u) => setState(() => _d2 = u),
                ),
                ImageUploadBox(
                  label: 'صورة اللوحة',
                  activeColor: const Color(0xFF25D366),
                  onUploaded: (u) => setState(() => _d3 = u),
                ),
                ImageUploadBox(
                  label: 'هوية المالك',
                  activeColor: const Color(0xFF25D366),
                  onUploaded: (u) => setState(() => _d4 = u),
                ),
              ],
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF233C),
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✔️ تم إرسال طلبك للمراجعة')),
                );
                Navigator.pop(context);
              },
              child: const Text(
                'إرسال طلب الانضمام',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MerchantDashboard extends StatefulWidget {
  const MerchantDashboard({super.key});
  @override
  State<MerchantDashboard> createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _spin;
  bool _open = false;
  final int _active = 3;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return 'صباح الخير.. الرزق يطلبك! ☕';
    return 'مساء الخير.. مبيعاتك أسرع! ✨';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'لوحة التاجر',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        actions: [
          Row(
            children: [
              Text(
                _open ? 'مفتوح' : 'مغلق',
                style: TextStyle(
                  color: _open ? const Color(0xFF25D366) : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: _open,
                activeThumbColor: const Color(0xFF25D366),
                onChanged: (v) {
                  setState(() => _open = v);
                  if (v) {
                    _spin.repeat();
                  } else {
                    _spin.stop();
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                _greeting(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.9,
              children: [
                InkWell(
                  onTap: () {
                    if (!_open) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('⚠️ افتح المتجر أولاً')),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MerchantWorkflow(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2D42),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RotationTransition(
                          turns: _spin,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _open
                                    ? const Color(0xFFEF233C)
                                    : Colors.white12,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.shopping_cart_checkout,
                              color: _open
                                  ? const Color(0xFFEF233C)
                                  : Colors.grey,
                              size: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '$_active طلبات',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'تابع للمندوب',
                          style: TextStyle(color: Colors.white38, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                _sCard(
                  Icons.stacked_line_chart,
                  '+24%',
                  'نمو المبيعات',
                  const Color(0xFF25D366),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MerchantProducts()),
                  ),
                  child: _sCard(
                    Icons.inventory,
                    'المستودع',
                    'إدارة المنتجات',
                    Colors.orange,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MerchantWallet()),
                  ),
                  child: _sCard(
                    Icons.account_balance_wallet,
                    'المحفظة',
                    'تصفية الحسابات',
                    Colors.amber,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MerchantAds()),
                  ),
                  child: _sCard(
                    Icons.campaign,
                    'إعلاناتي',
                    'قدّم على إعلان',
                    const Color(0xFFEF233C),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MerchantSubscriptions(),
                    ),
                  ),
                  child: _sCard(
                    Icons.workspace_premium,
                    'اشتراكي',
                    'طور متجرك',
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sCard(IconData icon, String title, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D42),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class MerchantWorkflow extends StatefulWidget {
  const MerchantWorkflow({super.key});
  @override
  State<MerchantWorkflow> createState() => _MerchantWorkflowState();
}

class _MerchantWorkflowState extends State<MerchantWorkflow> {
  int _step = 1;
  final bool _paid = true;
  bool _available = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'غرفة الميدان',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2D42),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'طلب #5021',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Icon(Icons.local_shipping, color: Color(0xFFEF233C)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _node(1, Icons.storefront, 'المتجر'),
                      _line(1),
                      _node(2, Icons.delivery_dining, 'الكابتن'),
                      _line(2),
                      _node(3, Icons.add_road, 'الطريق'),
                      _line(3),
                      _node(4, Icons.home, 'المنزل'),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _paid
                          ? const Color(0xFF25D366).withValues(alpha: 0.08)
                          : const Color(0xFFEF233C).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _paid
                            ? const Color(0xFF25D366)
                            : const Color(0xFFEF233C),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _paid ? '🟢 [ مدفوع إلكترونياً ]' : '🔴 [ الدفع كاش ]',
                        style: TextStyle(
                          color: _paid
                              ? const Color(0xFF25D366)
                              : const Color(0xFFEF233C),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF233C),
                          ),
                          onPressed: () {
                            if (_step < 4) setState(() => _step++);
                          },
                          child: Text(
                            'الخطوة ($_step/4)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white30),
                        ),
                        onPressed: () => _showRejectDialog(),
                        child: const Text(
                          'رفض',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '🛍️ مستودع المنتجات',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.01),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.checkroom,
                      color: Colors.white60,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'فستان تركي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '18,000 YER',
                          style: TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _available,
                    activeThumbColor: const Color(0xFF25D366),
                    onChanged: (v) => setState(() => _available = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _node(int i, IconData icon, String label) {
    final passed = _step >= i;
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: passed
              ? const Color(0xFFEF233C)
              : const Color(0xFF1B1C2A),
          child: Icon(
            icon,
            color: passed ? Colors.white : Colors.white24,
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: passed ? Colors.white : Colors.white24,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _line(int i) {
    final passed = _step > i;
    return Expanded(
      child: Container(
        height: 3,
        color: passed ? const Color(0xFFEF233C) : Colors.black54,
      ),
    );
  }

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'سبب الرفض',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _reason('نفذت الكمية'),
            _reason('الفرع مغلق'),
            _reason('لا يمكن التوصيل للمنطقة'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white60)),
          ),
        ],
      ),
    );
  }

  Widget _reason(String t) {
    return ListTile(
      title: Text(t, style: const TextStyle(color: Colors.white, fontSize: 13)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white30,
        size: 14,
      ),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('تم رفض الطلب: $t')));
      },
    );
  }
}

class MerchantProducts extends StatelessWidget {
  const MerchantProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return const MerchantProductsScreen();
  }
}

class MerchantAds extends StatefulWidget {
  const MerchantAds({super.key});
  @override
  State<MerchantAds> createState() => _MerchantAdsState();
}

class _MerchantAdsState extends State<MerchantAds> {
  String _position = 'أعلى الصفحة';
  int _days = 7;
  String? _image;

  final _positions = ['أعلى الصفحة', 'وسط الصفحة', 'أسفل الصفحة', 'صفحة القسم'];
  final _prices = {1: 5000, 3: 12000, 7: 25000, 30: 90000};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'الإعلانات',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFEF233C).withValues(alpha: 0.2),
                    const Color(0xFF2B2D42),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(Icons.campaign, color: Color(0xFFEF233C), size: 30),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'اعرض متجرك في مقدمة التطبيق\nوزد مبيعاتك',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              '📸 صورة الإعلان',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ImageUploadBox(
                label: 'ارفع صورة الإعلان',
                icon: Icons.image,
                activeColor: const Color(0xFFEF233C),
                onUploaded: (u) => setState(() => _image = u),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '📍 موقع الإعلان',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _position,
              dropdownColor: const Color(0xFF2B2D42),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.02),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEF233C)),
                ),
              ),
              items: _positions
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _position = v!),
            ),
            const SizedBox(height: 20),
            const Text(
              '⏱️ المدة',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: _prices.keys.map((d) {
                final sel = _days == d;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: InkWell(
                    onTap: () => setState(() => _days = d),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: sel
                            ? const Color(0xFFEF233C)
                            : Colors.white.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel ? const Color(0xFFEF233C) : Colors.white24,
                        ),
                      ),
                      child: Text(
                        '$d يوم',
                        style: TextStyle(
                          color: sel ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2D42),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'السعر الإجمالي:',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    '${_prices[_days]} YER',
                    style: const TextStyle(
                      color: Color(0xFF25D366),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF233C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('⚠️ ارفع صورة الإعلان'),
                        backgroundColor: Color(0xFFEF233C),
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ تم إرسال طلب الإعلان للإدارة للمراجعة'),
                      backgroundColor: Color(0xFF25D366),
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'إرسال الطلب للإدارة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MerchantSubscriptions extends StatelessWidget {
  const MerchantSubscriptions({super.key});

  static const plans = [
    {
      'name': 'مجانية',
      'price': '0',
      'commission': '15%',
      'color': Color(0xFF6C757D),
      'features': ['عمولة 15%', 'منتجات غير محدودة', 'دعم أساسي'],
    },
    {
      'name': 'فضية',
      'price': '5,000',
      'commission': '12%',
      'color': Color(0xFF95A5A6),
      'features': ['عمولة 12%', 'إعلان مجاني', 'دعم سريع', 'تقارير مفصلة'],
    },
    {
      'name': 'ذهبية',
      'price': '15,000',
      'commission': '8%',
      'color': Color(0xFFD4AF37),
      'features': [
        'عمولة 8%',
        'إعلانان مجانًا',
        'دعم VIP',
        'ترتيب أول',
        'شهادة موثقة',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'الاشتراكات',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: plans.length,
        itemBuilder: (context, i) => _planCard(context, plans[i]),
      ),
    );
  }

  Widget _planCard(BuildContext context, Map<String, dynamic> p) {
    final color = p['color'] as Color;
    final features = p['features'] as List;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  p['name'],
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${p['price']} YER',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'العمولة: ${p['commission']}',
            style: const TextStyle(
              color: Color(0xFFEF233C),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.white10, height: 20),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: color, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    f,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ تم اختيار خطة ${p['name']}'),
                    backgroundColor: const Color(0xFF25D366),
                  ),
                );
              },
              child: const Text(
                'اختر هذه الخطة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MerchantWallet extends StatelessWidget {
  const MerchantWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return const MerchantAccountScreen();
  }
}
