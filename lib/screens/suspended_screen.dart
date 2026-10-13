import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class SuspendedScreen extends StatelessWidget {
  final String message;
  const SuspendedScreen({super.key, this.message = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B0013),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, color: Colors.red, size: 90),
              const SizedBox(height: 20),
              Text('الحساب موقوف',
                style: GoogleFonts.cairo(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(message.isNotEmpty ? message : 'تم إيقاف حسابك. للاستفسار تواصل مع الدعم.',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(color: Colors.white70, fontSize: 15)),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF660F24),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => AuthService.instance.signOut(),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text('تسجيل الخروج', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
