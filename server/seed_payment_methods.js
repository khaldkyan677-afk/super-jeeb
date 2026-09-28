const mongoose = require('mongoose');
require('dotenv').config();

(async () => {
  await mongoose.connect(process.env.MONGO_URI);
  const PM = require('./models/PaymentMethod');

  const methods = [
    { name: 'كاش', code: 'cash', type: 'cash', icon: 'payments', order: 1, isActive: true, isDefault: true },
    { name: 'جوالي', code: 'jawali', type: 'wallet', icon: 'phone_android', order: 2, isActive: true },
    { name: 'ون كاش', code: 'one_cash', type: 'wallet', icon: 'wallet', order: 3, isActive: true },
    { name: 'بن دول باي', code: 'bin_dollar', type: 'wallet', icon: 'credit_card', order: 4, isActive: true },
    { name: 'فلوسك', code: 'floosak', type: 'wallet', icon: 'account_balance_wallet', order: 5, isActive: true },
  ];

  for (const m of methods) {
    const exists = await PM.findOne({ code: m.code });
    if (!exists) {
      await PM.create(m);
      console.log('✓ Created:', m.name);
    } else {
      console.log('✓ Exists:', m.name);
    }
  }

  const count = await PM.countDocuments();
  console.log('\nTotal payment methods:', count);
  process.exit(0);
})();
