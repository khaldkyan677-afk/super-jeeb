import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreCard extends StatelessWidget {
  final String storeId;
  final String name;
  final String imageUrl;
  final bool isOpen;
  final bool isNew;
  final bool isFavorite;
  final String location;
  final double rating;
  final String deliveryTime;
  final double deliveryFee;
  final double minimumOrder;
  final Color bgColor;
  final VoidCallback? onTap;
  final VoidCallback? onReport;
  final VoidCallback? onRate;
  final VoidCallback? onFavorite;
  const StoreCard({super.key, this.storeId = '', required this.name,
    required this.imageUrl, required this.isOpen, this.isNew = false,
    this.isFavorite = false, required this.location, required this.rating,
    this.deliveryTime = '25 دقيقة', this.deliveryFee = 0, this.minimumOrder = 0,
    this.bgColor = const Color(0xFF1A1B26),
    this.onTap, this.onReport, this.onRate, this.onFavorite});

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.centerRight, end: Alignment.centerLeft,
            colors: isOpen
              ? [bgColor, bgColor.withOpacity(0.85)]
              : [const Color(0xFF1A1B26), const Color(0xFF0D0D12)])),
        child: Stack(children: [
          if (isNew) Positioned(top: 0, left: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14), bottomRight: Radius.circular(12)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                color: const Color(0xFFEF233C),
                child: Text('NEW', style: GoogleFonts.cairo(
                  color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))))),
          Positioned(top: 10, right: 10,
            child: Container(width: 50, height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5)),
              child: imageUrl.isEmpty
                ? Icon(Icons.store, color: bgColor, size: 22)
                : ClipOval(child: Image.network(imageUrl, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.store, color: bgColor, size: 22))))),
          Positioned(top: 12, left: 12,
            child: GestureDetector(onTap: onFavorite,
              child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? const Color(0xFFEF233C) : Colors.white70, size: 22))),
          Padding(padding: const EdgeInsets.fromLTRB(12, 10, 70, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(18)),
                child: Text(name, style: GoogleFonts.cairo(
                  color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: isOpen ? const Color(0xFF25D366).withOpacity(0.25) : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5)),
                    child: Text(isOpen ? 'مفتوح' : 'مغلق',
                      style: GoogleFonts.cairo(
                        color: isOpen ? const Color(0xFF25D366) : Colors.white70, fontSize: 9))),
                  const SizedBox(width: 6),
                  Flexible(child: Text('$location • $deliveryTime',
                    style: GoogleFonts.cairo(color: Colors.white70, fontSize: 10),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
                const SizedBox(height: 3),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Flexible(child: Text(
                    'توصيل ${deliveryFee.toInt()} ر.ي • أدنى ${minimumOrder.toInt()} ر.ي',
                    style: GoogleFonts.cairo(color: Colors.white60, fontSize: 9),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
                const SizedBox(height: 4),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    GestureDetector(onTap: onReport,
                      child: const Icon(Icons.flag_outlined, color: Colors.white54, size: 16)),
                    const SizedBox(width: 10),
                    GestureDetector(onTap: onRate,
                      child: const Icon(Icons.rate_review_outlined, color: Colors.white54, size: 16)),
                  ]),
                  GestureDetector(onTap: onRate,
                    child: Row(children: List.generate(5, (i) =>
                      Icon(i < fullStars ? Icons.star : Icons.star_border,
                        color: const Color(0xFFEF233C), size: 14)))),
                ]),
              ]),
            ])),
        ]),
      ));
  }
}
