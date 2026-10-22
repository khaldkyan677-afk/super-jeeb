const mongoose = require('mongoose');
const dotenv = require('dotenv');
const path = require('path');

dotenv.config({ path: path.join(__dirname, '.env') });

async function check() {
  console.log('🔍 جاري فحص الاتصال الفعلي بقاعدة البيانات...\n');

  if (!process.env.MONGO_URI) {
    console.log('⚠️ تنبيه: لم يتم العثور على رابط MONGO_URI داخل ملف server/.env');
    process.exit(1);
  }

  try {
    const conn = await mongoose.connect(process.env.MONGO_URI, { serverSelectionTimeoutMS: 5000 });
    console.log(`✅ نعم! التطبيق مربوط ومتصل بقاعدة البيانات بنجاح.`);
    console.log(`🌐 المضيف (Host): ${conn.connection.host}`);
    console.log(`📁 اسم قاعدة البيانات: ${conn.connection.name}`);

    // جلب الإحصائيات الحالية لتأكيد الربط
    const User = require('./models/User');
    const Store = require('./models/Store');
    const Order = require('./models/Order');

    const [usersCount, storesCount, ordersCount] = await Promise.all([
      User.countDocuments(),
      Store.countDocuments(),
      Order.countDocuments()
    ]);

    console.log('\n📊 إحصائيات السجلات في القاعدة الآن:');
    console.log(`   - عدد المستخدمين: ${usersCount}`);
    console.log(`   - عدد المتاجر: ${storesCount}`);
    console.log(`   - عدد الطلبات: ${ordersCount}`);

    await mongoose.disconnect();
  } catch (err) {
    console.log(`❌ فشل الاتصال بقاعدة البيانات: ${err.message}`);
    process.exit(1);
  }
}

check();
