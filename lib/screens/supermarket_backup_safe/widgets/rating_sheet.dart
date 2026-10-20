import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showRatingSheet(BuildContext context, String storeId, String storeName, VoidCallback? onDone) {
  int stars = 0;
  final ctrl = TextEditingController();
  showModalBottomSheet(context: context, isScrollControlled: true,
    backgroundColor: const Color(0xFF1A1B26),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (c) => StatefulBuilder(builder: (c, setS) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom),
      child: Padding(padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('قيّم تجربتك مع $storeName', style: GoogleFonts.cairo(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('اختر عدد النجوم (إلزامي)', style: GoogleFonts.cairo(
            color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) => GestureDetector(
              onTap: () => setS(() => stars = i + 1),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(i < stars ? Icons.star : Icons.star_border,
                  color: const Color(0xFFF0C107), size: 38))))),
          const SizedBox(height: 8),
          Center(child: Text(
            stars == 0 ? 'لم تختر بعد' : '$stars من 5',
            style: GoogleFonts.cairo(
              color: stars == 0 ? Colors.grey : const Color(0xFFF0C107),
              fontSize: 13, fontWeight: FontWeight.w600))),
          const SizedBox(height: 16),
          TextField(controller: ctrl, maxLines: 3, textAlign: TextAlign.right,
            style: GoogleFonts.cairo(color: Colors.white),
            decoration: InputDecoration(hintText: 'اكتب تعليقك (اختياري)...',
              hintStyle: GoogleFonts.cairo(color: Colors.grey),
              filled: true, fillColor: const Color(0xFF23242F),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none))),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: stars == 0 ? Colors.grey.shade800 : const Color(0xFFEF233C),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: stars == 0 ? null : () {
              Navigator.pop(c);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: const Color(0xFF25D366),
                content: Text('تم إرسال تقييمك ($stars نجوم)',
                  style: GoogleFonts.cairo(color: Colors.white))));
              if (onDone != null) onDone();
            },
            child: Text('إرسال التقييم', style: GoogleFonts.cairo(
              color: Colors.white, fontWeight: FontWeight.bold)))),
        ])))));
}
