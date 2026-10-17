const mongoose = require('mongoose');
require('dotenv').config();
const User = require('./models/User');
const Store = require('./models/Store');
const Product = require('./models/Product');
const Order = require('./models/Order');
const Wallet = require('./models/Wallet');

async function runFinanceSimulation() {
  console.log('🎬 بدء محاكاة الدفع كاش، كود التسليم، والمديونية...\n');
  await mongoose.connect(process.env.MONGO_URI);

  const id = Date.now().toString().slice(-4);
  const pass = '123456';

  // 1. تجهيز المستخدمين (نضع حد أقصى للمديونية 1000 ريال مثلاً)
  const merchant = await User.create({ name: 'التاجر', phone: `771${id}`, role: 'merchant', email: `m${id}@t.com`, password: pass });
  const customer = await User.create({ name: 'الزبون', phone: `772${id}`, role: 'client', email: `c${id}@t.com`, password: pass });
  const driver = await User.create({ name: 'المندوب', phone: `773${id}`, role: 'driver', email: `d${id}@t.com`, password: pass, maxDebtLimit: 1000 }); // حد المديونية 1000

  const store = await Store.create({ name: 'متجر كاش', merchantId: merchant._id, category: 'مطاعم', isVerified: true, isActive: true, commission: 5 });
  const product = await Product.create({ name: 'وجبة كاش', price: 1000, storeId: store._id, isAvailable: true });
  
  const deliveryFee = 500;
  const deliveryPin = '1234'; // كود التسليم الذي سيطلبه المندوب من الزبون

  // 2. الزبون يطلب (الدفع كاش)
  let order = await Order.create({
    customerId: customer._id, merchantId: merchant._id, storeId: store._id,
    items: [{ name: product.name, price: product.price, quantity: 1 }],
    total: product.price + deliveryFee,
    status: 'ready',
    paymentMethod: 'cash', // الدفع كاش
    deliveryPin: deliveryPin,
    isCashCollected: false
  });
  console.log(`🛒 1. الزبون طلب وجبة كاش. الإجمالي المطلوب للمندوب: 1500 ريال.`);

  // 3. المندوب يقبل الطلب
  order.driverId = driver._id;
  order.status = 'delivering';
  await order.save();
  console.log(`🏍️ 2. المندوب قبل الطلب وفي الطريق للزبون.`);

  // 4. المندوب يصل ويطلب الإغلاق (محاولة خاطئة)
  console.log(`🔒 3. المندوب وصل وطلب إغلاق الطلب (بدون كود)...`);
  if (order.deliveryPin !== 'wrong') {
    console.log(`❌ رفض الإغلاق: يجب إدخال كود التسليم الصحيح من الزبون!`);
  }

  // 5. إدخال الكود الصحيح (الكاش تم تحصيله)
  console.log(`🔑 4. المندوب أدخل الكود الصحيح (1234) واستلم الكاش.`);
  order.status = 'delivered';
  order.isCashCollected = true;
  await order.save();

  // 6. الحسابات المالية في حالة الكاش
  const appCommStore = (product.price * 5) / 100; // 50
  const appCommDelivery = (deliveryFee * 15) / 100; // 75
  const totalAppRevenue = appCommStore + appCommDelivery; // 125
  
  const merchantShare = product.price - appCommStore; // 950
  const driverShare = deliveryFee - appCommDelivery; // 425

  // المندوب معه 1500 كاش. من حقه 425. إذن هو مدين للتطبيق بـ (1500 - 425) = 1075
  const driverDebt = order.total - driverShare; // 1075

  console.log(`\n💰 5. التقرير المالي للدفع كاش:`);
  console.log(`   - التطبيق أرباحه: ${totalAppRevenue} ريال.`);
  console.log(`   - التاجر مستحقاته: ${merchantShare} ريال.`);
  console.log(`   - المندوب مستحقاته: ${driverShare} ريال.`);
  console.log(`   - المندوب يحمل كاش: ${order.total} ريال.`);
  
  // تحديث المحافظ
  await Wallet.create({ userId: merchant._id, balance: merchantShare }); // التاجر دائن
  await Wallet.create({ userId: driver._id, balance: -driverDebt }); // المندوب مدين (سالب)
  console.log(`\n💳 6. تم تحديث المحافظ: التاجر (+${merchantShare}) | المندوب (${-driverDebt})`);

  // 7. محاكاة محاولة المندوب استلام طلب جديد (الحد الأقصى للمديونية)
  console.log(`\n⚠️ 7. المندوب حاول استلام طلب جديد...`);
  const driverWallet = await Wallet.findOne({ userId: driver._id });
  const currentDebt = Math.abs(driverWallet.balance); // 1075
  
  if (currentDebt >= driver.maxDebtLimit) {
    console.log(`❌ مرفوض! لقد وصلت للحد الأقصى للمديونية (${driver.maxDebtLimit}). يجب التسديد أولاً.`);
  } else {
    console.log(`✅ يمكنه استلام طلب جديد.`);
  }

  // تنظيف
  await Order.findByIdAndDelete(order._id);
  await Product.findByIdAndDelete(product._id);
  await Store.findByIdAndDelete(store._id);
  await Wallet.deleteMany({ userId: { $in: [merchant._id, driver._id] } });
  await User.deleteMany({ _id: { $in: [merchant._id, customer._id, driver._id] } });

  console.log('\n🏁 انتهت محاكاة الكاش والمديونية.');
  await mongoose.disconnect();
}

runFinanceSimulation().catch(err => console.error('❌ خطأ:', err.message));
