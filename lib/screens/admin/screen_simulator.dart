import 'package:flutter/material.dart';

class ScreenSimulator extends StatelessWidget {
  const ScreenSimulator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('محاكي الشاشات')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(child: ListTile(title: Text('شاشة التجار'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: Text('شاشة التجار')), body: Center(child: Text('هذه شاشة التجار تجريبية'))))))),
          Card(child: ListTile(title: Text('شاشة المناديب'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: Text('شاشة المناديب')), body: Center(child: Text('هذه شاشة المناديب تجريبية'))))))),
          Card(child: ListTile(title: Text('شاشة الطلبات'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: Text('شاشة الطلبات')), body: Center(child: Text('هذه شاشة الطلبات تجريبية'))))))),
          Card(child: ListTile(title: Text('تفاصيل التاجر/المندوب'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: Text('تفاصيل التاجر/المندوب')), body: Center(child: Text('هنا تظهر تفاصيل التاجر أو المندوب'))))))),
        ],
      ),
    );
  }
}
