import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../services/api_service.dart';

class BecomeMerchantScreen extends StatefulWidget {
  const BecomeMerchantScreen({super.key});
  @override
  State<BecomeMerchantScreen> createState() => _S();
}

class _S extends State<BecomeMerchantScreen> {
  int step = 0;
  bool sectionsLoading = true;
  bool submitting = false;
  List<Map<String, dynamic>> sections = [];

  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  final mapCtrl = TextEditingController();
  final hoursCtrl = TextEditingController();
  final otherSubCtrl = TextEditingController();

  String? selectedSectionId;
  String? selectedSectionName;
  String? selectedSub;
  String? selectedGov;
  bool isOtherSelected = false;

  Uint8List? logoBytes;
  Uint8List? coverBytes;

  static const List<String> govs = [
    'أمانة العاصمة', 'صنعاء', 'عدن', 'تعز', 'الحديدة', 'حضرموت',
    'إب', 'لحج', 'أبين', 'شبوة', 'المهرة', 'مأرب', 'الجوف',
    'صعدة', 'حجة', 'المحويت', 'ريمة', 'الضالع', 'البيضاء', 'ذمار',
    'عمران', 'سقطرى'
  ];

  static const Map<String, List<Map<String, String>>> subs = {
    'مطاعم': [
      {'n': 'مطعم بروست', 'i': '🍗'}, {'n': 'مطعم سمك', 'i': '🐟'},
      {'n': 'مطعم شعبي', 'i': '🍲'}, {'n': 'كافتيريا', 'i': '🍽️'},
      {'n': 'كافيه', 'i': '☕'}, {'n': 'مشويات', 'i': '🍖'},
      {'n': 'وجبات سريعة', 'i': '🍔'}, {'n': 'حلويات', 'i': '🍰'},
      {'n': 'فطور', 'i': '🥞'}, {'n': 'بيتزا', 'i': '🍕'},
      {'n': 'شاورما', 'i': '🌯'}, {'n': 'بحري', 'i': '🦐'},
    ],
    'متاجر': [
      {'n': 'إلكترونيات', 'i': '📱'}, {'n': 'ملابس رجالية', 'i': '👔'},
      {'n': 'ملابس نسائية', 'i': '👗'}, {'n': 'ملابس ولادية', 'i': '👶'},
      {'n': 'ملابس بناتية', 'i': '👚'}, {'n': 'عطور', 'i': '🌸'},
      {'n': 'عبايات', 'i': '🧕'}, {'n': 'إكسسوارات', 'i': '💍'},
      {'n': 'تجميل وعناية', 'i': '💄'}, {'n': 'أحذية', 'i': '👟'},
      {'n': 'مكسرات', 'i': '🥜'}, {'n': 'أقمشة', 'i': '🧵'},
    ],
    'بقالات': [
      {'n': 'مواد غذائية', 'i': '🍚'}, {'n': 'خضار وفواكه', 'i': '🥬'},
    ],
    'صيدليات': [
      {'n': 'أدوية', 'i': '💊'}, {'n': 'عناية شخصية', 'i': '🧴'},
      {'n': 'تجميل', 'i': '💄'}, {'n': 'مكملات غذائية', 'i': '💪'},
      {'n': 'مستلزمات أطفال', 'i': '🍼'}, {'n': 'أجهزة طبية', 'i': '🩺'},
    ],
  };

  String _sectionEmoji(String name) {
    if (name.contains('سوبر')) return '🛒';
    if (name.contains('مطاعم') || name.contains('مطعم')) return '🍔';
    if (name.contains('متاجر') || name.contains('متجر')) return '🛍️';
    if (name.contains('صيدل')) return '💊';
    if (name.contains('بقال')) return '🏪';
    return '🏪';
  }

