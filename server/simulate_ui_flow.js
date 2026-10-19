const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const User = require('./models/User');

// صورة وهمية صغيرة (Base64) لتمثيل وثيقة
const fakeImage = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=";

async function simulate() {
  await mongoose.connect(process.env.MONGO_URI);
  const base = 'http://localhost:5000';
  const id = Date.now().toString().slice(-4);

  console.log('🎬 بدء محاكاة واجهة المستخدم والأدمن...\n');

  // ==========================================
  // 1. تطبيق المستخدم (Client App)
  // ==========================================
  console.log('📱 [تطبيق العميل]: تسجيل حساب جديد وتقديم طلب مندوب...');
  const client = await User.create({ name: `مندوب ${id}`, phone: `777${id}`, email: `d${id}@t.com`, password: '123', role: 'client' });
  const clientToken = jwt.sign({ id: client._id, role: 'client' }, process.env.JWT_SECRET);

  // محاكاة ضغط زر "إرسال" في تطبيق Flutter (رفع البيانات والصور)
  let res = await fetch(`${base}/api/users/apply-driver`, {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${clientToken}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      name: client.name, nationalId: '123456', vehicleType: 'دراجة', vehicleModel: 'هوندا', plateNumber: '111',
      docNationalId: fakeImage, docLicense: fakeImage, docRegistration: fakeImage, docVehiclePhoto: fakeImage
    })
  });
  console.log(`   ✅ تم الإرسال (الحالة: ${res.status}). الزر سيتحول إلى "قيد المراجعة".\n`);

  // ==========================================
  // 2. تطبيق الأدمن (Admin App)
  // ==========================================
  console.log('🛡️ [تطبيق الأدمن]: فتح شاشة "طلبات المناديب"...');
  const admin = await User.findOne({ role: 'admin' });
  const adminToken = jwt.sign({ id: admin._id, role: 'admin' }, process.env.JWT_SECRET);

  // محاكاة جلب الطلبات (GET /api/admins/drivers/applications)
  res = await fetch(`${base}/api/admins/drivers/applications`, {
    headers: { 'Authorization': `Bearer ${adminToken}` }
  });
  let data = await res.json();
  const targetApp = data.drivers.find(d => d.phone === `777${id}`);
  
  if (targetApp) {
    console.log(`   🔍 وجد طلب المندوب (${targetApp.name}).`);
    console.log(`   🖼️ فحص الوثائق: تم استلام صورة البطاقة؟ ${targetApp.docNationalId ? 'نعم ✅' : 'لا ❌'}`);
  }

  // محاكاة ضغط زر "قبول" (PUT /api/admins/drivers/:id/verify)
  console.log(`   👆 الأدمن يضغط على "قبول"...`);
  await fetch(`${base}/api/admins/drivers/${targetApp._id}/verify`, {
    method: 'PUT',
    headers: { 'Authorization': `Bearer ${adminToken}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ action: 'accept' })
  });

  // التأكد من أن الطلب اختفى من قائمة "المعلق" (الفلتر)
  res = await fetch(`${base}/api/admins/drivers/applications`, { headers: { 'Authorization': `Bearer ${adminToken}` } });
  data = await res.json();
  const stillPending = data.drivers.find(d => d.phone === `777${id}`);
  console.log(`   🗑️ هل اختفى الطلب من قائمة "معلق"؟ ${!stillPending ? 'نعم ✅' : 'لا ❌'}\n`);

  // ==========================================
  // 3. عودة المستخدم (Client App)
  // ==========================================
  console.log('📱 [تطبيق العميل]: المستخدم يفتح التطبيق مرة أخرى (Refresh)...');
  const updatedUser = await User.findById(client._id);
  console.log(`   - الدور الجديد في قاعدة البيانات: ${updatedUser.role}`);
  console.log(`   - حالة المندوب: ${updatedUser.driverStatus}`);
  
  if (updatedUser.role === 'driver') {
    console.log(`   🎉 النتيجة: التطبيق سيفتح واجهة المندوب (Driver App) تلقائياً!`);
  } else {
    console.log(`   ❌ النتيجة: المستخدم لا يزال عميلاً.`);
  }

  // تنظيف
  await User.findByIdAndDelete(client._id);
  await mongoose.disconnect();
  console.log('\n🏁 انتهت المحاكاة وتم مسح البيانات.');
}

simulate().catch(err => console.error('❌ خطأ:', err.message));
