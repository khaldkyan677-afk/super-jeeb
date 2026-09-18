import 'package:flutter/material.dart';

class MerchantAnalyticsScreen extends StatefulWidget {
  const MerchantAnalyticsScreen({super.key});

  @override
  State<MerchantAnalyticsScreen> createState() =>
      _MerchantAnalyticsScreenState();
}

class _MerchantAnalyticsScreenState extends State<MerchantAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text(
          'التحليلات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: const Color(0xFFEF233C),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'نظرة عامة'),
            Tab(text: 'المنتجات'),
            Tab(text: 'الفواتير'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [_OverviewTab(), _ProductsTab(), _InvoicesTab()],
      ),
    );
  }
}

// ============================================================
// 1. نظرة عامة
// ============================================================
class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // فلتر الفترة
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFFEF233C),
                  size: 18,
                ),
                const SizedBox(width: 10),
                const Text(
                  'الفترة:',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(width: 10),
                const Text(
                  'آخر 7 أيام',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
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
          ),
          const SizedBox(height: 20),

          // بطاقات الإحصائيات الرئيسية
          Row(
            children: [
              Expanded(
                child: _statCard(
                  '142',
                  'طلب',
                  Icons.receipt_long,
                  const Color(0xFFEF233C),
                  '+18%',
                  true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(
                  '25,400',
                  'YER أرباح',
                  Icons.attach_money,
                  const Color(0xFF25D366),
                  '+24%',
                  true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _statCard(
                  '38',
                  'منتج',
                  Icons.inventory_2,
                  Colors.amber,
                  '+3',
                  true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(
                  '4.8',
                  'تقييم',
                  Icons.star,
                  Colors.purple,
                  '+0.2',
                  true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // رسم بياني
          const Text(
            'المبيعات خلال الأسبوع',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 200,
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
                _bar('السبت', 0.5, 12000),
                _bar('الأحد', 0.8, 18000),
                _bar('الاثنين', 0.6, 15000),
                _bar('الثلاثاء', 1.0, 25000),
                _bar('الأربعاء', 0.7, 17000),
                _bar('الخميس', 0.9, 21000),
                _bar('الجمعة', 0.4, 9000),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // مصادر المبيعات
          const Text(
            'مصادر المبيعات',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _sourceBar('تطبيق الجوال', 0.75, const Color(0xFFEF233C)),
          _sourceBar('الويب', 0.15, const Color(0xFF25D366)),
          _sourceBar('QR المتجر', 0.10, Colors.amber),
        ],
      ),
    );
  }

  Widget _statCard(
    String value,
    String label,
    IconData icon,
    Color color,
    String change,
    bool positive,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      (positive
                              ? const Color(0xFF25D366)
                              : const Color(0xFFEF233C))
                          .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: positive
                        ? const Color(0xFF25D366)
                        : const Color(0xFFEF233C),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _bar(String day, double height, int value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${value ~/ 1000}K',
          style: const TextStyle(color: Colors.white38, fontSize: 8),
        ),
        const SizedBox(height: 4),
        Container(
          width: 25,
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
        Text(day, style: const TextStyle(color: Colors.white54, fontSize: 9)),
      ],
    );
  }

  Widget _sourceBar(String label, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '${(percent * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 2. المنتجات
// ============================================================
class _ProductsTab extends StatelessWidget {
  const _ProductsTab();

  final topProducts = const [
    {'name': 'قميص رجالي', 'sold': 45, 'revenue': 360000, 'rank': 1},
    {'name': 'بنطلون جينز', 'sold': 32, 'revenue': 384000, 'rank': 2},
    {'name': 'جاكيت شتوي', 'sold': 18, 'revenue': 450000, 'rank': 3},
    {'name': 'حزام جلد', 'sold': 25, 'revenue': 87500, 'rank': 4},
    {'name': 'ربطة عنق', 'sold': 12, 'revenue': 24000, 'rank': 5},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الأكثر مبيعاً',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          ...topProducts.map((p) => _productRow(p)),

          const SizedBox(height: 25),
          const Text(
            'المنتجات الراكدة',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _stagnantProduct(context, 'حزام جلد', 5, 'منذ 30 يوم'),
          _stagnantProduct(context, 'ربطة عنق', 100, 'منذ 45 يوم'),
        ],
      ),
    );
  }

  Widget _productRow(Map<String, dynamic> p) {
    final rank = p['rank'] as int;
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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${p['sold']} عملية بيع',
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            '${p['revenue']} YER',
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

  Widget _stagnantProduct(
    BuildContext context,
    String name,
    int stock,
    String lastSold,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEF233C).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFEF233C).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: Color(0xFFEF233C), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$stock قطعة • آخر بيع: $lastSold',
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.local_offer,
              color: Color(0xFF25D366),
              size: 20,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🏷️ أنشئ عرضاً لهذا المنتج'),
                  backgroundColor: Color(0xFF25D366),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 3. الفواتير
// ============================================================
class _InvoicesTab extends StatelessWidget {
  const _InvoicesTab();

  final invoices = const [
    {
      'id': 'INV-2026-021',
      'customer': 'خالد أحمد',
      'total': 20000,
      'status': 'paid',
      'date': 'اليوم 10:30 ص',
    },
    {
      'id': 'INV-2026-020',
      'customer': 'سارة محمد',
      'total': 8500,
      'status': 'paid',
      'date': 'اليوم 09:15 ص',
    },
    {
      'id': 'INV-2026-019',
      'customer': 'أحمد علي',
      'total': 35000,
      'status': 'pending',
      'date': 'أمس 08:45 م',
    },
    {
      'id': 'INV-2026-018',
      'customer': 'فاطمة سالم',
      'total': 12000,
      'status': 'paid',
      'date': 'أمس 07:20 م',
    },
    {
      'id': 'INV-2026-017',
      'customer': 'محمد حسن',
      'total': 45000,
      'status': 'refunded',
      'date': 'منذ يومين',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          // ملخص
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                _summaryItem('120,500', 'إجمالي', const Color(0xFF25D366)),
                Container(width: 1, height: 40, color: Colors.white10),
                _summaryItem('98,000', 'مدفوع', const Color(0xFFEF233C)),
                Container(width: 1, height: 40, color: Colors.white10),
                _summaryItem('22,500', 'معلق', Colors.orange),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...invoices.map((inv) => _invoiceCard(inv)),
        ],
      ),
    );
  }

  Widget _summaryItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _invoiceCard(Map<String, dynamic> inv) {
    final status = inv['status'] as String;
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'paid':
        color = const Color(0xFF25D366);
        label = 'مدفوع';
        icon = Icons.check_circle;
        break;
      case 'pending':
        color = Colors.orange;
        label = 'معلق';
        icon = Icons.hourglass_empty;
        break;
      case 'refunded':
        color = const Color(0xFFEF233C);
        label = 'مسترجع';
        icon = Icons.undo;
        break;
      default:
        color = Colors.grey;
        label = 'غير معروف';
        icon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        inv['id'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: color,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  inv['customer'],
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      inv['date'],
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${inv['total']} YER',
                      style: const TextStyle(
                        color: Color(0xFF25D366),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
