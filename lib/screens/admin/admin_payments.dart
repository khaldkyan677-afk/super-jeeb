import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

const kRed = Color(0xFFEF233C);
const kBg = Color(0xFF0D0D12);
const kSurface = Color(0xFF1A1B26);
const kGreen = Color(0xFF25D366);
const kGold = Color(0xFFF0C107);
const kBorder = Color(0xFF2A2B36);

class AdminPaymentsScreen extends StatefulWidget {
  const AdminPaymentsScreen({super.key});
  @override
  State<AdminPaymentsScreen> createState() => _AdminPaymentsScreenState();
}

class _AdminPaymentsScreenState extends State<AdminPaymentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kSurface,
        title: Text('الدفع', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w800)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabs,
          labelColor: kRed,
          unselectedLabelColor: Colors.white54,
          labelStyle: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w800),
          unselectedLabelStyle: GoogleFonts.cairo(fontSize: 12),
          indicatorColor: kRed,
          isScrollable: true,
          tabs: const [
            Tab(text: 'طرق الدفع'),
            Tab(text: 'المعاملات'),
            Tab(text: 'السحب'),
            Tab(text: 'التقارير'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          PaymentMethodsTab(),
          TransactionsTab(),
          WithdrawalsTab(),
          PaymentReportsTab(),
        ],
      ),
    );
  }
}

class PaymentMethodsTab extends StatefulWidget {
  const PaymentMethodsTab({super.key});
  @override
  State<PaymentMethodsTab> createState() => _PaymentMethodsTabState();
}

class _PaymentMethodsTabState extends State<PaymentMethodsTab> {
  List<dynamic> _methods = [];
  bool _loading = true;
  String? _err;
  String? _debugBaseUrl;

  @override
  void initState() {
    super.initState();
    _load();
  }


  Future<void> _load() async {
    setState(() { _loading = true; _err = null; });
    try {
      final data = await ApiService.listPaymentMethods();
      if (!mounted) return;
      setState(() { _methods = data; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _loading = false; _err = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: kRed,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('إضافة طريقة', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kRed))
          : RefreshIndicator(
              color: kRed,
              onRefresh: _load,
              child: _methods.isEmpty
                  ? ListView(children: [
                      const SizedBox(height: 100),
                      Center(child: Text('لا توجد طرق دفع', style: GoogleFonts.cairo(color: Colors.white54))),
                      if (_debugBaseUrl != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('baseUrl الفعلي:',
                                  style: GoogleFonts.cairo(color: Colors.lightBlueAccent, fontSize: 11, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 6),
                                SelectableText(_debugBaseUrl ?? '',
                                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (_err != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: kRed.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kRed),
                            ),
                            child: Text('الخطأ: $_err',
                              style: GoogleFonts.cairo(color: kRed, fontSize: 11)),
                          ),
                        ),
                    ])
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _methods.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _methodCard(_methods[i]),
                    ),
            ),
    );
  }

