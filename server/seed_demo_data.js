const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '.env') });

const User = require('./models/User');
const Store = require('./models/Store');
const Product = require('./models/Product');
const Section = require('./models/Section');

async function seed() {
  await mongoose.connect(process.env.MONGO_URI);
  console.log('🌱 جاري زرع الحسابات والبيانات التجريبية...');

  const salt = await bcrypt.genSalt(10);
  const defaultPass = await bcrypt.hash('123456', salt);

  // 1. أقسام رئيسية
  let sec = await Section.findOne({ name: 'مطاعم' });
  if (!sec) {
    sec = await Section.create({ name: 'مطاعم', iconName: 'restaurant', order: 1, isActive: true });
  }

  // 2. حساب تاجر
  let merchant = await User.findOne({ email: 'merchant@test.com' });
  if (!merchant) {
    merchant = await User.create({
      name: 'التاجر علي',
      email: 'merchant@test.com',
      phone: '771000001',
      password: defaultPass,
      role: 'merchant',
      status: 'approved',
      isActive: true
    });
  }

  // 3. متجر معتمد للتاجر
  let store = await Store.findOne({ merchantId: merchant._id });
  if (!store) {
    store = await Store.create({
      name: 'مطعم البركة',
      merchantId: merchant._id,
      category: 'restaurant',
      sectionId: sec._id,
      phone: '771000001',
      isActive: true,
      isVerified: true,
      documentsVerified: true,
      rating: 4.8,
      commission: 5
    });
  }

  // 4. منتجات للمتجر
  const pCount = await Product.countDocuments({ storeId: store._id });
  if (pCount === 0) {
    await Product.create([
      { name: 'برجر دبل سوبر جيب', price: 2500, storeId: store._id, category: 'مطاعم', isAvailable: true },
      { name: 'بيتزا شاورما عائلي', price: 4000, storeId: store._id, category: 'مطاعم', isAvailable: true }
    ]);
  }

  // 5. حساب مندوب / كابتن
  let driver = await User.findOne({ email: 'driver@test.com' });
  if (!driver) {
    driver = await User.create({
      name: 'الكابتن أحمد',
      email: 'driver@test.com',
      phone: '772000002',
      password: defaultPass,
      role: 'driver',
      status: 'approved',
      isActive: true
    });
  }

  // 6. حساب زبون
  let client = await User.findOne({ email: 'client@test.com' });
  if (!client) {
    client = await User.create({
      name: 'الزبون سالم',
      email: 'client@test.com',
      phone: '773000003',
      password: defaultPass,
      role: 'client',
      status: 'approved',
      isActive: true
    });
  }

  console.log('✅ اكتمل تجهيز الحسابات بنجاح!');
  await mongoose.disconnect();
}

seed().catch(err => {
  console.error('❌ خطأ في التجهيز:', err.message);
  process.exit(1);
});
