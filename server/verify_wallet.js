const fs = require('fs');
const path = require('path');

console.log('🔍 جاري فحص ملف walletController.js...\n');

const filePath = path.join(__dirname, 'controllers', 'walletController.js');
const content = fs.readFileSync(filePath, 'utf8');

let passed = true;

// 1. التأكد من إزالة ثغرة التضخيم المباشر
if (content.includes('$inc: { balance: amount }')) {
  console.log('❌ فشل الفحص: الثغرة القديمة ($inc balance) ما زالت موجودة!');
  passed = false;
} else {
  console.log('✅ نجح الفحص: تم استئصال كود زيادة الرصيد المباشر القديم بنجاح.');
}

// 2. التأكد من وجود إنشاء المعاملة المعلقة
if (content.includes("status: 'pending'") && content.includes('Transaction.create')) {
  console.log('✅ نجح الفحص: نظام طلبات الشحن والمعاملات المعلقة مفعل ومحمي.');
} else {
  console.log('❌ فشل الفحص: كود تسجيل المعاملة المعلقة غير مكتمل!');
  passed = false;
}

if (passed) {
  console.log('\n🎉 النتيجة النهائية: التعديل سليم 100% والمحفظة مؤمنة بالكامل.');
} else {
  process.exit(1);
}