  Widget _methodCard(dynamic m) {
    final isActive = m['isActive'] ?? true;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: kRed.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.payment, color: kRed),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m['name'] ?? '', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 3),
                Text('${m['code']} • ${m['type']}', style: GoogleFonts.cairo(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: isActive,
            activeThumbColor: kGreen,
            onChanged: (v) async {
              await ApiService.updatePaymentMethod(m['_id'], {'isActive': v});
              _load();
            },
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    final name = TextEditingController();
    final code = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: kSurface,
        title: Text('إضافة طريقة دفع', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, style: GoogleFonts.cairo(color: Colors.white), decoration: InputDecoration(hintText: 'الاسم', hintStyle: GoogleFonts.cairo(color: Colors.white54))),
            const SizedBox(height: 10),
            TextField(controller: code, style: GoogleFonts.cairo(color: Colors.white), decoration: InputDecoration(hintText: 'الكود (بالإنجليزية)', hintStyle: GoogleFonts.cairo(color: Colors.white54))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.white54))),
          TextButton(
            onPressed: () async {
              final n = name.text.trim();
              final c = code.text.trim();
              final messenger = ScaffoldMessenger.of(context);
              if (n.isEmpty || c.isEmpty) {
                messenger.showSnackBar(SnackBar(content: Text('الاسم والكود مطلوبان', style: GoogleFonts.cairo()), backgroundColor: kRed));
                return;
              }
              final res = await ApiService.addPaymentMethod({'name': n, 'code': c, 'type': 'wallet'});
              if (!dialogCtx.mounted) return;
              Navigator.pop(dialogCtx);
              if (res.containsKey('error')) {
                messenger.showSnackBar(SnackBar(content: Text('فشل: ${res['error']}', style: GoogleFonts.cairo()), backgroundColor: kRed));
                return;
              }
              messenger.showSnackBar(SnackBar(content: Text('✓ تمت الإضافة', style: GoogleFonts.cairo()), backgroundColor: kGreen));
              _load();
            },
            child: Text('حفظ', style: GoogleFonts.cairo(color: kRed, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class TransactionsTab extends StatefulWidget {
  const TransactionsTab({super.key});
  @override
  State<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  List<dynamic> _list = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await ApiService.listTransactions();
    if (!mounted) return;
    setState(() { _list = data; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kRed))
          : _list.isEmpty
              ? ListView(children: [const SizedBox(height: 200), Center(child: Text('لا توجد معاملات', style: GoogleFonts.cairo(color: Colors.white54)))])
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _txn(_list[i]),
                ),
    );
  }

  Widget _txn(dynamic t) {
    final st = t['status'] ?? 'pending';
    final color = st == 'success' ? kGreen : (st == 'failed' ? kRed : kGold);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBorder)),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(st == 'success' ? Icons.check : Icons.hourglass_top, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t['transactionId'] ?? '', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                Text('${t['method']} • $st', style: GoogleFonts.cairo(color: Colors.white54, fontSize: 10)),
              ],
            ),
          ),
          Text('${t['amount']} ري', style: GoogleFonts.cairo(color: color, fontWeight: FontWeight.w800, fontSize: 13)),
        ],
      ),
    );
  }
}

class WithdrawalsTab extends StatefulWidget {
  const WithdrawalsTab({super.key});
  @override
  State<WithdrawalsTab> createState() => _WithdrawalsTabState();
}

class _WithdrawalsTabState extends State<WithdrawalsTab> {
  List<dynamic> _list = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await ApiService.listAllWithdrawals();
    if (!mounted) return;
    setState(() { _list = data; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kRed))
          : _list.isEmpty
              ? ListView(children: [const SizedBox(height: 200), Center(child: Text('لا توجد طلبات سحب', style: GoogleFonts.cairo(color: Colors.white54)))])
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _wd(_list[i]),
                ),
    );
  }

  Widget _wd(dynamic w) {
    final st = w['status'] ?? 'pending';
    final color = st == 'paid' ? kGreen : (st == 'rejected' ? kRed : kGold);
    final user = w['userId'] as Map<String, dynamic>?;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBorder)),
      child: Column(
        children: [
          Row(
            children: [
              Text(w['withdrawalId'] ?? '', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(st, style: GoogleFonts.cairo(color: color, fontSize: 10, fontWeight: FontWeight.w800)),
              ),
              const Spacer(),
              Text('${w['amount']} ري', style: GoogleFonts.cairo(color: kGold, fontWeight: FontWeight.w800, fontSize: 14)),
            ],
          ),
          if (user != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white54, size: 14),
                const SizedBox(width: 6),
                Text('${user['name']} • ${user['phone']}', style: GoogleFonts.cairo(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class PaymentReportsTab extends StatefulWidget {
  const PaymentReportsTab({super.key});
  @override
  State<PaymentReportsTab> createState() => _PaymentReportsTabState();
}

class _PaymentReportsTabState extends State<PaymentReportsTab> {
  Map<String, dynamic> _stats = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await ApiService.paymentStats();
    if (!mounted) return;
    setState(() { _stats = data; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: kRed));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _stat('إجمالي المعاملات', '${_stats['total'] ?? 0}', Icons.receipt_long, kRed),
        const SizedBox(height: 10),
        _stat('ناجحة', '${_stats['success'] ?? 0}', Icons.check_circle, kGreen),
        const SizedBox(height: 10),
        _stat('فاشلة', '${_stats['failed'] ?? 0}', Icons.error, kRed),
        const SizedBox(height: 10),
        _stat('معلقة', '${_stats['pending'] ?? 0}', Icons.hourglass_top, kGold),
        const SizedBox(height: 10),
        _stat('إجمالي المبلغ', '${_stats['totalAmount'] ?? 0} ري', Icons.payments, kGold),
      ],
    );
  }

  Widget _stat(String label, String val, IconData ic, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBorder)),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(ic, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: GoogleFonts.cairo(color: Colors.white70, fontSize: 13))),
          Text(val, style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
        ],
      ),
    );
  }
}
