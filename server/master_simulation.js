const mongoose = require('mongoose');
require('dotenv').config();
const User = require('./models/User');
const Store = require('./models/Store');
const Product = require('./models/Product');
const Order = require('./models/Order');

async function masterSimulation() {
  console.log('🎬 بدء المحاكاة الشاملة (بدون حذف البيانات)...\n');
  await mongoose.connect(process.env.MONGO_URI);

  const id = Date.now().toString().slice(-4);
  const pass = '123456';

  const merchantUser = await User.create({ name: 'التاجر_علي', phone: `771${id}`, role: 'client', email: `m${id}@t.com`, password: pass });
  const buyerUser = await User.create({ name: 'الزبون_سالم', phone: `772${id}`, role: 'client', email: `b${id}@t.com`, password: pass });
  const driverUser = await User.create({ name: 'المندوب_أحمد', phone: `773${id}`, role: 'driver', email: `d${id}@t.com`, password: pass });
  console.log(`👥 1. تم تسجيل 4 مستخدمين.`);

  let store = await Store.create({ name: 'مطعم السعادة', merchantId: merchantUser._id, category: 'مطاعم', phone: `771${id}`, isVerified: false, commission: 5 });
  console.log(`🏪 2. التاجر (علي) قدم طلب متجر (معلق).`);
  
  store.isVerified = true; store.isActive = true; store.documentsVerified = true;
  await store.save();
  await User.findByIdAndUpdate(merchantUser._id, { role: 'merchant' });
  console.log(`✅ 3. الأدمن وثق المتجر.`);

  const product = await Product.create({ name: 'برجر دبل', price: 1000, storeId: store._id, category: 'مطاعم', isAvailable: true });
  console.log(`🍔 4. التاجر أضاف منتج (برجر دبل) بسعر 1000.`);

  const deliveryFee = 500;
  let order = await Order.create({
    customerId: buyerUser._id, merchantId: merchantUser._id, storeId: store._id, 
    items: [{ name: product.name, price: product.price, quantity: 1 }],
    total: product.price + deliveryFee,
    status: 'pending', paymentMethod: 'wallet', paymentStatus: 'unpaid', verificationStatus: 'pending',
    receiptImage: 'receipt.jpg', address: 'شارع حدة، صنعاء'
  });
  console.log(`🛒 5. الزبون طلب البرجر. الإجمالي: ${order.total}.`);

  order.paymentStatus = 'paid';
  order.verificationStatus = 'verified';
  await order.save();
  console.log(`💳 6. الأدمن راجع السند وقبل الدفع.`);

  order.status = 'accepted'; await order.save();
  order.status = 'preparing'; await order.save();
  order.status = 'ready'; await order.save();
  console.log(`📦 7. التاجر قبل وجهز الطلب.`);

  const radarOrders = await Order.find({ status: 'ready' });
  console.log(`📡 8. تطبيق المندوب يرصد ${radarOrders.length} طلب في الرادار.`);
  
  order.driverId = driverUser._id;
  order.status = 'delivering';
  await order.save();
  console.log(`🏍️ 9. المندوب قبل الطلب، وفي الطريق.`);

  order.status = 'delivered';
  await order.save();
  console.log(`🏁 10. المندوب سلّم الطلب. تم إغلاق الطلب.\n`);

  const appCommissionStore = (product.price * (store.commission || 5)) / 100;
  const appCommissionDelivery = (deliveryFee * 15) / 100;
  const totalAppRevenue = appCommissionStore + appCommissionDelivery;
  const merchantEarnings = product.price - appCommissionStore;
  const driverEarnings = deliveryFee - appCommissionDelivery;

  console.log('💰 === التقرير المالي ===');
  console.log(`💵 إجمالي الزبون: ${order.total}`);
  console.log(`🏪 مستحقات التاجر: ${merchantEarnings}`);
  console.log(`🏍️ مستحقات المندوب: ${driverEarnings}`);
  console.log(`🛡️ ربح التطبيق: ${totalAppRevenue}.`);

  order.commission = totalAppRevenue;
  order.merchantShare = merchantEarnings;
  order.driverShare = driverEarnings;
  await order.save();

  console.log('\n✅ تم حفظ جميع البيانات في قاعدة البيانات بنجاح.');
  await mongoose.disconnect();
}

masterSimulation().catch(err => console.error('❌ خطأ:', err.message));
