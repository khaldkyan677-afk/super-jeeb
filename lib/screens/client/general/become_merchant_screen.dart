// become_merchant_screen.dart - Full Wizard
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../../../services/api_service.dart';
import 'package:http/http.dart' as http;

class BecomeMerchantScreen extends StatefulWidget {
  const BecomeMerchantScreen({super.key});
  @override
  State<BecomeMerchantScreen> createState() => _S();
}

class _S extends State<BecomeMerchantScreen> {
  int step = 0;
  bool loading = false;
  bool submitting = false;
  List<Map<String, dynamic>> sections = [];

  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final govCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  final mapCtrl = TextEditingController();
  final hoursCtrl = TextEditingController();

  String? selectedSectionId;
  String? selectedSectionName;
  String? selectedSub;

  Uint8List? logoBytes;
  Uint8List? coverBytes;

  static const Map<String, List<Map<String, String>>> subs = {
    'سوبرماركت': [
      {'n': 'خضار وفواكه', 'i': '🥬'}, {'n': 'ألبان وأجبان', 'i': '🥛'},
      {'n': 'معلبات', 'i': '🥫'}, {'n': 'مشروبات', 'i': '🥤'},
      {'n': 'لحوم ودواجن', 'i': '🍗'}, {'n': 'مخبوزات', 'i': '🥖'},
    ],
    'مطاعم': [
      {'n': 'وجبات سريعة', 'i': '🍔'}, {'n': 'مشويات', 'i': '🍖'},
      {'n': 'حلويات', 'i': '🍰'}, {'n': 'فطور', 'i': '🥞'},
      {'n': 'عصائر', 'i': '🧃'}, {'n': 'بحري', 'i': '🐟'},
    ],
    'متاجر': [
      {'n': 'ملابس', 'i': '👕'}, {'n': 'إلكترونيات', 'i': '📱'},
      {'n': 'ألعاب', 'i': '🎮'}, {'n': 'عطور', 'i': '🌸'},
      {'n': 'أحذية', 'i': '👟'}, {'n': 'حقائب', 'i': '👜'},
    ],
    'صيدليات': [
      {'n': 'أدوية', 'i': '💊'}, {'n': 'عناية شخصية', 'i': '🧴'},
      {'n': 'تجميل', 'i': '💄'}, {'n': 'مكملات', 'i': '💪'},
      {'n': 'أطفال', 'i': '🍼'}, {'n': 'طبية', 'i': '🩺'},
    ],
    'بقالات': [
      {'n': 'مواد غذائية', 'i': '🍚'}, {'n': 'مشروبات', 'i': '🥤'},
      {'n': 'منظفات', 'i': '🧼'}, {'n': 'سناكس', 'i': '🍿'},
      {'n': 'بقوليات', 'i': '🫘'}, {'n': 'توابل', 'i': '🧂'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    try {
      final r = await http.get(Uri.parse(ApiService.baseUrl + '/api/sections'));
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body);
        if (data is List) {
          setState(() => sections = data.map((e) => Map<String, dynamic>.from(e)).toList());
        }
      }
    } catch (e) {
      debugPrint('loadSections: ' + e.toString());
    }
  }

  Future<void> _pickImage(bool isLogo) async {
    final p = ImagePicker();
    final x = await p.pickImage(source: ImageSource.gallery, imageQuality: 60, maxWidth: 1000);
    if (x == null) return;
    final b = await x.readAsBytes();
    setState(() {
      if (isLogo) { logoBytes = b; } else { coverBytes = b; }
    });
  }

  String? _toBase64(Uint8List? b) {
    if (b == null) return null;
    return 'data:image/jpeg;base64,' + base64Encode(b);
  }

  bool _canNext() {
    if (step == 0) return nameCtrl.text.trim().isNotEmpty;
    if (step == 1) return selectedSectionId != null && selectedSub != null;
    if (step == 2) return phoneCtrl.text.trim().isNotEmpty;
    return true;
  }

  Future<void> _submit() async {
    setState(() => submitting = true);
    try {
      final body = {
        'storeName': nameCtrl.text.trim(),
        'description': descCtrl.text.trim(),
        'category': selectedSectionName ?? '',
        'subCategory': selectedSub ?? '',
        'sectionId': selectedSectionId,
        'phone': phoneCtrl.text.trim(),
        'address': [govCtrl.text, cityCtrl.text, addrCtrl.text].where((s) => s.trim().isNotEmpty).join(' - '),
        'location': {'lat': 0, 'lng': 0, 'address': addrCtrl.text.trim()},
        'mapUrl': mapCtrl.text.trim(),
        'workingHours': hoursCtrl.text.trim(),
        'logoUrl': _toBase64(logoBytes),
        'coverUrl': _toBase64(coverBytes),
        'image': _toBase64(logoBytes),
      };
      final r = await http.post(
        Uri.parse(ApiService.baseUrl + '/api/merchants'),
        headers: {'Content-Type': 'application/json', if (ApiService.authToken != null) 'Authorization': 'Bearer ' + ApiService.authToken!},
        body: jsonEncode(body),
      );
      if (!mounted) return;
      setState(() => submitting = false);
      if (r.statusCode == 200 || r.statusCode == 201) {
        _showSuccess();
      } else {
        _snack('فشل الإرسال، حاول مرة أخرى');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => submitting = false);
      _snack('حدث خطأ: ' + e.toString());
    }
  }

