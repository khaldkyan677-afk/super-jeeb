import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

class PolicyManagementScreen extends StatefulWidget {
  const PolicyManagementScreen({super.key});

  @override
  State<PolicyManagementScreen> createState() => _PolicyManagementScreenState();
}

class _PolicyManagementScreenState extends State<PolicyManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  bool _isSaving = false;

  // متحكمات لكل تطبيق
  final Map<String, TextEditingController> _termsCtrls = {
    'client': TextEditingController(), 'merchant': TextEditingController(), 'driver': TextEditingController()
  };
  final Map<String, TextEditingController> _privacyCtrls = {
    'client': TextEditingController(), 'merchant': TextEditingController(), 'driver': TextEditingController()
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAllPolicies();
  }

  Future<void> _loadAllPolicies() async {
    for (String appType in ['client', 'merchant', 'driver']) {
      try {
        final resTerms = await http.get(Uri.parse('${ApiService.baseUrl}/api/policies/$appType/terms'));
        final resPrivacy = await http.get(Uri.parse('${ApiService.baseUrl}/api/policies/$appType/privacy'));

        if (resTerms.statusCode == 200) _termsCtrls[appType]!.text = json.decode(resTerms.body)['content'] ?? '';
        if (resPrivacy.statusCode == 200) _privacyCtrls[appType]!.text = json.decode(resPrivacy.body)['content'] ?? '';
      } catch (e) {
        debugPrint('Error loading $appType policies: $e');
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _saveCurrentTabPolicies() async {
    setState(() => _isSaving = true);
    String appType = ['client', 'merchant', 'driver'][_tabController.index];
    try {
      final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${ApiService.authToken}'};

      await http.put(Uri.parse('${ApiService.baseUrl}/api/policies/$appType/terms'), headers: headers, body: jsonEncode({'content': _termsCtrls[appType]!.text}));
      await http.put(Uri.parse('${ApiService.baseUrl}/api/policies/$appType/privacy'), headers: headers, body: jsonEncode({'content': _privacyCtrls[appType]!.text}));

      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التعديلات بنجاح!'), backgroundColor: Colors.green));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء الحفظ'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var c in _termsCtrls.values) { c.dispose(); }
    for (var c in _privacyCtrls.values) { c.dispose(); }
    super.dispose();
  }

  Widget _buildAppPolicyForm(String appType) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الشروط والأحكام', style: GoogleFonts.cairo(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _termsCtrls[appType],
            maxLines: 6,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(filled: true, fillColor: const Color(0xFF3D0018), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          ),
          const SizedBox(height: 24),
          Text('سياسة الخصوصية', style: GoogleFonts.cairo(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _privacyCtrls[appType],
            maxLines: 6,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(filled: true, fillColor: const Color(0xFF3D0018), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E000C),
      appBar: AppBar(
        title: const Text('إدارة السياسات'),
        backgroundColor: const Color(0xFF3D0018),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          tabs: const [Tab(text: 'العميل'), Tab(text: 'التاجر'), Tab(text: 'المندوب')],
        ),
        actions: [
          IconButton(
            icon: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.save, color: Colors.green),
            onPressed: _isSaving ? null : _saveCurrentTabPolicies,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAppPolicyForm('client'),
                _buildAppPolicyForm('merchant'),
                _buildAppPolicyForm('driver'),
              ],
            ),
    );
  }
}
