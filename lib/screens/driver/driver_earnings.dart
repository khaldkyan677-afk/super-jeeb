import 'package:flutter/material.dart';

class DriverEarningsScreen extends StatefulWidget {
  const DriverEarningsScreen({super.key});

  @override
  State<DriverEarningsScreen> createState() => _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends State<DriverEarningsScreen>
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
          'أرباحي',
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
            Tab(text: 'اليوم'),
            Tab(text: 'الأسبوع'),
            Tab(text: 'الشهر'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _EarningsTab(period: 'today'),
          _EarningsTab(period: 'week'),
          _EarningsTab(period: 'month'),
        ],
      ),
    );
  }
}

class _EarningsTab extends StatelessWidget {
  final String period;
  const _EarningsTab({required this.period});

  Map<String, dynamic> get _data {
    switch (period) {
      case 'today':
        return {
          'total': 12500,
          'trips': 8,
          'hours': 6,
          'tips': 500,
          'bonus': 1000,
          'chart': [800, 1200, 1500, 2000, 1800, 2200, 3000],
          'chartLabels': ['8ص', '10ص', '12م', '2م', '4م', '6م', '8م'],
        };
      case 'week':
        return {
          'total': 87500,
          'trips': 52,
          'hours': 42,
          'tips': 3500,
          'bonus': 5000,
          'chart': [12000, 15000, 11000, 18000, 10000, 12500, 9000],
          'chartLabels': [
            'السبت',
            'الأحد',
            'الاثنين',
            'الثلاثاء',
            'الأربعاء',
            'الخميس',
            'الجمعة',
          ],
        };
      default:
        return {
          'total': 375000,
          'trips': 218,
          'hours': 180,
          'tips': 15000,
          'bonus': 20000,
          'chart': [45000, 52000, 48000, 55000, 60000, 58000, 57000],
          'chartLabels': ['1', '5', '10', '15', '20', '25', '30'],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;
    final maxChart = (d['chart'] as List).reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة الإجمالي الرئيسية
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF25D366), Color(0xFF1a9e4f)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF25D366).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      color: Colors.white70,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'إجمالي الأرباح',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      period == 'today'
                          ? 'اليوم'
                          : period == 'week'
                          ? 'هذا الأسبوع'
                          : 'هذا الشهر',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${d['total']} YER',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _miniStat('${d['trips']}', 'رحلة', Icons.local_shipping),
                    const SizedBox(width: 15),
                    _miniStat('${d['hours']}', 'ساعة', Icons.access_time),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // بطاقات فرعية
          Row(
            children: [
              Expanded(
                child: _subCard(
                  'الإكراميات',
                  '${d['tips']} YER',
                  Icons.card_giftcard,
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _subCard(
                  'المكافآت',
                  '${d['bonus']} YER',
                  Icons.emoji_events,
                  const Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // رسم بياني
          const Text(
            'تفصيل الأرباح',
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
              children: (d['chart'] as List).asMap().entries.map((e) {
                final height = (e.value / maxChart) * 130;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${e.value ~/ 1000}K',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 22,
                      height: height.toDouble(),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF25D366), Color(0xFF1a9e4f)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 30,
                      child: Text(
                        (d['chartLabels'] as List)[e.key].toString(),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 25),

          // سجل الرحلات
          const Text(
            'سجل الرحلات الأخيرة',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _tripRow('طلب #5021', '2.5 كم', 1500, '10:30 ص'),
          _tripRow('طلب #5020', '4.2 كم', 2200, '09:15 ص'),
          _tripRow('طلب #5019', '1.8 كم', 1200, '08:45 ص'),
          _tripRow('طلب #5018', '5.5 كم', 2800, '08:00 ص'),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _subCard(String title, String value, IconData icon, Color color) {
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
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tripRow(String id, String distance, int amount, String time) {
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
          const Icon(Icons.local_shipping, color: Color(0xFFEF233C), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.straighten,
                      color: Colors.white38,
                      size: 11,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      distance,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.access_time,
                      color: Colors.white38,
                      size: 11,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '+$amount',
            style: const TextStyle(
              color: Color(0xFF25D366),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
