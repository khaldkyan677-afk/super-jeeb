import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});
  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _error = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'الرجاء إدخال البريد وكلمة المرور');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }
    setState(() { _isLoading = true; _error = ''; });
    try {
      if (_isLoginMode) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      }
              final fu = FirebaseAuth.instance.currentUser;
        if (fu != null) {
          try {
            final r = await http.post(Uri.base.resolve('/api/auth/firebase-login'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'email': fu.email ?? email, 'uid': fu.uid, 'name': fu.displayName ?? '', 'phone': fu.phoneNumber ?? ''})).timeout(const Duration(seconds: 15));
            if (r.statusCode == 403) {
              await FirebaseAuth.instance.signOut();
              setState(() => _error = jsonDecode(r.body)['message'] ?? 'حسابك قيد المراجعة');
              return;
            }
          } catch (_) {}
        }
if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم الدخول بنجاح!'), backgroundColor: AppTheme.green),
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg = 'حدث خطأ';
      if (e.code == 'user-not-found') msg = 'لا يوجد حساب بهذا البريد';
      else if (e.code == 'wrong-password') msg = 'كلمة المرور غير صحيحة';
      else if (e.code == 'email-already-in-use') msg = 'البريد مسجل بالفعل';
      else if (e.code == 'invalid-email') msg = 'البريد الإلكتروني غير صالح';
      else if (e.code == 'weak-password') msg = 'كلمة المرور ضعيفة';
      setState(() => _error = msg);
    } catch (e) {
      setState(() => _error = 'خطأ: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'أدخل البريد الإلكتروني أولاً');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال رابط استعادة كلمة المرور'), backgroundColor: AppTheme.green),
        );
      }
    } catch (e) {
      setState(() => _error = 'فشل: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // أيقونة البريد
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.red, width: 2),
                ),
                child: const Icon(Icons.email_rounded, color: AppTheme.red, size: 55),
              ),
              const SizedBox(height: 25),

              // العنوان
              Text(
                _isLoginMode ? 'تسجيل الدخول' : 'إنشاء حساب جديد',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLoginMode ? 'أدخل بريدك وكلمة المرور للمتابعة' : 'أنشئ حساباً جديداً بالبريد الإلكتروني',
                style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Cairo'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // حقل البريد
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: AppTheme.white, fontFamily: 'Cairo'),
                decoration: InputDecoration(
                  hintText: 'البريد الإلكتروني',
                  hintStyle: TextStyle(color: Colors.white38, fontFamily: 'Cairo'),
                  prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.red),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppTheme.red, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // حقل كلمة المرور + زر العين
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: AppTheme.white, fontFamily: 'Cairo'),
                decoration: InputDecoration(
                  hintText: 'كلمة المرور',
                  hintStyle: TextStyle(color: Colors.white38, fontFamily: 'Cairo'),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.red),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white54,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppTheme.red, width: 1.5),
                  ),
                ),
              ),

              // رسالة الخطأ
              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(_error, style: const TextStyle(color: AppTheme.red, fontSize: 13, fontFamily: 'Cairo')),
                ),
              const SizedBox(height: 24),

              // زر الدخول / إنشاء حساب
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.red,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                          _isLoginMode ? 'دخول' : 'إنشاء حساب',
                          style: TextStyle(color: AppTheme.white, fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                        ),
                ),
              ),
              const SizedBox(height: 15),

              // نسيت كلمة المرور
              if (_isLoginMode)
                TextButton(
                  onPressed: _resetPassword,
                  child: Text('نسيت كلمة المرور؟', style: TextStyle(color: AppTheme.red, fontFamily: 'Cairo')),
                ),

              // ليس لدي حساب
              TextButton(
                onPressed: () => setState(() { _isLoginMode = !_isLoginMode; _error = ''; }),
                child: Text(
                  _isLoginMode ? 'ليس لديك حساب؟ سجل الآن' : 'لديك حساب؟ سجل الدخول',
                  style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
