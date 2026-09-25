import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  const CategoryChips({super.key, required this.categories,
    required this.selectedIndex, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (c, i) {
          final active = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFEF233C) : const Color(0xFF1A1B26),
                borderRadius: BorderRadius.circular(20)),
              child: Text(categories[i],
                style: GoogleFonts.cairo(color: active ? Colors.white : Colors.grey,
                  fontSize: 13, fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
            ));
        }));
  }
}