  void _snack(String s) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(s, style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: const Color(0xFF25D366)));

  void _showSuccess() {
    showDialog(context: context, barrierDismissible: false, builder: (c) => AlertDialog(
      backgroundColor: const Color(0xFF1A1B26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(children: [
        const Icon(Icons.check_circle, color: Color(0xFF25D366), size: 32),
        const SizedBox(width: 10),
        Text('تم الإرسال!', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
      ]),
      content: Text('طلبك قيد المراجعة من الإدارة. سيتم إشعارك بعد الموافقة.',
        style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14)),
      actions: [TextButton(
        onPressed: () { Navigator.of(c).pop(); Navigator.of(context).pop(); },
        child: Text('حسناً', style: GoogleFonts.cairo(color: const Color(0xFF25D366), fontWeight: FontWeight.bold)))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D12),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text('إعداد متجرك', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(children: [
        _stepper(),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: _stepBody())),
        _bottomBar(),
      ]),
    );
  }

  Widget _stepper() {
    final titles = ['الهوية', 'النشاط', 'التواصل', 'الإطلاق'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(children: List.generate(4, (i) {
        final active = i <= step;
        return Expanded(child: Column(children: [
          Row(children: [
            if (i > 0) Expanded(child: Container(height: 3, color: active ? const Color(0xFFEF7E3C) : Colors.white24)),
            Container(width: 30, height: 30,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: active ? const Color(0xFFEF7E3C) : const Color(0xFF1A1B26)),
              child: Icon(i < step ? Icons.check : [Icons.storefront, Icons.category, Icons.phone, Icons.rocket_launch][i],
                color: Colors.white, size: 16)),
            if (i < 3) Expanded(child: Container(height: 3, color: i < step ? const Color(0xFFEF7E3C) : Colors.white24)),
          ]),
          const SizedBox(height: 6),
          Text(titles[i], style: GoogleFonts.cairo(color: active ? Colors.white : Colors.grey, fontSize: 11)),
        ]));
      })),
    );
  }

  Widget _stepBody() {
    if (step == 0) return _step1();
    if (step == 1) return _step2();
    if (step == 2) return _step3();
    return _step4();
  }

  Widget _step1() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _title('هوية المتجر', 'قم بإعداد اسم متجرك ووصفه'),
    const SizedBox(height: 20),
    _field('اسم المتجر *', nameCtrl),
    _field('وصف المتجر (اختياري)', descCtrl, max: 3),
    const SizedBox(height: 16),
    Text('شعار المتجر', style: GoogleFonts.cairo(color: Colors.white, fontSize: 13)),
    const SizedBox(height: 8),
    Row(children: [
      _imgBox('الشعار', logoBytes, () => _pickImage(true)),
      const SizedBox(width: 12),
      _imgBox('الغلاف', coverBytes, () => _pickImage(false)),
    ]),
  ]);

  Widget _step2() {
    final subList = selectedSectionName != null ? (subs[selectedSectionName!] ?? []) : <Map<String, String>>[];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _title('نشاط العمل', 'ما نوع المنتجات التي يبيعها متجرك؟'),
      const SizedBox(height: 16),
      if (sections.isEmpty)
        const Center(child: CircularProgressIndicator(color: Color(0xFFEF7E3C)))
      else
        Wrap(spacing: 10, runSpacing: 10, children: sections.map((s) {
          final id = s['_id']?.toString() ?? '';
          final nm = s['name']?.toString() ?? '';
          final sel = selectedSectionId == id;
          return GestureDetector(
            onTap: () => setState(() { selectedSectionId = id; selectedSectionName = nm; selectedSub = null; }),
            child: Container(width: 100, padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFFEF7E3C).withOpacity(0.15) : const Color(0xFF1A1B26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: sel ? const Color(0xFFEF7E3C) : Colors.transparent, width: 2)),
              child: Column(children: [
                Text(s['iconName']?.toString() ?? '🏪', style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 8),
                Text(nm, textAlign: TextAlign.center, style: GoogleFonts.cairo(color: Colors.white, fontSize: 12)),
              ])));
        }).toList()),
      if (selectedSectionId != null && subList.isNotEmpty) ...[
        const SizedBox(height: 24),
        Text('التخصص الدقيق *', style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: subList.map((s) {
          final sel = selectedSub == s['n'];
          return GestureDetector(
            onTap: () => setState(() => selectedSub = s['n']),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFFEF7E3C) : const Color(0xFF1A1B26),
                borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(s['i']!, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(s['n']!, style: GoogleFonts.cairo(color: Colors.white, fontSize: 12)),
              ])));
        }).toList()),
      ],
    ]);
  }

  Widget _step3() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _title('معلومات التواصل', 'أضف معلومات التواصل الخاصة بمتجرك'),
    const SizedBox(height: 20),
    _field('رقم الهاتف *', phoneCtrl, type: TextInputType.phone),
    _field('المحافظة', govCtrl),
    _field('المدينة / المنطقة', cityCtrl),
    _field('العنوان التفصيلي', addrCtrl, max: 2),
    _field('رابط الموقع على الخريطة', mapCtrl, type: TextInputType.url),
    _field('ساعات العمل', hoursCtrl),
  ]);

  Widget _step4() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _title('جاهز للإطلاق!', 'راجع تفاصيل متجرك قبل الإرسال'),
    const SizedBox(height: 20),
    _reviewRow(Icons.storefront, 'اسم المتجر', nameCtrl.text),
    _reviewRow(Icons.category, 'القسم', selectedSectionName ?? '-'),
    _reviewRow(Icons.local_offer, 'التخصص', selectedSub ?? '-'),
    _reviewRow(Icons.phone, 'الهاتف', phoneCtrl.text),
    _reviewRow(Icons.location_on, 'العنوان', [govCtrl.text, cityCtrl.text, addrCtrl.text].where((s) => s.isNotEmpty).join(' - ')),
    _reviewRow(Icons.access_time, 'ساعات العمل', hoursCtrl.text.isEmpty ? '-' : hoursCtrl.text),
    const SizedBox(height: 24),
    Container(padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF25D366).withOpacity(0.1), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF25D366).withOpacity(0.3))),
      child: Row(children: [
        const Icon(Icons.info_outline, color: Color(0xFF25D366)),
        const SizedBox(width: 10),
        Expanded(child: Text('سيتم مراجعة طلبك من الإدارة وسيُفعّل متجرك بعد الموافقة.',
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 12))),
      ])),
  ]);

  Widget _title(String t, String s) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(t, style: GoogleFonts.cairo(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
    const SizedBox(height: 4),
    Text(s, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
  ]);

  Widget _field(String h, TextEditingController c, {TextInputType? type, int max = 1}) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(controller: c, keyboardType: type, maxLines: max, textAlign: TextAlign.right,
      style: GoogleFonts.cairo(color: Colors.white),
      decoration: InputDecoration(hintText: h, hintStyle: GoogleFonts.cairo(color: Colors.grey, fontSize: 13),
        filled: true, fillColor: const Color(0xFF1A1B26),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(14)),
      onChanged: (_) => setState(() {})));

  Widget _imgBox(String label, Uint8List? b, VoidCallback onTap) => Expanded(
    child: GestureDetector(onTap: onTap, child: Container(height: 120,
      decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, style: BorderStyle.solid)),
      child: b != null ? ClipRRect(borderRadius: BorderRadius.circular(12),
        child: Image.memory(b, fit: BoxFit.cover)) :
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.add_photo_alternate_outlined, color: Colors.grey, size: 32),
          const SizedBox(height: 6),
          Text(label, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
        ]))));

  Widget _reviewRow(IconData i, String l, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Icon(i, color: const Color(0xFFEF7E3C), size: 20),
      const SizedBox(width: 10),
      Text(l + ': ', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
      Expanded(child: Text(v.isEmpty ? '-' : v, textAlign: TextAlign.right,
        style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600))),
    ]));

  Widget _bottomBar() => Container(padding: const EdgeInsets.all(16),
    child: Row(children: [
      if (step > 0) Expanded(child: OutlinedButton(
        onPressed: () => setState(() => step--),
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Colors.white24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: Text('السابق', style: GoogleFonts.cairo(color: Colors.white)))),
      if (step > 0) const SizedBox(width: 12),
      Expanded(flex: 2, child: ElevatedButton(
        onPressed: (!_canNext() || submitting) ? null : () {
          if (step == 3) { _submit(); } else { setState(() => step++); }
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF7E3C),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: Colors.grey.shade800),
        child: submitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) :
          Text(step == 3 ? 'إرسال للمراجعة' : 'التالي', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)))),
    ]));
}
