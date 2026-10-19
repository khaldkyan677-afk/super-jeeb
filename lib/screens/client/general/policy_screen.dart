import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';

class PolicyScreen extends StatefulWidget {
  final String type; // 'terms' or 'privacy'
  const PolicyScreen({super.key, required this.type});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  String _content = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPolicy();
  }

  Future<void> _loadPolicy() async {
    try {
      final res = await http.get(Uri.parse('${ApiService.baseUrl}/api/policies/client/${widget.type}'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() => _content = data['content'] ?? 'لا يوجد نص متاح حالياً.');
      } else {
        setState(() => _content = 'حدث خطأ أثناء تحميل النص.');
      }
    } catch (e) {
      setState(() => _content = 'تعذر الاتصال بالسيرفر.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E000C),
      appBar: AppBar(
        title: Text(widget.type == 'terms' ? 'الشروط والأحكام' : 'سياسة الخصوصية'),
        backgroundColor: const Color(0xFF3D0018),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                _content,
                style: GoogleFonts.cairo(color: Colors.white70, fontSize: 16, height: 1.8),
              ),
            ),
    );
  }
}
