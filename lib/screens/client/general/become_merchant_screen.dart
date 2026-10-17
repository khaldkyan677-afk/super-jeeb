import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';

class BecomeMerchantScreen extends StatefulWidget {
  const BecomeMerchantScreen({super.key});
  @override
  State<BecomeMerchantScreen> createState() => _S();
}

class _S extends State<BecomeMerchantScreen> {
  String lang = 'ar';
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
  Uint8List? nationalIdBytes;
  Uint8List? commercialRegistryBytes;
  Uint8List? businessLicenseBytes;
  Uint8List? storeFrontImageBytes;
  Uint8List? storeInsideImageBytes;
  bool agreedToDocuments = false;
  bool agreedToTerms = false;
  bool agreedToCommission = false;

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
    _loadDraft();
  }

  Future<void> _loadSections() async {
    try {
      final r = await http.get(Uri.parse('${ApiService.baseUrl}/api/sections'));
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

  static const _draftKey = 'merchant_draft_v1';

  Future<void> _saveDraft() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final d = {
        'step': step,
        'name': nameCtrl.text,
        'desc': descCtrl.text,
        'phone': phoneCtrl.text,
        'city': cityCtrl.text,
        'addr': addrCtrl.text,
        'map': mapCtrl.text,
        'hours': hoursCtrl.text,
        'other': otherSubCtrl.text,
        'sectionId': selectedSectionId,
        'sectionName': selectedSectionName,
        'sub': selectedSub,
        'gov': selectedGov,
        'isOther': isOtherSelected,
        'lang': lang,
        'logo': logoBytes != null ? base64Encode(logoBytes!) : null,
        'cover': coverBytes != null ? base64Encode(coverBytes!) : null,
      };
      await sp.setString(_draftKey, jsonEncode(d));
    } catch (_) {}
  }

  Future<void> _loadDraft() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final raw = sp.getString(_draftKey);
      if (raw == null) return;
      final d = jsonDecode(raw) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        step = (d['step'] as int?) ?? 0;
        nameCtrl.text = (d['name'] as String?) ?? '';
        descCtrl.text = (d['desc'] as String?) ?? '';
        phoneCtrl.text = (d['phone'] as String?) ?? '';
        cityCtrl.text = (d['city'] as String?) ?? '';
        addrCtrl.text = (d['addr'] as String?) ?? '';
        mapCtrl.text = (d['map'] as String?) ?? '';
        hoursCtrl.text = (d['hours'] as String?) ?? '';
        otherSubCtrl.text = (d['other'] as String?) ?? '';
        selectedSectionId = d['sectionId'] as String?;
        selectedSectionName = d['sectionName'] as String?;
        selectedSub = d['sub'] as String?;
        selectedGov = d['gov'] as String?;
        isOtherSelected = (d['isOther'] as bool?) ?? false;
        lang = (d['lang'] as String?) ?? 'ar';
        final lb = d['logo'] as String?;
        final cb = d['cover'] as String?;
        if (lb != null) logoBytes = base64Decode(lb);
        if (cb != null) coverBytes = base64Decode(cb);
      });
    } catch (_) {}
  }

  Future<void> _clearDraft() async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.remove(_draftKey);
    } catch (_) {}
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
    if (step == 3) return nationalIdBytes != null && storeFrontImageBytes != null && agreedToDocuments;
    if (step == 4) return agreedToTerms && agreedToCommission;
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
      'governorate': selectedGov ?? '',
      'city': cityCtrl.text.trim(),
      'documents': {
        'nationalId': _b64(nationalIdBytes) ?? '',
        'commercialRegistry': _b64(commercialRegistryBytes) ?? '',
        'businessLicense': _b64(businessLicenseBytes) ?? '',
        'storeFrontImage': _b64(storeFrontImageBytes) ?? '',
        'storeInsideImage': _b64(storeInsideImageBytes) ?? '',
      },
      'agreedToTerms': agreedToTerms,
      'agreedToCommission': agreedToCommission,
      };
      final r = await http.post(
        Uri.parse('${ApiService.baseUrl}/api/merchants'),
        headers: {
          'Content-Type': 'application/json',
          if (ApiService.authToken != null) 'Authorization': 'Bearer ${ApiService.authToken!}',
        },
        body: jsonEncode(body),
      );
      if (!mounted) return;
      setState(() => submitting = false);
      if (r.statusCode == 200 || r.statusCode == 201) {
        await _clearDraft();
        _success();
      } else {
    _snack("${t('fail')}: ${r.statusCode}");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => submitting = false);
    _snack("${t('err')}: ${e.toString()}");
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
        Text(t('success_t'), style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
      ]),
      content: Text(t('success_b'),
        style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14)),
      actions: [TextButton(
        onPressed: () { Navigator.of(c).pop(); Navigator.of(context).pop(); },
        child: Text(t('ok'), style: GoogleFonts.cairo(color: const Color(0xFF25D366), fontWeight: FontWeight.bold)))],
    ));
  }

  static const Map<String, Map<String, String>> _t = {
    'ar': {
      'title': 'إعداد متجرك',
      'back': 'السابق', 'next': 'التالي', 'send': 'إرسال للمراجعة',
      'step1': 'الهوية', 'step2': 'النشاط', 'step3': 'التواصل', 'step4': 'الإطلاق',
      'h1': 'هوية المتجر', 's1': 'قم بإعداد اسم متجرك ووصفه',
      'f_name': 'اسم المتجر *', 'f_desc': 'وصف المتجر (اختياري)',
      'logo_cover': 'شعار وغلاف المتجر', 'logo': 'الشعار', 'cover': 'الغلاف',
      'h2': 'نشاط العمل', 's2': 'اختر نوع المتجر',
      'sub_title': 'التخصص الدقيق *', 'other': 'أخرى', 'other_hint': 'اكتب نوع متجرك',
      'h3': 'معلومات التواصل', 's3': 'أضف بيانات التواصل الخاصة بمتجرك',
      'f_phone': 'رقم الهاتف * (مثال: 73xxxxxxx)',
      'phone_err': 'الرقم يجب أن يبدأ بـ 73/77/78/71/70',
      'f_gov': 'المحافظة *', 'f_city': 'المدينة / المنطقة',
      'f_addr': 'العنوان التفصيلي', 'f_map': 'رابط الموقع (خريطة)', 'f_hours': 'ساعات العمل',
      'h4': 'جاهز للإرسال!', 's4': 'راجع التفاصيل قبل الإرسال للإدارة',
    'h_docs': 'الوثائق والتصاريح',
    's_docs': 'لأمان الجميع، نحتاج التحقق من هويتك',
    'docs_note': '⚠ الوثائق للتحقق فقط',
    'commission_title': 'اتفاقية العمولة',
    'commission_label': 'نسبة عمولة المنصة',
    'commission_example': 'مثال: طلب 10,000 ريال → عمولة 500 ريال، صافي 9,500 ريال',
    'agree_terms': 'أوافق على الشروط والخصوصية',
    'agree_commission': 'أوافق على نسبة العمولة',
      'r_name': 'الاسم', 'r_cat': 'القسم', 'r_sub': 'التخصص',
      'r_phone': 'الهاتف', 'r_addr': 'العنوان', 'r_hours': 'ساعات العمل',
      'review_note': 'سيتم مراجعة طلبك من الإدارة. لن يُفعّل المتجر إلا بعد الموافقة.',
      'loading': 'جاري التحميل...',
      'success_t': 'تم الإرسال!', 'success_b': 'طلبك قيد المراجعة من الإدارة. سيتم إشعارك بعد الموافقة.',
      'ok': 'حسناً', 'save_draft': 'حفظ كمسودة', 'draft_saved': 'تم حفظ المسودة', 'fail': 'فشل الإرسال', 'err': 'خطأ',
    },
    'en': {
      'title': 'Store Setup',
      'back': 'Back', 'next': 'Next', 'send': 'Submit for Review',
      'step1': 'Identity', 'step2': 'Activity', 'step3': 'Contact', 'step4': 'Launch',
      'h1': 'Store Identity', 's1': 'Set up your store name and description',
      'f_name': 'Store Name *', 'f_desc': 'Store Description (optional)',
      'logo_cover': 'Logo & Cover', 'logo': 'Logo', 'cover': 'Cover',
      'h2': 'Business Activity', 's2': 'Choose your store type',
      'sub_title': 'Subcategory *', 'other': 'Other', 'other_hint': 'Type your store type',
      'h3': 'Contact Info', 's3': 'Add your store contact information',
      'f_phone': 'Phone Number * (e.g. 73xxxxxxx)',
      'phone_err': 'Number must start with 73/77/78/71/70',
      'f_gov': 'Governorate *', 'f_city': 'City / Area',
      'f_addr': 'Detailed Address', 'f_map': 'Location Link (Map)', 'f_hours': 'Working Hours',
      'h4': 'Ready to Submit!', 's4': 'Review details before sending to admin',
    'h_docs': 'Documents & Permits',
    's_docs': 'For everyone safety, we need to verify your identity',
    'docs_note': '⚠ Documents are for verification only',
    'commission_title': 'Commission Agreement',
    'commission_label': 'Platform commission rate',
    'commission_example': 'Example: 10,000 YER order → 500 YER (5%) commission, net 9,500 YER',
    'agree_terms': 'I agree to the Terms of Service and Privacy Policy',
    'agree_commission': 'I agree to the commission rate',
      'r_name': 'Name', 'r_cat': 'Category', 'r_sub': 'Subcategory',
      'r_phone': 'Phone', 'r_addr': 'Address', 'r_hours': 'Working Hours',
      'review_note': 'Your request will be reviewed by admin. Store will not be activated until approved.',
      'loading': 'Loading...',
      'success_t': 'Submitted!', 'success_b': 'Your request is under review. You will be notified after approval.',
      'ok': 'OK', 'save_draft': 'Save draft', 'draft_saved': 'Draft saved', 'fail': 'Failed to send', 'err': 'Error',
    },
  };

  String t(String k) => _t[lang]?[k] ?? _t['ar']![k] ?? k;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D12), elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text(t('title'), style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => lang = lang == 'ar' ? 'en' : 'ar'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1B26),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEF7E3C)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(lang == 'ar' ? 'AR' : 'EN',
                    style: GoogleFonts.cairo(color: const Color(0xFFEF7E3C), fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(width: 4),
                  const Icon(Icons.language, color: Color(0xFFEF7E3C), size: 16),
                ]),
              ),
            ),
          ),
        ],
      ),
      body: Column(children: [
        _stepper(),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: _body())),
        _bottomBar(),
      ]),
      ),
    );
  }

  Widget _s5() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _title(t('h4'), t('s4')),
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
    _row(Icons.storefront, t('r_name'), nameCtrl.text),
    _row(Icons.category, t('r_cat'), selectedSectionName ?? '-'),
    _row(Icons.local_offer, t('r_sub'), isOtherSelected ? otherSubCtrl.text : (selectedSub ?? '-')),
    _row(Icons.phone, t('r_phone'), phoneCtrl.text),
    _row(Icons.location_on, t('r_addr'), [selectedGov ?? '', cityCtrl.text, addrCtrl.text].where((s) => s.isNotEmpty).join(' - ')),
    _row(Icons.access_time, t('r_hours'), hoursCtrl.text.isEmpty ? '-' : hoursCtrl.text),
    const SizedBox(height: 20),
    Container(padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF25D366).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3))),
      child: Row(children: [
        const Icon(Icons.info_outline, color: Color(0xFF25D366)),
        const SizedBox(width: 10),
        Expanded(child: Text(t('review_note'),
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 12))),
      ])),
    const SizedBox(height: 20),
    _title(t('commission_title'), ''),
    const SizedBox(height: 8),
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE50914).withValues(alpha: 0.4)),
      ),
      child: Column(children: [
        Row(children: [
          const Icon(Icons.percent, color: Color(0xFFE50914), size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(t('commission_label'), style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))),
          Text('5%', style: GoogleFonts.cairo(color: const Color(0xFFE50914), fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 10),
        Text(t('commission_example'), style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
      ]),
    ),
    const SizedBox(height: 16),
    _check(t('agree_terms'), agreedToTerms, (v) => setState(() => agreedToTerms = v)),
    const SizedBox(height: 10),
    _check(t('agree_commission'), agreedToCommission, (v) => setState(() => agreedToCommission = v)),
    const SizedBox(height: 20),
  ]);

  Widget _stepper() {
    final titles = [t('step1'), t('step2'), t('step3'), t('h_docs'), t('step4')];
    return Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(children: List.generate(5, (i) {
        final active = i <= step;
        return Expanded(child: Column(children: [
          Row(children: [
            if (i > 0) Expanded(child: Container(height: 3, color: active ? const Color(0xFFEF7E3C) : Colors.white24)),
            Container(width: 30, height: 30,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: active ? const Color(0xFFEF7E3C) : const Color(0xFF1A1B26)),
              child: Icon(i < step ? Icons.check : [Icons.storefront, Icons.category, Icons.phone, Icons.description, Icons.rocket_launch][i],
                color: Colors.white, size: 16)),
            if (i < 4) Expanded(child: Container(height: 3, color: i < step ? const Color(0xFFEF7E3C) : Colors.white24)),
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
    if (step == 3) return _s4();
    return _s5();
  }

  Widget _s1() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _title(t('h1'), t('s1')),
    const SizedBox(height: 20),
    _field(t('f_name'), nameCtrl),
    _field(t('f_desc'), descCtrl, max: 3),
    const SizedBox(height: 16),
    Text(t('logo_cover'), style: GoogleFonts.cairo(color: Colors.white, fontSize: 13)),
    const SizedBox(height: 8),
    Row(children: [
      _imgBox(t('logo'), logoBytes, () => _pick(true)),
      const SizedBox(width: 12),
      _imgBox(t('cover'), coverBytes, () => _pick(false)),
    ]),
  ]);

  Widget _s2() {
    final sl = selectedSectionName != null ? (subs[selectedSectionName!] ?? []) : <Map<String, String>>[];
    final need = selectedSectionName != null && !selectedSectionName!.contains('سوبر');
    if (sectionsLoading) {
      return Column(children: [
        _title(t('h2'), t('loading')),
        const SizedBox(height: 30),
        const Center(child: CircularProgressIndicator(color: Color(0xFFEF7E3C))),
      ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _title(t('h2'), t('s2')),
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
        Text(t('sub_title'), key: _subsKey, style: GoogleFonts.cairo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
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
                  Expanded(child: Text(t('other'), style: GoogleFonts.cairo(color: Colors.white, fontSize: 11))),
                ]))),
          ]),
        if (isOtherSelected) ...[
          const SizedBox(height: 14),
          TextField(controller: otherSubCtrl, textAlign: TextAlign.right,
            style: GoogleFonts.cairo(color: Colors.white),
            decoration: InputDecoration(hintText: t('other_hint'), hintStyle: GoogleFonts.cairo(color: Colors.grey, fontSize: 13),
              filled: true, fillColor: const Color(0xFF1A1B26),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(14)),
            onChanged: (_) => setState(() {})),
        ],
      ],
    ]);
  }

  Widget _s3() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _title(t('h3'), t('s3')),
    const SizedBox(height: 20),
    _field(t('f_phone'), phoneCtrl, type: TextInputType.phone),
    if (phoneCtrl.text.isNotEmpty && !_validPhone(phoneCtrl.text))
      Padding(padding: const EdgeInsets.only(bottom: 12),
        child: Text(t('phone_err'), style: GoogleFonts.cairo(color: Colors.redAccent, fontSize: 11))),
    Padding(padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        initialValue: selectedGov,
        dropdownColor: const Color(0xFF1A1B26),
        style: GoogleFonts.cairo(color: Colors.white),
        decoration: InputDecoration(filled: true, fillColor: const Color(0xFF1A1B26),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.all(14),
          hintText: t('f_gov'), hintStyle: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
        items: govs.map((g) => DropdownMenuItem(value: g, child: Text(g, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13)))).toList(),
        onChanged: (v) => setState(() => selectedGov = v),
      )),
    _field(t('f_city'), cityCtrl),
    _field(t('f_addr'), addrCtrl, max: 2),
    _field(t('f_map'), mapCtrl, type: TextInputType.url),
    _field(t('f_hours'), hoursCtrl),
  ]);

  Widget _docBox(String label, Uint8List? bytes, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1B26),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: bytes != null ? const Color(0xFF16A34A) : Colors.white12),
        ),
        child: Row(children: [
          Icon(bytes != null ? Icons.check_circle : Icons.upload_file, color: bytes != null ? const Color(0xFF16A34A) : Colors.white54, size: 24),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13))),
          if (bytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.memory(bytes, width: 50, height: 50, fit: BoxFit.cover),
            ),
        ]),
      ),
    );
  }

  Widget _check(String label, bool val, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!val),
      child: Row(children: [
        Icon(val ? Icons.check_box : Icons.check_box_outline_blank, color: const Color(0xFFE50914), size: 22),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: GoogleFonts.cairo(color: Colors.white, fontSize: 13))),
      ]),
    );
  }

  Future<void> _pickDoc(String which) async {
    final XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60, maxWidth: 1200, maxHeight: 1200);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      if (which == 'id') nationalIdBytes = bytes;
      else if (which == 'cr') commercialRegistryBytes = bytes;
      else if (which == 'bl') businessLicenseBytes = bytes;
      else if (which == 'front') storeFrontImageBytes = bytes;
      else if (which == 'inside') storeInsideImageBytes = bytes;
    });
  }

  Widget _s4() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _title(t('h_docs'), t('s_docs')),
    const SizedBox(height: 8),
    Text(t('docs_note'), style: GoogleFonts.cairo(color: Colors.amber, fontSize: 12)),
    const SizedBox(height: 16),
    _docBox('\u0627\u0644\u0628\u0637\u0627\u0642\u0629 \u0627\u0644\u0634\u062e\u0635\u064a\u0629 *', nationalIdBytes, () => _pickDoc('id')),
    const SizedBox(height: 12),
    _docBox('\u0627\u0644\u0633\u062c\u0644 \u0627\u0644\u062a\u062c\u0627\u0631\u064a', commercialRegistryBytes, () => _pickDoc('cr')),
    const SizedBox(height: 12),
    _docBox('\u0631\u062e\u0635\u0629 \u0628\u0644\u062f\u064a', businessLicenseBytes, () => _pickDoc('bl')),
    const SizedBox(height: 12),
    _docBox('\u0635\u0648\u0631\u0629 \u0648\u0627\u062c\u0647\u0629 \u0627\u0644\u0645\u062a\u062c\u0631 *', storeFrontImageBytes, () => _pickDoc('front')),
    const SizedBox(height: 12),
    _docBox('\u0635\u0648\u0631\u0629 \u062f\u0627\u062e\u0644 \u0627\u0644\u0645\u062a\u062c\u0631', storeInsideImageBytes, () => _pickDoc('inside')),
    const SizedBox(height: 16),
    _check('\u0623\u062a\u0639\u0647\u062f \u0628\u0623\u0646 \u0627\u0644\u0648\u062b\u0627\u0626\u0642 \u0635\u062d\u064a\u062d\u0629', agreedToDocuments, (v) => setState(() => agreedToDocuments = v)),
    const SizedBox(height: 20),
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
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      if (step > 0) Padding(padding: const EdgeInsets.only(bottom: 10), child: TextButton.icon(
        onPressed: () async { await _saveDraft(); if (mounted) _snack(lang == 'ar' ? 'تم حفظ المسودة' : 'Draft saved'); },
        icon: const Icon(Icons.save_outlined, color: Color(0xFFEF7E3C), size: 18),
        label: Text(lang == 'ar' ? 'حفظ كمسودة' : 'Save draft', style: GoogleFonts.cairo(color: const Color(0xFFEF7E3C), fontSize: 13)),
      )),
      Row(children: [
      if (step > 0) Expanded(child: OutlinedButton(
        onPressed: () => setState(() => step--),
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: Text(t('back'), style: GoogleFonts.cairo(color: Colors.white)))),
      if (step > 0) const SizedBox(width: 12),
      Expanded(flex: 2, child: ElevatedButton(
        onPressed: (!_canNext() || submitting) ? null : () {
          if (step == 4) { _submit(); } else { _saveDraft(); setState(() => step++); }
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF7E3C),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: Colors.grey.shade800),
        child: submitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) :
          Text(step == 4 ? t('send') : t('next'), style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)))),
      ]),
    ]));
}
