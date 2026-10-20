import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _governorateCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();
  String _gender = 'male';
  String? _profileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final res = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/users/me'),
        headers: {'Authorization': 'Bearer ${ApiService.authToken}'},
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          _nameCtrl.text = data['name'] ?? '';
          _emailCtrl.text = data['email'] ?? '';
          _governorateCtrl.text = data['governorate'] ?? '';
          _birthDateCtrl.text = data['birthDate'] ?? '';
          _gender = data['gender'] ?? 'male';
          _profileImage = data['profileImage'];
        });
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // تقليل الجودة والأبعاد لتجنب انهيار التطبيق
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 30, 
      maxWidth: 500, 
      maxHeight: 500
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _profileImage = base64Encode(bytes));
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.put(
        Uri.parse('${ApiService.baseUrl}/api/users/profile'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${ApiService.authToken}'},
        body: jsonEncode({
          'name': _nameCtrl.text,
          'email': _emailCtrl.text,
          'governorate': _governorateCtrl.text,
          'birthDate': _birthDateCtrl.text,
          'gender': _gender,
          'profileImage': _profileImage,
        }),
      );

      if (res.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التعديلات بنجاح!'), backgroundColor: Colors.green));
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء الحفظ'), backgroundColor: Colors.red));
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
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: const Color(0xFF3D0018),

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // الصورة الشخصية
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white24,
                    backgroundImage: _profileImage != null ? MemoryImage(base64Decode(_profileImage!.replaceFirst('data:image/png;base64,', '').replaceFirst('data:image/jpeg;base64,', ''))) : null,
                    child: _profileImage == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, size: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // الحقول
            _buildTextField(_nameCtrl, 'الاسم الكامل', Icons.person),
            _buildTextField(_emailCtrl, 'البريد الإلكتروني', Icons.email),
            _buildTextField(_governorateCtrl, 'المحافظة', Icons.location_city),
            _buildTextField(_birthDateCtrl, 'تاريخ الميلاد (YYYY-MM-DD)', Icons.calendar_today),
            
            // الجنس
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xFF3D0018), borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _gender,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF3D0018),
                  style: GoogleFonts.cairo(color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('ذكر')),
                    DropdownMenuItem(value: 'female', child: Text('أنثى')),
                  ],
                  onChanged: (val) => setState(() => _gender = val!),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('حفظ التعديلات', style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        style: GoogleFonts.cairo(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.cairo(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.amber),
          filled: true,
          fillColor: const Color(0xFF3D0018),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
