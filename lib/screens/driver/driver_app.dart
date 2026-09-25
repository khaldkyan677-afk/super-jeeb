import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/camera_service.dart';
import 'driver_account.dart';
import '../../widgets/sj_logo.dart';

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Jeeb Driver',
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
      home: const DriverSplash(),
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
  late Animation<double> _moto;
  late Animation<double> _car;
  late Animation<double> _fade;
  bool _merged = false;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _moto = Tween<double>(begin: -150, end: 0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    _car = Tween<double>(begin: 400, end: 0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.6, 1, curve: Curves.easeIn),
      ),
    );
    _c.forward();
    _c.addListener(() {
      if (_c.value >= 0.6 && !_merged) setState(() => _merged = true);
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DriverLogin()),
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
    final sw = MediaQuery.of(context).size.width;
    final center = (sw / 2) - 45;
    return Scaffold(
      backgroundColor: const Color(0xFF2B2D42),
      body: Stack(
        children: [
          if (!_merged) ...[
            Positioned(
              left: _moto.value == -150 ? -150 : (center + _moto.value),
              top: MediaQuery.of(context).size.height * 0.45,
              child: const Icon(
                Icons.delivery_dining,
                color: Color(0xFFEF233C),
                size: 60,
              ),
            ),
            Positioned(
              left: _car.value,
              top: MediaQuery.of(context).size.height * 0.45,
              child: const Icon(
                Icons.directions_car,
                color: Colors.white,
                size: 60,
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
                      'سوبر جيب | رادار الكباتن',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'تحرّك.. الرزق يطلبك!',
                      style: TextStyle(
                        fontSize: 16,
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

class DriverLogin extends StatefulWidget {
  const DriverLogin({super.key});
  @override
  State<DriverLogin> createState() => _DriverLoginState();
}

class _DriverLoginState extends State<DriverLogin> {
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
              'Super Jeeb Driver',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white10),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_road, color: Color(0xFFEF233C), size: 36),
                  SizedBox(height: 8),
                  Text(
                    '🚗 🛵 رادار الملاحة نشط',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
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
                labelText: 'كلمة المرور',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
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
                MaterialPageRoute(builder: (_) => const DriverRadarDashboard()),
              ),
              child: const Text(
                'تسجيل الدخول للرادار',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DriverOnboarding()),
              ),
              child: const Text(
                '👋 انضم ككابتن جديد',
                style: TextStyle(color: Color(0xFFEF233C), fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverOnboarding extends StatefulWidget {
  const DriverOnboarding({super.key});
  @override
  State<DriverOnboarding> createState() => _DriverOnboardingState();
}

class _DriverOnboardingState extends State<DriverOnboarding> {
  String _vehicle = 'دراجة نارية';
  String? _d1;
  String? _d2;
  String? _d3;
  String? _d4;
  final _vehicles = ['دراجة نارية', 'سيارة', 'باص فرزة', 'شاحنة صغيرة'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'طلب انضمام للكباتن',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'البيانات والوثائق',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 25),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'الاسم الرباعي الكامل',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _vehicle,
              dropdownColor: const Color(0xFF2B2D42),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'نوع المركبة',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
              ),
              items: _vehicles
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => setState(() => _vehicle = v!),
            ),
            const SizedBox(height: 30),
            const Text(
              '📸 الوثائق المطلوبة',
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
                  label: 'البطاقة الشخصية',
                  activeColor: Colors.orange,
                  onUploaded: (u) => setState(() => _d1 = u),
                ),
                ImageUploadBox(
                  label: 'رخصة القيادة',
                  activeColor: Colors.orange,
                  onUploaded: (u) => setState(() => _d2 = u),
                ),
                ImageUploadBox(
                  label: 'كرت الملكية',
                  activeColor: Colors.orange,
                  onUploaded: (u) => setState(() => _d3 = u),
                ),
                ImageUploadBox(
                  label: 'الضمانة التجارية',
                  activeColor: Colors.orange,
                  onUploaded: (u) => setState(() => _d4 = u),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF233C),
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✔️ جاري رفع وثائقك...')),
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

class DriverRadarDashboard extends StatefulWidget {
  const DriverRadarDashboard({super.key});
  @override
  State<DriverRadarDashboard> createState() => _DriverRadarDashboardState();
}

class _DriverRadarDashboardState extends State<DriverRadarDashboard> {
  bool _online = false;
  String _service = 'Taxi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        automaticallyImplyLeading: true,
        title: const Text(
          'رادار سوبر جيب',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          Row(
            children: [
              Text(
                _online ? 'ONLINE' : 'OFFLINE',
                style: TextStyle(
                  color: _online ? const Color(0xFF25D366) : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              Switch(
                value: _online,
                activeThumbColor: const Color(0xFF25D366),
                onChanged: (v) {
                  setState(() => _online = v);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        v ? '🟩 تم تفعيل بث الـ GPS' : '🟥 تم إيقاف الاستقبال',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DriverAccount()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: _online ? 180 : 140,
                        height: _online ? 180 : 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _online
                              ? const Color(0xFFEF233C).withValues(alpha: 0.05)
                              : Colors.white.withValues(alpha: 0.02),
                          border: Border.all(
                            color: _online
                                ? const Color(0xFFEF233C)
                                : Colors.white24,
                            width: 2,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.radar,
                        color: _online ? const Color(0xFFEF233C) : Colors.grey,
                        size: 60,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    _online
                        ? '📡 جاري البحث عن طلبات...'
                        : '💤 فعّل المفتاح لبدء الاستقبال',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 30),
                  if (_online)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF233C),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DriverActiveTrip(serviceType: _service),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text(
                        'استلام طلب',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_online)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: Color(0xFF2B2D42),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '🎛️ اختر نوع الخدمة',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _sBtn('Taxi', Icons.directions_car, 'تاكسي'),
                      const SizedBox(width: 10),
                      _sBtn('Frazah', Icons.airport_shuttle, 'فرزة'),
                      const SizedBox(width: 10),
                      _sBtn('Cargo', Icons.local_shipping, 'طرود'),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _sBtn(String id, IconData icon, String label) {
    final sel = _service == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _service = id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: sel
                ? const Color(0xFFEF233C)
                : Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: sel ? const Color(0xFFEF233C) : Colors.white12,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: sel ? Colors.white : Colors.white70, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: sel ? Colors.white : Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverActiveTrip extends StatefulWidget {
  final String serviceType;
  const DriverActiveTrip({super.key, required this.serviceType});

  @override
  State<DriverActiveTrip> createState() => _DriverActiveTripState();
}

class _DriverActiveTripState extends State<DriverActiveTrip> {
  final _otpController = TextEditingController();
  String? _invoiceImage;
  String? _deliveryProof;

  @override
  Widget build(BuildContext context) {
    final isCargo = widget.serviceType == 'Cargo';
    final isFrazah = widget.serviceType == 'Frazah';

    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: Text(
          isCargo
              ? 'رحلة طرود'
              : isFrazah
              ? 'رحلة فرزة'
              : 'رحلة تاكسي',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield, color: Color(0xFFEF233C), size: 26),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color(0xFFEF233C),
                  content: Text('🚨 تم إرسال نداء استغاثة SOS!'),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: 300,
                color: const Color(0xFF2B2D42).withValues(alpha: 0.3),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, color: Colors.white24, size: 80),
                        SizedBox(height: 10),
                        Text(
                          '📍 خريطة الملاحة حية',
                          style: TextStyle(color: Colors.white30, fontSize: 12),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '⬛⬛⬛⬛ الخط الملاحي نشط ⬛⬛⬛⬛',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B2D42),
                      ),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'اتصال محمي',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B2D42),
                      ),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'دردشة',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isCargo) ...[
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'كود التحقق OTP',
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.qr_code_scanner,
                          color: Color(0xFFEF233C),
                        ),
                        onPressed: () {},
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 120,
                    child: ImageUploadBox(
                      label: _invoiceImage == null
                          ? '📝 صوّر فاتورة الشراء'
                          : 'تم تصوير الفاتورة',
                      icon: Icons.receipt,
                      activeColor: const Color(0xFF25D366),
                      onUploaded: (u) => setState(() => _invoiceImage = u),
                    ),
                  ),
                ],
                if (isFrazah) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.airport_shuttle,
                          color: Colors.orange,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'رحلة بين المحافظات',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
                SizedBox(
                  height: 100,
                  child: ImageUploadBox(
                    label: _deliveryProof == null
                        ? '📸 صورة إثبات التسليم'
                        : 'تم رفع الإثبات',
                    icon: Icons.camera_alt,
                    activeColor: const Color(0xFF25D366),
                    onUploaded: (u) => setState(() => _deliveryProof = u),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF233C),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🏁 تم إنهاء الرحلة بنجاح'),
                          backgroundColor: Color(0xFF25D366),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '🏁 إنهاء الرحلة',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DriverAccount extends StatelessWidget {
  const DriverAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return const DriverAccountScreen();
  }
}
