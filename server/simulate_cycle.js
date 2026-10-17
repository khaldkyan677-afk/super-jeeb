const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const User = require('./models/User');
const Store = require('./models/Store');
const Order = require('./models/Order');
const Product = require('./models/Product');

async function runCycle() {
  console.log('🚀 بدء محاكاة دورة حياة التطبيق الكاملة...\n');
  await mongoose.connect(process.env.MONGO_URI);

  // 1. تجهيز الأدمن
  const admin = await User.findOne({ role: 'admin' });
  if (!admin) throw new Error('لا يوجد أدمن في DB');
  const adminToken = jwt.sign({ id: admin._id, role: 'admin' }, process.env.JWT_SECRET);
  const adminHeaders = { 'Authorization': `Bearer ${adminToken}`, 'Content-Type': 'application/json' };

  // 2. إنشاء عميل (Client)
  let client = await User.findOne({ phone: '999999991' });
  if (!client) client = await User.create({ name: 'عميل تجريبي', phone: '999999991', role: 'client' });
  const clientToken = jwt.sign({ id: client._id, role: 'client' }, process.env.JWT_SECRET);
  const clientHeaders = { 'Authorization': `Bearer ${clientToken}`, 'Content-Type': 'application/json' };
  console.log('1️⃣ تم إنشاء عميل تجريبي:', client.name);

  // 3. تقديم طلب متجر (من العميل)
  let store = await Store.findOne({ merchantId: client._id });
  if (!store) {
    store = await Store.create({ name: 'متجر المحاكاة', merchantId: client._id, phone: '999999991', isVerified: false, commission: 5 });
  }
  console.log('2️⃣ العميل قدم طلب فتح متجر (معلق):', store.name);

  // 4. الأدمن يقبل المتجر
  store.isVerified = true;
  store.isActive = true;
  store.documentsVerified = true;
  await store.save();
  console.log('3️⃣ الأدمن قام بتوثيق المتجر (أصبح نشطاً)');

  // 5. التاجر يضيف منتج
  let product = await Product.findOne({ storeId: store._id });
  if (!product) {
    product = await Product.create({ name: 'منتج تجريبي', price: 100, storeId: store._id, category: 'general' });
  }
  console.log('4️⃣ التاجر أضاف منتجاً:', product.name, '| السعر:', product.price);

  // 6. إنشاء مندوب
  let driver = await User.findOne({ phone: '999999992' });
  if (!driver) driver = await User.create({ name: 'مندوب تجريبي', phone: '999999992', role: 'driver' });
  const driverToken = jwt.sign({ id: driver._id, role: 'driver' }, process.env.JWT_SECRET);
  const driverHeaders = { 'Authorization': `Bearer ${driverToken}`, 'Content-Type': 'application/json' };
  console.log('5️⃣ تم إنشاء مندوب تجريبي:', driver.name);

  // 7. العميل يطلب المنتج
  let order = await Order.findOne({ userId: client._id });
  if (!order) {
    order = await Order.create({
      userId: client._id,
      storeId: store._id,
      products: [{ productId: product._id, quantity: 1, price: product.price }],
      total: product.price,
      status: 'pending',
      paymentMethod: 'cash'
    });
  }
  console.log('6️⃣ العميل أنشأ طلباً (قيد الانتظار) | الإجمالي:', order.total);

  // 8. المندوب يقبل الطلب
  order.driverId = driver._id;
  order.status = 'accepted';
  await order.save();
  console.log('7️⃣ المندوب قبل الطلب وذهب للمتجر');

  // 9. المندوب يستلم ويوصل الطلب
  order.status = 'delivered';
  await order.save();
  console.log('8️⃣ المندوب سلم الطلب للعميل (مكتمل)');

  // 10. حساب العمولة والمديونية
  const commissionAmount = (order.total * (store.commission || 5)) / 100;
  const merchantNet = order.total - commissionAmount;
  console.log('9️⃣ العمولة المحسوبة للتطبيق:', commissionAmount, '| صافي حق التاجر:', merchantNet);
  
  // هل يوجد حقل للمديونية في المتجر؟
  if (store.schema.path('walletBalance')) {
    store.walletBalance = (store.walletBalance || 0) + merchantNet;
    await store.save();
    console.log('🔟 تمت إضافة المبلغ لمحفظة التاجر');
  } else {
    console.log('⚠️ تنبيه: لا يوجد حقل Wallet/Balance في نموذج المتجر لحفظ المديونية!');
  }

  // تنظيف البيانات التجريبية (إزالة الطلب والمنتج والمتجر والمندوب والعميل)
  await Order.findByIdAndDelete(order._id);
  await Product.findByIdAndDelete(product._id);
  await Store.findByIdAndDelete(store._id);
  await User.findByIdAndDelete(driver._id);
  await User.findByIdAndDelete(client._id);
  
  console.log('\n🏁 انتهت المحاكاة وتم تنظيف البيانات.');
  await mongoose.disconnect();
}

runCycle().catch(err => console.error('❌ فشل في المحاكاة:', err));
