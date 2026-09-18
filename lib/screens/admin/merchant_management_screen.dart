import 'package:flutter/material.dart';

import '../merchant_delegate_details_screen.dart';

class MerchantManagementScreen extends StatelessWidget {
  const MerchantManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية للعرض (يمكن استبدالها بالبيانات الحقيقية لاحقاً)
    final List<Map<String, String>> merchants = [
      {
        'name': 'مؤسسة النور التجارية',
        'city': 'صنعاء',
        'governorate': 'أمانة العاصمة',
      },
      {'name': 'سوبر ماركت الأمانة', 'city': 'عدن', 'governorate': 'عدن'},
      {'name': 'مخابز الحلو', 'city': 'تعز', 'governorate': 'تعز'},
      {'name': 'مطاعم الشيباني', 'city': 'الحديدة', 'governorate': 'الحديدة'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المتاجر'),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: merchants.length,
        itemBuilder: (context, index) {
          final m = merchants[index];
          return Card(
            color: const Color(0xFF2A2A3E),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.storefront, color: Colors.amber),
              title: Text(
                m['name']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${m['city']} - ${m['governorate']}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white54,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MerchantDelegateDetailsScreen(
                      name: m['name']!,
                      city: m['city']!,
                      governorate: m['governorate']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('سيتم تفعيل ميزة إضافة تاجر قريباً')),
          );
        },
        backgroundColor: Colors.amber,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          'إضافة تاجر',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
