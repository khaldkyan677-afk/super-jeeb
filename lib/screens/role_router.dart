import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'client/client_app.dart';
import 'merchant/merchant_app.dart';
import 'driver/driver_app.dart';

class RoleRouterScreen extends StatefulWidget {
  const RoleRouterScreen({super.key});
  @override
  State<RoleRouterScreen> createState() => _RoleRouterScreenState();
}

class _RoleRouterScreenState extends State<RoleRouterScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    final auth = AuthService.instance;
    await auth.loadCachedRole();
    var role = auth.role;
    if (role == null && auth.isLoggedIn) {
      final res = await auth.syncAfterLogin();
      role = res?['role'] as String?;
    }
    if (!mounted) return;
    Widget next;
    switch (role) {
      case 'merchant':
        next = const MerchantApp();
        break;
      case 'driver':
        next = const DriverApp();
        break;
      default:
        next = const ClientApp();
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => next));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D0D12),
      body: Center(child: CircularProgressIndicator(color: Color(0xFFEF233C))),
    );
  }
}
