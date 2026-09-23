import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../services/location_service.dart';
import '../main.dart' show WelcomeScreen;

class EntryGate extends StatefulWidget {
  const EntryGate({super.key});
  @override
  State<EntryGate> createState() => _EntryGateState();
}

class _EntryGateState extends State<EntryGate> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
    await LocationService.load();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppTheme.red, strokeWidth: 3),
            const SizedBox(height: 20),
            Text('جاري التحميل...',
              style: TextStyle(color: AppTheme.white, fontFamily: 'Cairo', fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
