import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';

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
  bool _isLoading = false;

  String? _nationalIdImg;
  String? _licenseImg;
  String? _registrationImg;
  String? _vehiclePhotoImg;

  Future<void> _pickImage(String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        if (type == 'nationalId') _nationalIdImg = base64Encode(bytes);
        if (type == 'license') _licenseImg = base64Encode(bytes);
        if (type == 'registration') _registrationImg = base64Encode(bytes);
        if (type == 'vehiclePhoto') _vehiclePhotoImg = base64Encode(bytes);
      });
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_nationalIdImg == null || _licenseImg == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى رفع صورة البطاقة ورخصة القيادة على الأقل'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final res = await http.post(
        Uri.parse('${ApiService.baseUrl}/api/users/apply-driver'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${ApiService.authToken}'},
        body: jsonEncode({
          'name': _nameCtrl.text,
          'nationalId': _nationalIdCtrl.text,
          'vehicleType': _vehicleType,
          'vehicleModel': _vehicleModelCtrl.text,
          'plateNumber': _plateNumberCtrl.text,
          'docNationalId': _nationalIdImg,
          'docLicense': _licenseImg,
          'docRegistration': _registrationImg,
          'docVehiclePhoto': _vehiclePhotoImg,
        }),
      );

      if (res.statusCode == 200) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              backgroundColor: const Color(0xFF1E000C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 32),
                  const SizedBox(width: 10),
                  Text('تم الإرسال', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Text(
                'تم إرسال طلبك بنجاح! طلبك قيد المراجعة من قبل الإدارة، وسيتم إشعارك فور القبول.',
                style: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx); // إغلاق النافذة
                    Navigator.pop(context, true); // العودة لواجهة العميل
                  },
                  child: Text('حسناً', style: GoogleFonts.cairo(color: Colors.green, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          );
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء الإرسال'), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E000C),
      appBar: AppBar(title: const Text('انضم كمندوب'), backgroundColor: const Color(0xFF3D0018)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('البيانات الشخصية'),
              _buildTextField(_nameCtrl, 'الاسم الكامل'),
              _buildTextField(_nationalIdCtrl, 'الرقم الوطني', isNumber: true),
              const SizedBox(height: 16),
              _sectionTitle('بيانات المركبة'),
              DropdownButtonFormField<String>(
                value: _vehicleType,
                dropdownColor: const Color(0xFF3D0018),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('نوع المركبة'),
                items: ['دراجة نارية', 'سيارة', 'أخرى'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                onChanged: (val) => setState(() => _vehicleType = val!),
              ),
              const SizedBox(height: 12),
              _buildTextField(_vehicleModelCtrl, 'موديل المركبة'),
              _buildTextField(_plateNumberCtrl, 'رقم اللوحة'),
              const SizedBox(height: 16),
              _sectionTitle('الوثائق المطلوبة'),
              _buildUploadBox('صورة البطاقة الشخصية', _nationalIdImg, () => _pickImage('nationalId')),
              _buildUploadBox('صورة رخصة القيادة', _licenseImg, () => _pickImage('license')),
              _buildUploadBox('صورة استمارة المركبة', _registrationImg, () => _pickImage('registration')),
              _buildUploadBox('صورة المركبة (أمامية)', _vehiclePhotoImg, () => _pickImage('vehiclePhoto')),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: _isLoading ? null : _submitRequest,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text('إرسال الطلب', style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: GoogleFonts.cairo(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)));

  Widget _buildTextField(TextEditingController ctrl, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl, keyboardType: isNumber ? TextInputType.number : TextInputType.text, style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(label), validator: (v) => (v == null || v.isEmpty) ? 'مطلوب' : null,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(labelText: label, labelStyle: const TextStyle(color: Colors.white54), filled: true, fillColor: const Color(0xFF3D0018), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none));

  Widget _buildUploadBox(String title, String? img, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF3D0018), borderRadius: BorderRadius.circular(12), border: Border.all(color: img != null ? Colors.green : Colors.white24)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: GoogleFonts.cairo(color: img != null ? Colors.green : Colors.white70)),
            Icon(img != null ? Icons.check_circle : Icons.upload_file, color: img != null ? Colors.green : Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}
