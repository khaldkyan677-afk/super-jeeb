import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showReportSheet(BuildContext context, String storeId, String storeName) {
  String? reason;
  final ctrl = TextEditingController();
  final reasons = ['منتجات منتهية أو فاسدة','معلومات المتجر خاطئة','تأخير في الطلب',
    'تعامل سيء من صاحب المتجر','احتيال في الأسعار','أخرى'];
  showModalBottomSheet(context: context, isScrollControlled: true,
    backgroundColor: const Color(0xFF1A1B26),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (c) => StatefulBuilder(builder: (c, setS) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom),
      child: Padding(padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('رفع بلاغ على: $storeName', style: GoogleFonts.cairo(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('اختر سبب البلاغ (إلزامي)', style: GoogleFonts.cairo(
            color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: reasons.map((r) =>
            GestureDetector(onTap: () => setS(() => reason = r),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: reason == r ? const Color(0xFFEF233C) : const Color(0xFF23242F),
                  borderRadius: BorderRadius.circular(20)),
                child: Text(r, style: GoogleFonts.cairo(
                  color: reason == r ? Colors.white : Colors.grey, fontSize: 12))))).toList()),
          const SizedBox(height: 14),
          TextField(controller: ctrl, maxLines: 3, textAlign: TextAlign.right,
            style: GoogleFonts.cairo(color: Colors.white),
            decoration: InputDecoration(hintText: 'تفاصيل إضافية (اختياري)...',
              hintStyle: GoogleFonts.cairo(color: Colors.grey),
              filled: true, fillColor: const Color(0xFF23242F),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none))),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: reason == null ? Colors.grey.shade800 : const Color(0xFFEF233C),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: reason == null ? null : () {
              Navigator.pop(c);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: const Color(0xFF25D366),
                content: Text('تم إرسال بلاغك: $reason',
                  style: GoogleFonts.cairo(color: Colors.white))));
            },
            child: Text('إرسال البلاغ', style: GoogleFonts.cairo(
              color: Colors.white, fontWeight: FontWeight.bold)))),
        ])))));
}