  final _subsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    try {
      final r = await http.get(Uri.parse('\${ApiService.baseUrl}/api/sections'));
      if (r.statusCode == 200) {
        final d = jsonDecode(r.body);
        if (d is List) {
          setState(() {
            sections = d.map((e) => Map<String, dynamic>.from(e)).toList();
            sectionsLoading = false;
          });
          return;
        }
      }
    } catch (_) {}
    if (mounted) setState(() => sectionsLoading = false);
  }

  Future<void> _pick(bool isLogo) async {
    final p = ImagePicker();
    final x = await p.pickImage(source: ImageSource.gallery, imageQuality: 60, maxWidth: 1000);
    if (x == null) return;
    final b = await x.readAsBytes();
    if (!mounted) return;
    setState(() { if (isLogo) { logoBytes = b; } else { coverBytes = b; } });
  }

  String? _b64(Uint8List? b) => b == null ? null : 'data:image/jpeg;base64,\${base64Encode(b)}';

  bool _validPhone(String p) {
    final t = p.trim();
    if (t.length < 9) return false;
    return ['70', '71', '73', '77', '78'].contains(t.substring(0, 2));
  }

  bool _canNext() {
    if (step == 0) return nameCtrl.text.trim().length >= 3;
    if (step == 1) {
      if (selectedSectionId == null) return false;
      if (selectedSectionName != null && selectedSectionName!.contains('سوبر')) return true;
      if (isOtherSelected) return otherSubCtrl.text.trim().isNotEmpty;
      return selectedSub != null;
    }
    if (step == 2) return _validPhone(phoneCtrl.text) && selectedGov != null;
    return true;
  }

  Future<void> _submit() async {
    setState(() => submitting = true);
    try {
      final body = {
        'storeName': nameCtrl.text.trim(),
        'description': descCtrl.text.trim(),
        'category': selectedSectionName ?? '',
        'subCategory': isOtherSelected ? otherSubCtrl.text.trim() : (selectedSub ?? ''),
        'sectionId': selectedSectionId,
        'phone': phoneCtrl.text.trim(),
        'address': [selectedGov ?? '', cityCtrl.text, addrCtrl.text].where((s) => s.isNotEmpty).join(' - '),
        'location': {'lat': 0, 'lng': 0, 'address': addrCtrl.text.trim()},
        'mapUrl': mapCtrl.text.trim(),
        'workingHours': hoursCtrl.text.trim(),
        'logoUrl': _b64(logoBytes),
        'coverUrl': _b64(coverBytes),
        'image': _b64(logoBytes),
      };
      final r = await http.post(
        Uri.parse('\${ApiService.baseUrl}/api/merchants'),
        headers: {
          'Content-Type': 'application/json',
          if (ApiService.authToken != null) 'Authorization': 'Bearer \${ApiService.authToken!}',
        },
        body: jsonEncode(body),
      );
      if (!mounted) return;
      setState(() => submitting = false);
      if (r.statusCode == 200 || r.statusCode == 201) {
        _success();
      } else {
        _snack('فشل الإرسال: \${r.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => submitting = false);
      _snack('خطأ: \${e.toString()}');
    }
  }

  void _snack(String s) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(s, style: GoogleFonts.cairo(color: Colors.white)), backgroundColor: const Color(0xFF25D366)));

  void _success() {
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
        backgroundColor: const Color(0xFF0D0D12), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text('إعداد متجرك', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(children: [
        _stepper(),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: _body())),
        _bottomBar(),
      ]),
    );
  }

  Widget _stepper() {
    final titles = ['الهوية', 'النشاط', 'التواصل', 'الإطلاق'];
    return Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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

  Widget _body() {
    if (step == 0) return _s1();
    if (step == 1) return _s2();
    if (step == 2) return _s3();
    return _s4();
  }

  Widget _s1() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _title('هوية المتجر', 'قم بإعداد اسم متجرك ووصفه'),
    const SizedBox(height: 20),
    _field('اسم المتجر *', nameCtrl),
    _field('وصف المتجر (اختياري)', descCtrl, max: 3),
    const SizedBox(height: 16),
    Text('شعار وغلاف المتجر', style: GoogleFonts.cairo(color: Colors.white, fontSize: 13)),
    const SizedBox(height: 8),
    Row(children: [
      _imgBox('الشعار', logoBytes, () => _pick(true)),
      const SizedBox(width: 12),
      _imgBox('الغلاف', coverBytes, () => _pick(false)),
    ]),
  ]);

  Widget _s2() {
    final sl = selectedSectionName != null ? (subs[selectedSectionName!] ?? []) : <Map<String, String>>[];
    final need = selectedSectionName != null && !selectedSectionName!.contains('سوبر');
    if (sectionsLoading) {
      return Column(children: [
        _title('نشاط العمل', 'جاري التحميل...'),
        const SizedBox(height: 30),
        const Center(child: CircularProgressIndicator(color: Color(0xFFEF7E3C))),
      ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _title('نشاط العمل', 'اختر نوع المتجر'),
      const SizedBox(height: 16),
      GridView.count(
        crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.4,
        children: sections.map((s) {
          final id = s['_id']?.toString() ?? '';
          final nm = s['name']?.toString() ?? '';
          final sel = selectedSectionId == id;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedSectionId = id; selectedSectionName = nm;
                selectedSub = null; isOtherSelected = false; otherSubCtrl.clear();
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final ctx = _subsKey.currentContext;
                if (ctx != null) Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFFEF7E3C).withValues(alpha: 0.2) : const Color(0xFF1A1B26),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: sel ? const Color(0xFFEF7E3C) : Colors.white12, width: 2),
                boxShadow: sel ? [BoxShadow(color: const Color(0xFFEF7E3C).withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, -4))] : [],
              ),
              child: Row(children: [
                Text(_sectionEmoji(nm), style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 10),
                Expanded(child: Text(nm, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                if (sel) const Icon(Icons.check_circle, color: Color(0xFFEF7E3C), size: 20),
              ]),
            ),
          );
        }).toList()),
      if (selectedSectionId != null && need) ...[
        const SizedBox(height: 20),
        Text('التخصص الدقيق *', key: _subsKey, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.8,
          children: [
            ...sl.map((s) {
              final sel = selectedSub == s['n'] && !isOtherSelected;
              return GestureDetector(
                onTap: () => setState(() { selectedSub = s['n']; isOtherSelected = false; }),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFFEF7E3C) : const Color(0xFF1A1B26),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: sel ? const Color(0xFFEF7E3C) : Colors.white12)),
                  child: Row(children: [
                    Text(s['i']!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Expanded(child: Text(s['n']!, style: GoogleFonts.cairo(color: Colors.white, fontSize: 11), overflow: TextOverflow.ellipsis)),
                  ])));
            }),
            GestureDetector(
              onTap: () => setState(() { isOtherSelected = true; selectedSub = '__other__'; }),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isOtherSelected ? const Color(0xFFEF7E3C) : const Color(0xFF1A1B26),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isOtherSelected ? const Color(0xFFEF7E3C) : Colors.white12)),
                child: Row(children: [
                  const Icon(Icons.add_circle_outline, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text('أخرى', style: GoogleFonts.cairo(color: Colors.white, fontSize: 11))),
                ]))),
          ]),
        if (isOtherSelected) ...[
          const SizedBox(height: 14),
          TextField(controller: otherSubCtrl, textAlign: TextAlign.right,
            style: GoogleFonts.cairo(color: Colors.white),
            decoration: InputDecoration(hintText: 'اكتب نوع متجرك', hintStyle: GoogleFonts.cairo(color: Colors.grey, fontSize: 13),
              filled: true, fillColor: const Color(0xFF1A1B26),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(14)),
            onChanged: (_) => setState(() {})),
        ],
      ],
    ]);
  }

  Widget _s3() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _title('معلومات التواصل', 'أضف بيانات التواصل الخاصة بمتجرك'),
    const SizedBox(height: 20),
    _field('رقم الهاتف * (مثال: 73xxxxxxx)', phoneCtrl, type: TextInputType.phone),
    if (phoneCtrl.text.isNotEmpty && !_validPhone(phoneCtrl.text))
      Padding(padding: const EdgeInsets.only(bottom: 12),
        child: Text('الرقم يجب أن يبدأ بـ 73/77/78/71/70', style: GoogleFonts.cairo(color: Colors.redAccent, fontSize: 11))),
    Padding(padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        initialValue: selectedGov,
        dropdownColor: const Color(0xFF1A1B26),
        style: GoogleFonts.cairo(color: Colors.white),
        decoration: InputDecoration(filled: true, fillColor: const Color(0xFF1A1B26),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.all(14),
          hintText: 'المحافظة *', hintStyle: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
        items: govs.map((g) => DropdownMenuItem(value: g, child: Text(g, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13)))).toList(),
        onChanged: (v) => setState(() => selectedGov = v),
      )),
    _field('المدينة / المنطقة', cityCtrl),
    _field('العنوان التفصيلي', addrCtrl, max: 2),
    _field('رابط الموقع (خريطة)', mapCtrl, type: TextInputType.url),
    _field('ساعات العمل', hoursCtrl),
  ]);

  Widget _s4() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _title('جاهز للإرسال!', 'راجع التفاصيل قبل الإرسال للإدارة'),
    const SizedBox(height: 20),
    if (logoBytes != null || coverBytes != null)
      Row(children: [
        if (logoBytes != null) Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(12),
          child: Image.memory(logoBytes!, height: 100, fit: BoxFit.cover))),
        if (logoBytes != null && coverBytes != null) const SizedBox(width: 10),
        if (coverBytes != null) Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(12),
          child: Image.memory(coverBytes!, height: 100, fit: BoxFit.cover))),
      ]),
    if (logoBytes != null || coverBytes != null) const SizedBox(height: 16),
    _row(Icons.storefront, 'الاسم', nameCtrl.text),
    _row(Icons.category, 'القسم', selectedSectionName ?? '-'),
    _row(Icons.local_offer, 'التخصص', isOtherSelected ? otherSubCtrl.text : (selectedSub ?? '-')),
    _row(Icons.phone, 'الهاتف', phoneCtrl.text),
    _row(Icons.location_on, 'العنوان', [selectedGov ?? '', cityCtrl.text, addrCtrl.text].where((s) => s.isNotEmpty).join(' - ')),
    _row(Icons.access_time, 'ساعات العمل', hoursCtrl.text.isEmpty ? '-' : hoursCtrl.text),
    const SizedBox(height: 20),
    Container(padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF25D366).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3))),
      child: Row(children: [
        const Icon(Icons.info_outline, color: Color(0xFF25D366)),
        const SizedBox(width: 10),
        Expanded(child: Text('سيتم مراجعة طلبك من الإدارة. لن يُفعّل المتجر إلا بعد الموافقة.',
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 12))),
      ])),
  ]);

  Widget _title(String t, String s) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(t, style: GoogleFonts.cairo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 4),
    Text(s, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
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

  Widget _imgBox(String l, Uint8List? b, VoidCallback onTap) => Expanded(
    child: GestureDetector(onTap: onTap, child: Container(height: 120,
      decoration: BoxDecoration(color: const Color(0xFF1A1B26), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24)),
      child: b != null ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(b, fit: BoxFit.cover)) :
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.add_photo_alternate_outlined, color: Colors.grey, size: 32),
          const SizedBox(height: 6),
          Text(l, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
        ]))));

  Widget _row(IconData i, String l, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Icon(i, color: const Color(0xFFEF7E3C), size: 20),
      const SizedBox(width: 10),
      Text('\$l: ', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
      Expanded(child: Text(v.isEmpty ? '-' : v, textAlign: TextAlign.right,
        style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600))),
    ]));

  Widget _bottomBar() => Container(padding: const EdgeInsets.all(16),
    child: Row(children: [
      if (step > 0) Expanded(child: OutlinedButton(
        onPressed: () => setState(() => step--),
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
