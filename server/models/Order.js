const mongoose = require('mongoose');

function generateSecurePin() {
  let pin;
  let isWeak = true;
  const weak = ['1234','2345','3456','4567','5678','6789','9876','8765','7654','6543','5432','4321','0000','1111','2222','3333','4444','5555','6666','7777','8888','9999'];
  while (isWeak) {
    pin = Math.floor(1000 + Math.random() * 9000).toString();
    if (!weak.includes(pin) && !(pin[0] === pin[2] && pin[1] === pin[3])) isWeak = false;
  }
  return pin;
}

const orderSchema = new mongoose.Schema({
  customerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  merchantId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  storeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Store' },
  driverId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  items: [{ name: String, price: Number, quantity: Number }],
  total: { type: Number, required: true },
  status: { type: String, default: 'pending' },
  paymentStatus: { type: String, default: 'unpaid' },
  paymentMethod: { type: String, default: 'cash' },
  verificationStatus: { type: String, default: 'none' },
  receiptImage: { type: String },
  address: { type: String },
  commission: { type: Number, default: 0 },
  merchantShare: { type: Number, default: 0 },
  driverShare: { type: Number, default: 0 },
  deliveryPin: { type: String },
  pinAttempts: { type: Number, default: 0 }
});

// التوليد التلقائي عند الحفظ
orderSchema.pre("save", function() {
  if (this.isNew && !this.deliveryPin) {
    this.deliveryPin = generateSecurePin();
  }

});

module.exports = mongoose.model('Order', orderSchema);
