import 'package:flutter/material.dart';

// ============================================================
// 1. زر أساسي
// ============================================================
class SJButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;
  final bool loading;
  final bool outlined;
  final double? width;

  const SJButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFFEF233C),
    this.icon,
    this.loading = false,
    this.outlined = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return SizedBox(
        width: width ?? double.infinity,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: loading ? null : onPressed,
          icon: icon != null
              ? Icon(icon, color: color, size: 20)
              : const SizedBox.shrink(),
          label: loading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: color),
                )
              : Text(text,
                  style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: loading ? null : onPressed,
        icon: icon != null
            ? Icon(icon, color: Colors.white, size: 20)
            : const SizedBox.shrink(),
        label: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ============================================================
// 2. بطاقة
// ============================================================
class SJCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double? radius;
  final VoidCallback? onTap;
  final Color? borderColor;

  const SJCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(15),
    this.color,
    this.radius,
    this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(radius ?? 15),
        border: Border.all(color: borderColor ?? Colors.white10),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius ?? 15),
        child: card,
      );
    }
    return card;
  }
}

// ============================================================
// 3. حقل إدخال موحد
// ============================================================
class SJTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboard;
  final int maxLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Color? accentColor;
  final bool darkMode;

  const SJTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.obscure = false,
    this.keyboard,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.accentColor,
    this.darkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? const Color(0xFFEF233C);
    final textColor = darkMode ? Colors.white : const Color(0xFF2B2D42);

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
            color: textColor.withValues(alpha: 0.5), fontSize: 13),
        hintStyle:
            TextStyle(color: textColor.withValues(alpha: 0.3), fontSize: 13),
        prefixIcon: icon != null
            ? Icon(icon, color: accent, size: 20)
            : null,
        filled: true,
        fillColor: darkMode
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
              color: darkMode ? Colors.white24 : Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFEF233C)),
        ),
      ),
    );
  }
}

// ============================================================
// 4. حالة فارغة
// ============================================================
class SJEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final Color color;

  const SJEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.color = Colors.white24,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 90, color: color),
            const SizedBox(height: 20),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(subtitle!,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 12),
                  textAlign: TextAlign.center),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 25),
              SJButton(
                text: actionText!,
                onPressed: onAction,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 5. حالة التحميل
// ============================================================
class SJLoading extends StatelessWidget {
  final String? message;
  final Color color;

  const SJLoading({
    super.key,
    this.message,
    this.color = const Color(0xFFEF233C),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 20),
            Text(message!,
                style: const TextStyle(
                    color: Colors.white54, fontSize: 13)),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// 6. مؤشر نجوم التقييم
// ============================================================
class SJRatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final bool interactive;
  final ValueChanged<double>? onRating;

  const SJRatingStars({
    super.key,
    required this.rating,
    this.size = 20,
    this.interactive = false,
    this.onRating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starValue = i + 1;
        final filled = rating >= starValue;
        final half = !filled && rating >= starValue - 0.5;

        return GestureDetector(
          onTap: interactive ? () => onRating?.call(starValue.toDouble()) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              filled
                  ? Icons.star
                  : half
                      ? Icons.star_half
                      : Icons.star_border,
              color: Colors.amber,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}

// ============================================================
// 7. حوار التأكيد
// ============================================================
class SJConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final IconData icon;

  const SJConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'تأكيد',
    this.cancelText = 'إلغاء',
    this.confirmColor = const Color(0xFFEF233C),
    this.icon = Icons.help_outline,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2B2D42),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(icon, color: confirmColor, size: 24),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 15)),
        ],
      ),
      content: Text(message,
          style:
              const TextStyle(color: Colors.white70, fontSize: 13)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText,
              style: const TextStyle(color: Colors.white60)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText,
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// ============================================================
// 8. تنبيه Toast
// ============================================================
class SJToast {
  static void show(BuildContext context, String message,
      {Color color = const Color(0xFF25D366), IconData icon = Icons.check_circle}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}

// ============================================================
// 9. شريط تقدم
// ============================================================
class SJProgressSteps extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final Color color;

  const SJProgressSteps({
    super.key,
    required this.steps,
    required this.currentStep,
    this.color = const Color(0xFFEF233C),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: steps.asMap().entries.map((e) {
        final i = e.key;
        final done = i < currentStep;
        final active = i == currentStep;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: done
                      ? const Color(0xFF25D366)
                      : active
                          ? color
                          : Colors.grey.shade700,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check,
                          color: Colors.white, size: 16)
                      : Text('${i + 1}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(e.value,
                    style: TextStyle(
                        color: (done || active)
                            ? Colors.white
                            : Colors.white38,
                        fontSize: 10,
                        fontWeight: (done || active)
                            ? FontWeight.bold
                            : FontWeight.normal),
                    overflow: TextOverflow.ellipsis),
              ),
              if (i < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: done
                        ? const Color(0xFF25D366)
                        : Colors.grey.shade700,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================
// 10. بطاقة إحصائية
// ============================================================
class SJStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final String? change;
  final bool positive;

  const SJStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.color = const Color(0xFFEF233C),
    this.change,
    this.positive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              if (change != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (positive
                            ? const Color(0xFF25D366)
                            : const Color(0xFFEF233C))
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(change!,
                      style: TextStyle(
                          color: positive
                              ? const Color(0xFF25D366)
                              : const Color(0xFFEF233C),
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 10),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ============================================================
// 11. شريط تقدم خطي
// ============================================================
class SJLinearProgress extends StatelessWidget {
  final double value;
  final String? label;
  final Color color;

  const SJLinearProgress({
    super.key,
    required this.value,
    this.label,
    this.color = const Color(0xFFEF233C),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label!,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12)),
              Text('${(value * 100).toInt()}%',
                  style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 12. شارة
// ============================================================
class SJBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const SJBadge({
    super.key,
    required this.text,
    this.color = const Color(0xFFEF233C),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
          ],
          Text(text,
              style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
