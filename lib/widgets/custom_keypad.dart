import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class CustomNumberPad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onBackspace;
  final VoidCallback? onDone;
  final String? doneLabel;
  final bool showDone;

  const CustomNumberPad({
    super.key,
    required this.onNumberPressed,
    required this.onBackspace,
    this.onDone,
    this.doneLabel,
    this.showDone = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      decoration: BoxDecoration(
        color: AppTheme.charcoal.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: AppTheme.redGlow, blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          _row(['1', '2', '3']),
          _row(['4', '5', '6']),
          _row(['7', '8', '9']),
          _lastRow(),
        ],
      ),
    );
  }

  Widget _row(List<String> numbers) {
    return Row(
      children: numbers.map((n) => Expanded(child: _buildButton(n))).toList(),
    );
  }

  Widget _buildButton(String number) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onNumberPressed(number);
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: AppTheme.surface.withOpacity(0.85),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white12),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lastRow() {
    return Row(
      children: [
        Expanded(child: _buildPaste()),
        Expanded(child: _buildButton('0')),
        Expanded(child: _buildBackspace()),
      ],
    );
  }

  Widget _buildPaste() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () async {
          HapticFeedback.lightImpact();
          final data = await Clipboard.getData('text/plain');
          if (data != null && data.text != null) {
            onNumberPressed(data.text!);
          }
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: AppTheme.surface.withOpacity(0.85),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.content_paste, color: AppTheme.yellow, size: 20),
                const SizedBox(height: 2),
                Text('لصق', style: TextStyle(color: Colors.white70, fontSize: 9, fontFamily: 'Cairo')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspace() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onBackspace();
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: AppTheme.surface.withOpacity(0.85),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white12),
          ),
          child: const Center(
            child: Icon(Icons.backspace_outlined, color: AppTheme.red, size: 24),
          ),
        ),
      ),
    );
  }
}
