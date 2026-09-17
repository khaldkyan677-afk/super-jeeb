import 'package:flutter/material.dart';
import 'chat_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, dynamic>> _faqs = [
    {
      'q': 'كيف أتتبع طلبي؟',
      'a': 'يمكنك تتبع طلبك من خلال: حسابي → طلباتي → اختر الطلب → تتبع الطلب.',
      'icon': Icons.local_shipping,
    },
    {
      'q': 'ما هي طرق الدفع المتاحة؟',
      'a': 'نقبل: كاش عند الاستلام، محفظة الكريمي، جيب، جوالي، وفلوسك.',
      'icon': Icons.payment,
    },
    {
      'q': 'كيف أحصل على كود OTP للتسليم؟',
      'a': 'يظهر كود OTP في شاشة تتبع الطلب. شاركه مع الكابتن عند التسليم.',
      'icon': Icons.lock,
    },
    {
      'q': 'هل يمكنني إرجاع منتج؟',
      'a': 'نعم، خلال 24 ساعة من التسليم. تواصل مع الدعم عبر شاشة الدردشة.',
      'icon': Icons.undo,
    },
    {
      'q': 'كم تستغرق مدة التوصيل؟',
      'a': 'من 30 دقيقة إلى ساعة، حسب المسافة وأوقات الذروة.',
      'icon': Icons.timer,
    },
    {
      'q': 'كيف أكون مندوباً؟',
      'a': 'من حسابي → قدّم كمندوب → املأ الاستبيان وارفع الوثائق.',
      'icon': Icons.delivery_dining,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_query.isEmpty) return _faqs;
    return _faqs
        .where((f) =>
            f['q'].toString().contains(_query) ||
            f['a'].toString().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text('المساعدة والدعم',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // زر الدردشة المباشرة
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ChatScreen(
                            name: 'الدعم الفني',
                            icon: Icons.support_agent,
                            color: Color(0xFFEF233C),
                          ))),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2B2D42), Color(0xFFEF233C)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.support_agent,
                        color: Colors.white, size: 40),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('تحدث مع الدعم',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('نحن هنا لمساعدتك على مدار الساعة',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.white70, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // أزرار تواصل سريعة
            Row(
              children: [
                Expanded(
                  child: _contactBtn(
                    Icons.phone,
                    'اتصال',
                    const Color(0xFF25D366),
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('📞 800 1234')),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _contactBtn(
                    Icons.message,
                    'واتساب',
                    const Color(0xFF25D366),
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('💬 فتح واتساب')),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _contactBtn(
                    Icons.email,
                    'إيميل',
                    const Color(0xFFEF233C),
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('📧 support@superjeeb.com')),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // البحث
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 8),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'ابحث عن سؤال...',
                  hintStyle: TextStyle(fontSize: 13),
                  prefixIcon:
                      Icon(Icons.search, color: Color(0xFFEF233C)),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // الأسئلة الشائعة
            const Text('الأسئلة الشائعة',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2D42))),
            const SizedBox(height: 12),
            ..._filtered.map((f) => _faqCard(f)),
            const SizedBox(height: 25),

            // زر الإبلاغ
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Color(0xFFEF233C)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => _showReportDialog(),
              icon: const Icon(Icons.report_problem,
                  color: Color(0xFFEF233C)),
              label: const Text('الإبلاغ عن مشكلة',
                  style: TextStyle(
                      color: Color(0xFFEF233C),
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _contactBtn(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _faqCard(Map<String, dynamic> f) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Theme(
        data: Theme.of(context)
            .copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(f['icon'] as IconData,
              color: const Color(0xFFEF233C), size: 22),
          title: Text(f['q'],
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(f['a'],
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.report_problem, color: Color(0xFFEF233C)),
            SizedBox(width: 10),
            Text('الإبلاغ عن مشكلة',
                style: TextStyle(fontSize: 16)),
          ],
        ),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'اشرح المشكلة بالتفصيل...',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF233C)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('✅ تم استلام بلاغك'),
                    backgroundColor: Color(0xFF25D366)),
              );
            },
            child: const Text('إرسال',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
