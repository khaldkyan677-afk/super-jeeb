const OtpCode = require('../models/OtpCode');
const LoginLog = require('../models/LoginLog');
const AuditLog = require('../models/AuditLog');

function gen6() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

// إرسال كود OTP
exports.sendOtp = async (req, res) => {
  try {
    const { phone, purpose } = req.body;
    if (!phone) return res.status(400).json({ message: 'رقم الجوال مطلوب' });

    // حد أقصى 3 أكواد في 5 دقائق
    const recent = await OtpCode.countDocuments({
      phone,
      createdAt: { $gte: new Date(Date.now() - 5 * 60 * 1000) }
    });
    if (recent >= 3) {
      return res.status(429).json({ message: 'محاولات كثيرة، حاول بعد 5 دقائق' });
    }

    const code = gen6();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

    await OtpCode.create({
      phone,
      code,
      purpose: purpose || 'login',
      expiresAt,
      ip: req.ip
    });

    // TODO: إرسال SMS حقيقي

    res.json({ message: 'تم إرسال الكود', expiresIn: 300 });
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// التحقق من OTP
exports.verifyOtp = async (req, res) => {
  try {
    const { phone, code, purpose } = req.body;
    if (!phone || !code) return res.status(400).json({ message: 'البيانات ناقصة' });

    const otp = await OtpCode.findOne({
      phone,
      purpose: purpose || 'login',
      isUsed: false,
      expiresAt: { $gt: new Date() }
    }).sort({ createdAt: -1 });

    if (!otp) return res.status(400).json({ message: 'الكود غير صحيح أو منتهي' });

    if (otp.attempts >= otp.maxAttempts) {
      return res.status(429).json({ message: 'تجاوزت عدد المحاولات' });
    }

    if (otp.code !== code) {
      await OtpCode.findByIdAndUpdate(otp._id, { attempts: otp.attempts + 1 });
      return res.status(400).json({ message: 'كود خاطئ' });
    }

    await OtpCode.findByIdAndUpdate(otp._id, { isUsed: true });

    await LoginLog.create({
      phone,
      method: 'otp',
      success: true,
      ip: req.ip
    });

    res.json({ message: 'OK', verified: true });
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// تنظيف الأكواد المنتهية
exports.cleanupOtps = async (req, res) => {
  try {
    const r = await OtpCode.deleteMany({ expiresAt: { $lt: new Date() } });
    res.json({ deleted: r.deletedCount });
  } catch (e) { res.status(500).json({ message: e.message }); }
};
