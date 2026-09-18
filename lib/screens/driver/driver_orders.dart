import 'package:flutter/material.dart';

class DriverOrdersScreen extends StatefulWidget {
  const DriverOrdersScreen({super.key});

  @override
  State<DriverOrdersScreen> createState() => _DriverOrdersScreenState();
}

class _DriverOrdersScreenState extends State<DriverOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  final _available = [
    {
      'id': '5030',
      'type': 'توصيل طرد',
      'from': 'صنعاء - شارع حدة',
      'to': 'صنعاء - شارع تعز',
      'distance': '3.2 كم',
      'fee': 1800,
      'time': 'منذ دقيقة',
    },
    {
      'id': '5031',
      'type': 'تاكسي',
      'from': 'صنعاء - الجامعة',
      'to': 'صنعاء - المطار',
      'distance': '8.5 كم',
      'fee': 3500,
      'time': 'منذ 3 دقائق',
    },
    {
      'id': '5032',
      'type': 'اشترِ لي',
      'from': 'صيدلية النور',
      'to': 'شارع بغداد',
      'distance': '2.1 كم',
      'fee': 2200,
      'time': 'منذ 5 دقائق',
    },
  ];

  final _active = [
    {
      'id': '5021',
      'type': 'توصيل طرد',
      'from': 'متجر الأناقة',
      'to': 'شارع تعز',
      'distance': '2.5 كم',
      'fee': 1500,
      'status': 'في الطريق',
      'statusColor': Color(0xFF25D366),
    },
  ];

  final _completed = [
    {
      'id': '5020',
      'type': 'تاكسي',
      'from': 'الجامعة',
      'to': 'المطار',
      'distance': '8.5 كم',
      'fee': 3500,
      'date': 'اليوم 10:30 ص',
    },
    {
      'id': '5019',
      'type': 'طرود',
      'from': 'صيدلية',
      'to': 'شارع بغداد',
      'distance': '1.8 كم',
      'fee': 1200,
      'date': 'اليوم 09:15 ص',
    },
    {
      'id': '5018',
      'type': 'تاكسي',
      'from': 'شارع حدة',
      'to': 'شارع الستين',
      'distance': '5.5 كم',
      'fee': 2800,
      'date': 'أمس 08:45 م',
    },
  ];

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
          'الطلبات',
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
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          tabs: [
            Tab(text: 'متاحة (${_available.length})'),
            Tab(text: 'جارية (${_active.length})'),
            Tab(text: 'السجل (${_completed.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [_availableList(), _activeList(), _completedList()],
      ),
    );
  }

  Widget _availableList() {
    if (_available.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.white24),
            SizedBox(height: 15),
            Text(
              'لا توجد طلبات متاحة',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: _available.length,
      itemBuilder: (context, i) => _availableCard(_available[i], i),
    );
  }

  Widget _availableCard(Map<String, dynamic> o, int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF25D366).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: Color(0xFF25D366),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o['type'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      o['time'],
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${o['fee']} YER',
                style: const TextStyle(
                  color: Color(0xFF25D366),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 20),
          _routeRow(
            Icons.my_location,
            'من',
            o['from'],
            const Color(0xFF25D366),
          ),
          const SizedBox(height: 6),
          _routeRow(Icons.location_on, 'إلى', o['to'], const Color(0xFFEF233C)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.straighten, color: Colors.white38, size: 12),
              const SizedBox(width: 4),
              Text(
                o['distance'],
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
              const Spacer(),
              const Icon(Icons.access_time, color: Colors.white38, size: 12),
              const SizedBox(width: 4),
              const Text(
                'التقدير: 15 د',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _active.add({
                        ...o,
                        'status': 'في الطريق',
                        'statusColor': const Color(0xFF25D366),
                      });
                      _available.removeAt(i);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ تم قبول الطلب'),
                        backgroundColor: Color(0xFF25D366),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check, color: Colors.white, size: 18),
                  label: const Text(
                    'قبول',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() => _available.removeAt(i));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('⏭️ تم تجاوز الطلب'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                child: const Text(
                  'تجاوز',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activeList() {
    if (_active.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.white24),
            SizedBox(height: 15),
            Text(
              'لا توجد طلبات جارية',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: _active.length,
      itemBuilder: (context, i) => _activeCard(_active[i], i),
    );
  }

  Widget _activeCard(Map<String, dynamic> o, int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF25D366).withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: Color(0xFF25D366),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'طلب #${o['id']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (o['statusColor'] as Color).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  o['status'],
                  style: TextStyle(
                    color: o['statusColor'] as Color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 20),
          _routeRow(
            Icons.my_location,
            'من',
            o['from'],
            const Color(0xFF25D366),
          ),
          const SizedBox(height: 6),
          _routeRow(Icons.location_on, 'إلى', o['to'], const Color(0xFFEF233C)),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF233C),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _completed.add({
                        'id': o['id'],
                        'type': o['type'],
                        'from': o['from'],
                        'to': o['to'],
                        'distance': o['distance'],
                        'fee': o['fee'],
                        'date': 'الآن',
                      });
                      _active.removeAt(i);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🏁 تم إنهاء الرحلة'),
                        backgroundColor: Color(0xFF25D366),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'إنهاء الرحلة',
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
        ],
      ),
    );
  }

  Widget _completedList() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: _completed.length,
      itemBuilder: (context, i) => _completedCard(_completed[i]),
    );
  }

  Widget _completedCard(Map<String, dynamic> o) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
              color: const Color(0xFF25D366).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Color(0xFF25D366),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طلب #${o['id']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${o['from']} → ${o['to']}',
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  o['date'],
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            '+${o['fee']}',
            style: const TextStyle(
              color: Color(0xFF25D366),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 12),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
