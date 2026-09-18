import 'package:flutter/material.dart';

class MerchantDelegateDetailsScreen extends StatelessWidget {
  final String name;
  final String city;
  final String governorate;

  const MerchantDelegateDetailsScreen({
    super.key,
    required this.name,
    required this.city,
    required this.governorate,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل: $name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التاريخ: ${now.year}-${now.month}-${now.day}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'الوقت: ${now.hour}:${now.minute}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text('المدينة: $city', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              'المحافظة: $governorate',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
