import 'package:flutter/material.dart';

// ============================================================
// خدمة الكاميرا والصور - مشتركة بين كل التطبيقات
// ============================================================
class CameraService {
  /// يفتح الكاميرا لالتقاط صورة
  static Future<String?> pickFromCamera(BuildContext context) async {
    // محاكاة - سيتم استبدالها بـ image_picker لاحقًا
    return _showImageSourceDialog(context, 'camera');
  }

  /// يفتح المعرض لاختيار صورة
  static Future<String?> pickFromGallery(BuildContext context) async {
    return _showImageSourceDialog(context, 'gallery');
  }

  /// حوار اختيار المصدر
  static Future<String?> _showImageSourceDialog(
      BuildContext context, String source) async {
    // محاكاة الالتقاط
    await Future.delayed(const Duration(milliseconds: 500));
    return 'https://placeholder.superjeeb.com/image_${DateTime.now().millisecondsSinceEpoch}.jpg';
  }
}

// ============================================================
// واجهة موحدة لرفع الصور
// ============================================================
class ImageUploadBox extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color activeColor;
  final ValueChanged<String?>? onUploaded;

  const ImageUploadBox({
    super.key,
    required this.label,
    this.icon = Icons.camera_alt,
    this.activeColor = const Color(0xFF25D366),
    this.onUploaded,
  });

  @override
  State<ImageUploadBox> createState() => _ImageUploadBoxState();
}

class _ImageUploadBoxState extends State<ImageUploadBox> {
  String? _uploadedUrl;
  bool _uploading = false;

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2B2D42),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text('اختر مصدر الصورة',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _sourceBtn(
                    icon: Icons.camera_alt,
                    label: 'الكاميرا',
                    color: const Color(0xFFEF233C),
                    onTap: () => _upload('camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _sourceBtn(
                    icon: Icons.photo_library,
                    label: 'المعرض',
                    color: const Color(0xFF25D366),
                    onTap: () => _upload('gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _sourceBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _upload(String source) async {
    Navigator.pop(context);
    setState(() => _uploading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _uploadedUrl = 'https://placeholder.superjeeb.com/${DateTime.now().millisecondsSinceEpoch}.jpg';
      _uploading = false;
    });
    widget.onUploaded?.call(_uploadedUrl);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(source == 'camera'
              ? '📸 تم التقاط الصورة بنجاح'
              : '🖼️ تم اختيار الصورة'),
          backgroundColor: const Color(0xFF25D366),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = _uploadedUrl != null;
    final color = isDone ? widget.activeColor : const Color(0xFF2B2D42);

    return InkWell(
      onTap: _uploading ? null : _showOptions,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: isDone
              ? widget.activeColor.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDone ? widget.activeColor : Colors.white24,
            width: isDone ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_uploading)
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Color(0xFFEF233C)),
              )
            else
              Icon(
                isDone ? Icons.check_circle : widget.icon,
                color: isDone ? widget.activeColor : const Color(0xFFEF233C),
                size: 30,
              ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                _uploading ? 'جاري الرفع...' : widget.label,
                style: TextStyle(
                  color: isDone ? widget.activeColor : Colors.white,
                  fontSize: 11,
                  fontWeight:
                      isDone ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// أداة تفريغ خلفية الصور (للمنتجات)
// ============================================================
class BackgroundRemover {
  /// يحاكي تفريغ الخلفية - سيتصل بـ API حقيقي لاحقًا
  static Future<String> removeBackground(String imageUrl) async {
    await Future.delayed(const Duration(seconds: 2));
    return '${imageUrl}_no_bg.png';
  }

  /// حوار التفريغ
  static Future<void> showRemoveDialog(
    BuildContext context,
    String imageUrl,
    Function(String) onDone,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2B2D42),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFFEF233C)),
            const SizedBox(height: 20),
            const Text('✂️ جاري تفريغ الخلفية...',
                style: TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 8),
            const Text('سيتم فصل المنتج عن الخلفية تلقائيًا',
                style: TextStyle(color: Colors.white54, fontSize: 11),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
    final newUrl = await removeBackground(imageUrl);
    if (context.mounted) Navigator.pop(context);
    onDone(newUrl);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم تفريغ الخلفية بنجاح'),
          backgroundColor: Color(0xFF25D366),
        ),
      );
    }
  }
}
