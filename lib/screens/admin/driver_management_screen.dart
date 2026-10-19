import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({super.key});

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen> {
  List<dynamic> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/admins/drivers/applications'),
        headers: {'Authorization': 'Bearer ${ApiService.authToken}'},
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() => _applications = data['drivers'] ?? []);
      }
    } catch (e) {
      debugPrint('Error loading drivers: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyDriver(String id, String action, {String reason = ''}) async {
    try {
      final res = await http.put(
        Uri.parse('${ApiService.baseUrl}/api/admins/drivers/$id/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiService.authToken}'
        },
        body: jsonEncode({'action': action, 'reason': reason}),
      );
      if (res.statusCode == 200) {
        _loadApplications();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(action == 'accept' ? 'تم قبول المندوب بنجاح' : 'تم رفض طلب المندوب'),
            backgroundColor: action == 'accept' ? Colors.green : Colors.red,
          ));
        }
      }
    } catch (e) {
      debugPrint('Error verifying driver: $e');
    }
  }

  void _showRejectDialog(String id) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF3D0018),
        title: const Text('سبب الرفض', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'اكتب سبب الرفض...', hintStyle: TextStyle(color: Colors.white54)),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _verifyDriver(id, 'reject', reason: ctrl.text);
            },
            child: const Text('تأكيد الرفض', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDocumentsDialog(Map<String, dynamic> app) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E000C),
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('وثائق المندوب: ${app['name']}', style: GoogleFonts.cairo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDocPreview('البطاقة الشخصية', app['docNationalId']),
            _buildDocPreview('رخصة القيادة', app['docLicense']),
            _buildDocPreview('استمارة المركبة', app['docRegistration']),
            _buildDocPreview('صورة المركبة', app['docVehiclePhoto']),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDocPreview(String title, String? base64Str) {
    if (base64Str == null || base64Str.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text('$title: غير مرفوعة', style: const TextStyle(color: Colors.redAccent)),
      );
    }
    try {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(base64Decode(base64Str), height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
          ],
        ),
      );
    } catch (e) {
      return Text('$title: خطأ في عرض الصورة', style: const TextStyle(color: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E000C),
      appBar: AppBar(
        title: const Text('طلبات المناديب'),
        backgroundColor: const Color(0xFF3D0018),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _applications.isEmpty
              ? const Center(child: Text('لا توجد طلبات مناديب جديدة', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _applications.length,
                  itemBuilder: (ctx, i) {
                    final app = _applications[i];
                    return Card(
                      color: const Color(0xFF3D0018),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.delivery_dining, color: Colors.amber),
                                const SizedBox(width: 8),
                                Expanded(child: Text(app['name'] ?? 'بدون اسم', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('📞 ${app['phone'] ?? ''}', style: const TextStyle(color: Colors.white70)),
                            Text('🚗 نوع المركبة: ${app['vehicleType'] ?? 'غير محدد'}', style: const TextStyle(color: Colors.white70)),
                            Text('🔢 موديل المركبة: ${app['vehicleModel'] ?? ''}', style: const TextStyle(color: Colors.white70)),
                            Text('🔤 رقم اللوحة: ${app['plateNumber'] ?? ''}', style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, minimumSize: const Size(double.infinity, 40)),
                              onPressed: () => _showDocumentsDialog(app),
                              icon: const Icon(Icons.folder_open, size: 18, color: Colors.white),
                              label: const Text('معاينة الوثائق المرفقة', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    onPressed: () => _verifyDriver(app['_id'], 'accept'),
                                    icon: const Icon(Icons.check, size: 16, color: Colors.white),
                                    label: const Text('قبول', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    onPressed: () => _showRejectDialog(app['_id']),
                                    icon: const Icon(Icons.close, size: 16, color: Colors.white),
                                    label: const Text('رفض', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
