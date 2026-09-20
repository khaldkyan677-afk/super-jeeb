import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  static const Color navy = Color(0xFF2B2D42);
  static const Color red = Color(0xFFEF233C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF25D366);
  static const Color yellow = Color(0xFFF0C107);

  double _balance = 1500.0;

  final List<Map<String, dynamic>> _transactions = [
    {'type': 'topup', 'amount': 1000.0, 'date': 'اليوم', 'time': '10:30', 'note': 'تغذية عبر إشعار تحويل'},
    {'type': 'payment', 'amount': -500.0, 'date': 'أمس', 'time': '15:20', 'note': 'رحلة تاكسي - أحمد'},
    {'type': 'topup', 'amount': 1000.0, 'date': 'قبل يومين', 'time': '09:00', 'note': 'كود تغذية SJ-1000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: navy,
        title: const Text('💰 محفظتي', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: white),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          _buildBalanceCard(),
          _buildActions(),
          const SizedBox(height: 20),
          _buildTransactions(),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [navy, Color(0xFF1A1B26)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: navy.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('💳 رصيدي الحالي', style: TextStyle(color: white, fontSize: 14)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh, color: white, size: 20)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Text(_balance.toStringAsFixed(0), style: const TextStyle(color: white, fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          const Text('YER', style: TextStyle(color: yellow, fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: green.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.verified_user, color: green, size: 14),
            SizedBox(width: 5),
            Text('حساب آمن ومحمي', style: TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.bold)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Expanded(child: _actionButton(Icons.add_circle, 'تغذية المحفظة', green, _showTopupDialog)),
        const SizedBox(width: 12),
        Expanded(child: _actionButton(Icons.send, 'تحويل للتطبيق', red, _showTransferDialog)),
      ]),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle), child: Icon(icon, color: color, size: 28)),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 13)),
        ]),
      ),
    );
  }

  Widget _buildTransactions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('📜 سجل العمليات', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 16)),
        const SizedBox(height: 12),
        ..._transactions.map((t) => _transactionTile(t)),
      ]),
    );
  }

  Widget _transactionTile(Map<String, dynamic> t) {
    final isTopup = t['type'] == 'topup';
    final amount = t['amount'] as double;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: (isTopup ? green : red).withOpacity(0.15), shape: BoxShape.circle),
          child: Icon(isTopup ? Icons.arrow_downward : Icons.arrow_upward, color: isTopup ? green : red, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t['note'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 13)),
          Text('${t['date']} • ${t['time']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ])),
        Text(
          '${amount > 0 ? "+" : ""}${amount.toStringAsFixed(0)} YER',
          style: TextStyle(fontWeight: FontWeight.bold, color: isTopup ? green : red, fontSize: 14),
        ),
      ]),
    );
  }

  void _showTopupDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 20),
          const Text('➕ تغذية المحفظة', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 18)),
          const SizedBox(height: 20),
          _topupOption(Icons.receipt_long, 'إشعار تحويل', 'حوّل لحساب التطبيق الرسمي وارفع الإشعار', green),
          _topupOption(Icons.card_giftcard, 'كود تغذية', 'أدخل كود شراء المحفظة', yellow),
          _topupOption(Icons.store, 'نقطة بيع معتمدة', 'ادفع كاش لأحد نقاط البيع', navy),
        ]),
      ),
    );
  }

  Widget _topupOption(IconData icon, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: navy)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {
          Navigator.pop(context);
          _showComingSoon(title);
        },
      ),
    );
  }

  void _showTransferDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 20),
          const Text('💸 تحويل إلى حساب التطبيق', style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 18)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
            child: const Column(children: [
              Icon(Icons.info_outline, color: Colors.grey, size: 40),
              SizedBox(height: 10),
              Text('لا توجد حسابات رسمية بعد', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
              SizedBox(height: 5),
              Text('سيتم تفعيل هذه الميزة عند إضافة الحسابات من لوحة الأدمن', style: TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
            ]),
          ),
        ]),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('سيتم تفعيل "$feature" قريباً'), backgroundColor: navy),
    );
  }
}
