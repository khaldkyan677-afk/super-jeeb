import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BecomeDriverScreen extends StatefulWidget {
  const BecomeDriverScreen({super.key});

  @override
  State<BecomeDriverScreen> createState() => _BecomeDriverScreenState();
}

class _BecomeDriverScreenState extends State<BecomeDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _nationalIdCtrl = TextEditingController();
  final _vehicleModelCtrl = TextEditingController();
  final _plateNumberCtrl = TextEditingController();
  String _vehicleType = 'دراجة نارية';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E000C),
      appBar: AppBar(
        title: const Text('انضم كمندوب'),
        backgroundColor: const Color(0xFF3D0018),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'املأ بياناتك للانضمام إلى فريق المناديب',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              _sectionTitle('البيانات الشخصية'),
              _buildTextField(_nameCtrl, 'الاسم الكامل'),
              _buildTextField(_nationalIdCtrl, 'الرقم الوطني / رقم البطاقة', isNumber: true),
              const SizedBox(height: 24),
              _sectionTitle('بيانات المركبة'),
              DropdownButtonFormField<String>(
                value: _vehicleType,
                dropdownColor: const Color(0xFF3D0018),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('نوع المركبة'),
                items: ['دراجة نارية', 'سيارة', 'أخرى'].map((String val) {
                  return DropdownMenuItem(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) => setState(() => _vehicleType = val!),
              ),
              const SizedBox(height: 12),
              _buildTextField(_vehicleModelCtrl, 'موديل المركبة (مثال: هوندا 2020)'),
              _buildTextField(_plateNumberCtrl, 'رقم اللوحة'),
              const SizedBox(height: 24),
              _sectionTitle('الوثائق المطلوبة'),
              _buildUploadBox('صورة البطاقة الشخصية'),
              _buildUploadBox('صورة رخصة القيادة'),
              _buildUploadBox('صورة استمارة المركبة'),
              _buildUploadBox('صورة المركبة (أمامية)'),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إرسال طلبك بنجاح! قيد المراجعة.'), backgroundColor: Colors.green),
                      );
                    }
                  },
                  child: const Text('إرسال الطلب', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(label),
        validator: (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF3D0018),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  Widget _buildUploadBox(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3D0018),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const Icon(Icons.upload_file, color: Colors.blueAccent),
        ],
      ),
    );
  }
}
