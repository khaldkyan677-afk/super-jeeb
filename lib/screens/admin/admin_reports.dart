import 'package:flutter/material.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B0013),
      appBar: AppBar(
        backgroundColor: const Color(0xFF660F24),
        title: const Text(
          'التقارير والإحصائيات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.file_download,
              color: Color(0xFF25D366),
              size: 22,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📥 جاري تصدير التقرير كـ Excel...'),
                  backgroundColor: Color(0xFF25D366),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          indicatorColor: const Color(0xFFEF233C),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'عام'),
            Tab(text: 'المبيعات'),
            Tab(text: 'المستخدمون'),
            Tab(text: 'الأرباح'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [_GeneralTab(), _SalesTab(), _UsersTab(), _ProfitTab()],
      ),
    );
  }
}

// ============================================================
// 1. عام
// ============================================================
class _GeneralTab extends StatelessWidget {
  const _GeneralTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _periodFilter(),
          const SizedBox(height: 20),
          const Text(
            'مؤشرات رئيسية',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _kpiCard(
                'إجمالي الطلبات',
                '1,428',
                '+18%',
                const Color(0xFFEF233C),
                Icons.receipt_long,
              ),
              _kpiCard(
                'المستخدمون النشطون',
                '385',
                '+12%',
                const Color(0xFF25D366),
                Icons.people,
              ),
              _kpiCard(
                'المتاجر النشطة',
                '142',
                '+5%',
                Colors.amber,
                Icons.storefront,
              ),
              _kpiCard(
                'الكباتن',
                '85',
                '+8%',
                Colors.purple,
                Icons.delivery_dining,
              ),
              _kpiCard(
                'إجمالي المبيعات',
                '2.4M',
                '+24%',
                const Color(0xFFD4AF37),
                Icons.attach_money,
              ),
              _kpiCard('متوسط التقييم', '4.8', '+0.2', Colors.cyan, Icons.star),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'رسم بياني للنمو',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 180,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _barChart('يناير', 0.4, 400),
                _barChart('فبراير', 0.6, 620),
                _barChart('مارس', 0.5, 540),
                _barChart('أبريل', 0.8, 810),
                _barChart('مايو', 0.7, 720),
                _barChart('يونيو', 1.0, 1050),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Color(0xFFEF233C), size: 18),
          const SizedBox(width: 10),
          const Text(
            'الفترة:',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(width: 8),
          const Text(
            'آخر 6 أشهر',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _kpiCard(
    String title,
    String value,
    String change,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
              Text(
                change,
                style: const TextStyle(
                  color: Color(0xFF25D366),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _barChart(String label, double height, int value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$value',
          style: const TextStyle(color: Colors.white38, fontSize: 9),
        ),
        const SizedBox(height: 4),
        Container(
          width: 28,
          height: 120 * height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEF233C), Color(0xFF8B1428)],
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 9)),
      ],
    );
  }
}

// ============================================================
// 2. المبيعات
// ============================================================
class _SalesTab extends StatelessWidget {
  const _SalesTab();

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'ملابس', 'orders': 428, 'revenue': 850000, 'percent': 0.35},
      {'name': 'إلكترونيات', 'orders': 312, 'revenue': 680000, 'percent': 0.28},
      {'name': 'صيدليات', 'orders': 245, 'revenue': 320000, 'percent': 0.13},
      {'name': 'عطور', 'orders': 189, 'revenue': 280000, 'percent': 0.12},
      {'name': 'مطاعم', 'orders': 156, 'revenue': 175000, 'percent': 0.07},
      {'name': 'أخرى', 'orders': 98, 'revenue': 95000, 'percent': 0.05},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF25D366), Color(0xFF1a9e4f)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.white70, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'إجمالي المبيعات',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '2,400,000 YER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.white70, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '+24% عن الفترة السابقة',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'المبيعات حسب القسم',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...categories.map((c) => _categoryRow(c)),
        ],
      ),
    );
  }

  Widget _categoryRow(Map<String, dynamic> c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  c['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${c['orders']} طلب',
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
              const SizedBox(width: 10),
              Text(
                '${c['revenue']} YER',
                style: const TextStyle(
                  color: Color(0xFF25D366),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: c['percent'] as double,
              minHeight: 6,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFEF233C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 3. المستخدمون
// ============================================================
class _UsersTab extends StatelessWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _userCard(
                  'العملاء',
                  '12,450',
                  '+8%',
                  const Color(0xFFEF233C),
                  Icons.people,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _userCard(
                  'التجار',
                  '142',
                  '+5%',
                  const Color(0xFF25D366),
                  Icons.storefront,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _userCard(
                  'المناديب',
                  '85',
                  '+12%',
                  Colors.orange,
                  Icons.delivery_dining,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _userCard(
                  'موظفو الأدمن',
                  '5',
                  'ثابت',
                  Colors.purple,
                  Icons.admin_panel_settings,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'نمو المستخدمين',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                _growthRow('هذا الشهر', '+485', '+8%', const Color(0xFF25D366)),
                _growthRow(
                  'الشهر الماضي',
                  '+412',
                  '+6%',
                  const Color(0xFF25D366),
                ),
                _growthRow(
                  'منذ 3 أشهر',
                  '+380',
                  '+5%',
                  const Color(0xFF25D366),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'أعلى المناطق',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _regionRow('صنعاء', 5420, 0.42),
          _regionRow('عدن', 3150, 0.24),
          _regionRow('تعز', 2180, 0.17),
          _regionRow('الحديدة', 1120, 0.09),
          _regionRow('حضرموت', 580, 0.08),
        ],
      ),
    );
  }

  Widget _userCard(
    String title,
    String value,
    String change,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ),
              Text(
                change,
                style: const TextStyle(
                  color: Color(0xFF25D366),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _growthRow(String period, String value, String change, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              period,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _regionRow(String name, int users, double percent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '$users مستخدم',
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 5,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFD4AF37),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 4. الأرباح
// ============================================================
class _ProfitTab extends StatelessWidget {
  const _ProfitTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.diamond, color: Colors.white70, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'صافي أرباح المنصة',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '360,000 YER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '+18% عن الشهر الماضي',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'تفصيل الأرباح',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _profitRow(
            'عمولة المبيعات',
            '240,000 YER',
            0.67,
            const Color(0xFFEF233C),
          ),
          _profitRow(
            'عمولة التوصيل',
            '72,000 YER',
            0.20,
            const Color(0xFF25D366),
          ),
          _profitRow('الإعلانات', '36,000 YER', 0.10, const Color(0xFFD4AF37)),
          _profitRow('الاشتراكات', '12,000 YER', 0.03, Colors.purple),
          const SizedBox(height: 25),
          const Text(
            'أعلى العملولات',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _topRow('متجر الأناقة', '45,000', 1),
          _topRow('متجر الإلكترونيات', '38,000', 2),
          _topRow('صيدلية النور', '28,000', 3),
          _topRow('سوبرماركت الحياة', '22,000', 4),
          _topRow('متجر العطور', '18,000', 5),
        ],
      ),
    );
  }

  Widget _profitRow(String label, String value, double percent, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(percent * 100).toInt()}% من الإجمالي',
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _topRow(String name, String amount, int rank) {
    Color rankColor;
    if (rank == 1) {
      rankColor = const Color(0xFFD4AF37);
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0);
    } else if (rank == 3) {
      rankColor = const Color(0xFFCD7F32);
    } else {
      rankColor = Colors.white38;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: rankColor, width: 1.5),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: rankColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Text(
            '$amount YER',
            style: const TextStyle(
              color: Color(0xFF25D366),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
