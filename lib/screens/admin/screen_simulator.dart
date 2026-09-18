import 'package:flutter/material.dart';

import 'merchant_management_screen.dart';
import 'add_merchant_screen.dart';

class ScreenSimulator extends StatelessWidget {
  const ScreenSimulator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محاكي الشاشات'),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'إدارة المتاجر',
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            color: const Color(0xFF2A2A3E),
            child: ListTile(
              leading: const Icon(Icons.storefront, color: Colors.amber),
              title: const Text(
                'إدارة المتاجر (قائمة التجار)',
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white54,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MerchantManagementScreen(),
                ),
              ),
            ),
          ),
          Card(
            color: const Color(0xFF2A2A3E),
            child: ListTile(
              leading: const Icon(Icons.add_business, color: Colors.green),
              title: const Text(
                'إضافة تاجر جديد',
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white54,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddMerchantScreen()),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'واجهات المستخدمين',
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            color: const Color(0xFF2A2A3E),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text(
                'واجهة العميل',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('واجهة العميل (تجريبية)')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
