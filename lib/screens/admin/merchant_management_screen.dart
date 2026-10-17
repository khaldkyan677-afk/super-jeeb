import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/api_service.dart';

class MerchantManagementScreen extends StatefulWidget {
  const MerchantManagementScreen({super.key});
  @override
  State<MerchantManagementScreen> createState() => _MerchantManagementScreenState();
}

class _MerchantManagementScreenState extends State<MerchantManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _allMerchants = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/admins/merchants'),
        headers: {'Authorization': 'Bearer ${ApiService.authToken}'},
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() => _allMerchants = data['merchants'] ?? []);
      }
    } catch (e) {
      _showSnack('خطأ في الاتصال', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg, Color bg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg, style: const TextStyle(color: Colors.white)), backgroundColor: bg));
  }

  Future<void> _verify(String id, String action, {String reason = ''}) async {
    try {
      final res = await http.put(
        Uri.parse('${ApiService.baseUrl}/api/admins/merchants/$id/verify'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${ApiService.authToken}'},
        body: jsonEncode({'action': action, 'reason': reason}),
      );
      if (res.statusCode == 200) {
        _showSnack(action == 'accept' ? 'تم توثيق المتجر بنجاح' : 'تم رفض المتجر', action == 'accept' ? Colors.green : Colors.red);
        _load();
      }
    } catch (e) { _showSnack('خطأ: $e', Colors.red); }
  }

  Future<void> _toggleStatus(String id, bool currentStatus) async {
    try {
      final res = await http.put(
        Uri.parse('${ApiService.baseUrl}/api/admins/merchants/$id/toggle'),
        headers: {'Authorization': 'Bearer ${ApiService.authToken}'},
      );
      if (res.statusCode == 200) {
        _showSnack(currentStatus ? 'تم إيقاف المتجر' : 'تم تشغيل المتجر', Colors.orange);
        _load();
      }
    } catch (e) { _showSnack('خطأ: $e', Colors.red); }
  }

  Future<void> _deleteMerchant(String id) async {
    try {
      final res = await http.delete(
        Uri.parse('${ApiService.baseUrl}/api/admins/merchants/$id'),
        headers: {'Authorization': 'Bearer ${ApiService.authToken}'},
      );
      if (res.statusCode == 200) {
        _showSnack('تم الحذف نهائياً', Colors.red);
        _load();
      }
    } catch (e) { _showSnack('خطأ: $e', Colors.red); }
  }

  Future<void> _sendAlert(String id, String message) async {
    try {
      final res = await http.put(
        Uri.parse('${ApiService.baseUrl}/api/admins/merchants/$id/alert'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${ApiService.authToken}'},
        body: jsonEncode({'message': message}),
      );
      if (res.statusCode == 200) _showSnack('تم إرسال الإنذار', Colors.blue);
    } catch (e) { _showSnack('خطأ: $e', Colors.red); }
  }

  Future<void> _editCommission(String id, dynamic currentCommission) async {
    final ctrl = TextEditingController(text: currentCommission?.toString() ?? '5');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF3D0018),
        title: const Text('تعديل العمولة', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'النسبة (مثال: 5)', hintStyle: TextStyle(color: Colors.white54)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final res = await http.put(
                  Uri.parse('${ApiService.baseUrl}/api/admins/merchants/$id/commission'),
                  headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${ApiService.authToken}'},
                  body: jsonEncode({'commission': double.tryParse(ctrl.text) ?? 5}),
                );
                if (res.statusCode == 200) { _showSnack('تم تحديث العمولة', Colors.green); _load(); }
              } catch (e) { _showSnack('خطأ: $e', Colors.red); }
            },
            child: const Text('حفظ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showActionDialog(String title, String hint, Function(String) onConfirm, {bool isDanger = false}) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF3D0018),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.white54)),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: isDanger ? Colors.red : Colors.green),
            onPressed: () { Navigator.pop(ctx); onConfirm(ctrl.text); },
            child: const Text('تأكيد', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getImageProvider(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final cleanUrl = url.trim();
    if (cleanUrl.startsWith('data:image') || cleanUrl.length > 500) {
      try { return MemoryImage(base64Decode(cleanUrl.split(',')[1])); } catch (e) { return null; }
    }
    if (cleanUrl.startsWith('/')) return NetworkImage('${ApiService.baseUrl}$cleanUrl');
    return NetworkImage(cleanUrl);
  }

  Widget _buildImage(String? url, {double? height, double? width, BoxFit fit = BoxFit.cover}) {
    final provider = _getImageProvider(url);
    if (provider == null) return Container(color: Colors.white10, height: height, width: width, child: const Icon(Icons.image_not_supported, color: Colors.white54));
    return Image(image: provider, height: height, width: width, fit: fit, errorBuilder: (a,b,c) => Container(color: Colors.white10, height: height, width: width, child: const Icon(Icons.broken_image, color: Colors.white54)));
  }

  void _showFullScreenImage(String? url) {
    final provider = _getImageProvider(url);
    if (provider == null) return;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(panEnabled: true, minScale: 1, maxScale: 4, child: Image(image: provider, fit: BoxFit.contain)),
            Positioned(top: 40, right: 20, child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 30), onPressed: () => Navigator.pop(ctx))),
          ],
        ),
      ),
    );
  }

  void _showPreview(Map<String, dynamic> m) {
    String statusStr = 'معلق';
    Color statusColor = Colors.orange;
    if (m['documentsVerified'] == false) { statusStr = 'مرفوض'; statusColor = Colors.red; }
    else if (m['isVerified'] == true) { statusStr = m['isActive'] == true ? 'نشط' : 'موقوف'; statusColor = m['isActive'] == true ? Colors.green : Colors.red; }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E000C),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomLeft,
                  children: [
                    GestureDetector(onTap: () => _showFullScreenImage(m['coverImage']), child: ClipRRect(borderRadius: BorderRadius.circular(12), child: _buildImage(m['coverImage'], height: 120, width: double.infinity))),
                    Positioned(
                      bottom: -20, left: 16,
                      child: GestureDetector(
                        onTap: () => _showFullScreenImage(m['logo']),
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF1E000C), width: 4)),
                          child: CircleAvatar(radius: 36, backgroundColor: Colors.white10, backgroundImage: _getImageProvider(m['logo']), child: m['logo'] == null ? const Icon(Icons.store, color: Colors.white54) : null),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(m['name'] ?? 'بدون اسم', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: Text(statusStr, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 8),
                Text(m['description'] ?? 'لا يوجد وصف', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const Divider(color: Colors.white24, height: 30),
                _sectionTitle('البيانات الأساسية'),
                _infoRow('القسم', m['category']),
                _buildSubsRow(m['subs']),
                _buildPhoneRow(m['phone'] ?? ''),
                _infoRow('المحافظة', m['governorate']),
                _infoRow('المدينة', m['city']),
                _buildAddressRow(m),
                _infoRow('ساعات العمل', m['workingHours'] ?? 'غير محدد'),
                const Divider(color: Colors.white24, height: 30),
                _sectionTitle('الوثائق المرفقة'),
                if (m['documents'] != null && m['documents'] is Map) ...[
                  _buildDocRow('البطاقة الشخصية', m['documents']['nationalId']),
                  _buildDocRow('السجل التجاري', m['documents']['commercialRegistry']),
                  _buildDocRow('الرخصة التجارية', m['documents']['businessLicense']),
                  _buildDocRow('صورة الواجهة', m['documents']['storeFrontImage']),
                  _buildDocRow('صورة الداخل', m['documents']['storeInsideImage']),
                ] else const Text('لا توجد وثائق', style: TextStyle(color: Colors.white54)),
                const Divider(color: Colors.white24, height: 30),
                _sectionTitle('الموافقات والعمولة'),
                _infoRow('العمولة', '${m['commission'] ?? 5}%'),
                _infoRow('الموافقة على الشروط', m['agreedToTerms'] == true ? 'نعم ✅' : 'لا ❌'),
                _infoRow('الموافقة على العمولة', m['agreedToCommission'] == true ? 'نعم ✅' : 'لا ❌'),
                if (m['rejectionReason'] != null) ...[
                  const SizedBox(height: 16),
                  Container(padding: const EdgeInsets.all(12), width: double.infinity, decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.withValues(alpha: 0.3))), child: Text('❌ سبب الرفض: ${m['rejectionReason']}', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneRow(String phone) {
    return InkWell(
      onTap: () { Clipboard.setData(ClipboardData(text: phone)); _showSnack('تم نسخ رقم الهاتف', Colors.green); },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          const Icon(Icons.phone, color: Colors.white54, size: 16), const SizedBox(width: 8),
          Text(phone, style: const TextStyle(color: Colors.blueAccent, fontSize: 14)), const SizedBox(width: 8),
          const Icon(Icons.copy, color: Colors.white54, size: 14),
        ]),
      ),
    );
  }

  Widget _buildAddressRow(Map<String, dynamic> m) {
    final lat = m['latitude']; final lng = m['longitude'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        const SizedBox(width: 120, child: Text('العنوان', style: TextStyle(color: Colors.white54, fontSize: 13))),
        Expanded(child: Text(m['address'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 14))),
        if (lat != null && lng != null)
          IconButton(
            icon: const Icon(Icons.map, color: Colors.green),
            onPressed: () async {
              final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
              if (await canLaunchUrl(url)) { await launchUrl(url); }
            },
          )
      ]),
    );
  }

  Widget _buildSubsRow(dynamic subs) {
    if (subs == null || subs is! List || subs.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(width: 120, child: Text('الأقسام الفرعية', style: TextStyle(color: Colors.white54, fontSize: 13))),
        Expanded(child: Wrap(spacing: 4, runSpacing: 4, children: subs.map((s) => Chip(label: Text(s.toString(), style: const TextStyle(fontSize: 12, color: Colors.white)), backgroundColor: Colors.white12, padding: EdgeInsets.zero, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)).toList())),
      ]),
    );
  }

  Widget _buildDocRow(String title, String? url) {
    if (url == null || url.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        GestureDetector(onTap: () => _showFullScreenImage(url), child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _buildImage(url, height: 60, width: 60))),
        const SizedBox(width: 12), Text(title, style: const TextStyle(color: Colors.white70)),
      ]),
    );
  }

  Widget _sectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)));

  Widget _infoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14))),
      ]),
    );
  }

  Widget _buildStats() {
    int pending = _allMerchants.where((m) => m['isVerified'] != true && m['documentsVerified'] != false).length;
    int active = _allMerchants.where((m) => m['isVerified'] == true && m['isActive'] == true).length;
    int inactive = _allMerchants.where((m) => m['isVerified'] == true && m['isActive'] == false).length;
    int rejected = _allMerchants.where((m) => m['documentsVerified'] == false).length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(children: [
        _statCard('الكل', _allMerchants.length, Colors.blue), const SizedBox(width: 8),
        _statCard('معلق', pending, Colors.orange), const SizedBox(width: 8),
        _statCard('نشط', active, Colors.green), const SizedBox(width: 8),
        _statCard('موقوف', inactive, Colors.grey), const SizedBox(width: 8),
        _statCard('مرفوض', rejected, Colors.red),
      ]),
    );
  }

  Widget _statCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.5))),
      child: Column(children: [
        Text('$count', style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(title, style: TextStyle(color: color, fontSize: 12)),
      ]),
    );
  }

  Widget _buildTabList(String type) {
    List<dynamic> filtered = _allMerchants.where((m) {
      if (!m['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) && !m['phone'].toString().contains(_searchQuery)) return false;
      if (type == 'pending') return m['isVerified'] != true && m['documentsVerified'] != false;
      if (type == 'active') return m['isVerified'] == true && m['isActive'] == true;
      if (type == 'inactive') return m['isVerified'] == true && m['isActive'] == false;
      if (type == 'rejected') return m['documentsVerified'] == false;
      return true;
    }).toList();

    if (filtered.isEmpty) return const Center(child: Text('لا توجد متاجر هنا', style: TextStyle(color: Colors.white54)));
    return RefreshIndicator(onRefresh: _load, color: Colors.amber, child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: filtered.length, itemBuilder: (ctx, i) => _buildCard(filtered[i])));
  }

  Widget _buildCard(Map<String, dynamic> m) {
    final isVerified = m['isVerified'] == true;
    final isActive = m['isActive'] == true;
    return Card(
      color: const Color(0xFF3D0018),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.store, color: isVerified ? (isActive ? Colors.green : Colors.red) : Colors.orange), const SizedBox(width: 8),
              Expanded(child: Text(m['name'] ?? 'بدون اسم', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
            ]),
            const SizedBox(height: 8),
            Text('📞 ${m['phone'] ?? ''}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            Text('🏷️ القسم: ${m['category'] ?? 'غير محدد'}', style: const TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              if (!isVerified) ...[
                ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () => _verify(m['_id'], 'accept'), icon: const Icon(Icons.check, size: 16, color: Colors.white), label: const Text('توثيق', style: TextStyle(color: Colors.white))),
                ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => _showActionDialog('سبب الرفض', 'اكتب سبب رفض المتجر...', (txt) => _verify(m['_id'], 'reject', reason: txt), isDanger: true), icon: const Icon(Icons.close, size: 16, color: Colors.white), label: const Text('رفض', style: TextStyle(color: Colors.white))),
              ],
              if (isVerified) ...[
                ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: isActive ? Colors.orange : Colors.green), onPressed: () => _toggleStatus(m['_id'], isActive), icon: Icon(isActive ? Icons.block : Icons.play_arrow, size: 16, color: Colors.white), label: Text(isActive ? 'إيقاف' : 'تشغيل', style: const TextStyle(color: Colors.white))),
                ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), onPressed: () => _showActionDialog('إرسال إنذار', 'اكتب نص الإنذار...', (txt) => _sendAlert(m['_id'], txt)), icon: const Icon(Icons.warning, size: 16, color: Colors.white), label: const Text('إنذار', style: TextStyle(color: Colors.white))),
                ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.purple), onPressed: () => _editCommission(m['_id'], m['commission']), icon: const Icon(Icons.percent, size: 16, color: Colors.white), label: const Text('العمولة', style: TextStyle(color: Colors.white))),
              ],
              ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade800), onPressed: () => _showPreview(m), icon: const Icon(Icons.visibility, size: 16, color: Colors.white), label: const Text('معاينة', style: TextStyle(color: Colors.white))),
              ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900), onPressed: () => _showActionDialog('تأكيد الحذف', 'هل أنت متأكد من حذف المتجر نهائياً؟', (txt) => _deleteMerchant(m['_id']), isDanger: true), icon: const Icon(Icons.delete, size: 16, color: Colors.white), label: const Text('حذف', style: TextStyle(color: Colors.white))),
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E000C),
      appBar: AppBar(
        title: const Text('إدارة المتاجر'),
        backgroundColor: const Color(0xFF3D0018),
        bottom: TabBar(
          controller: _tabController, isScrollable: true, indicatorColor: Colors.amber,
          tabs: const [Tab(text: 'الكل'), Tab(text: 'معلق'), Tab(text: 'نشط'), Tab(text: 'موقوف'), Tab(text: 'مرفوض')],
        ),
      ),
      body: Column(
        children: [
          _buildStats(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(hintText: 'بحث بالاسم أو الهاتف...', hintStyle: const TextStyle(color: Colors.white54), prefixIcon: const Icon(Icons.search, color: Colors.white54), filled: true, fillColor: const Color(0xFF3D0018), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 0)),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.amber)) : TabBarView(
              controller: _tabController,
              children: [_buildTabList('all'), _buildTabList('pending'), _buildTabList('active'), _buildTabList('inactive'), _buildTabList('rejected')],
            ),
          ),
        ],
      ),
    );
  }
}
