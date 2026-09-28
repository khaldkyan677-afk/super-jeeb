const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  phone: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  role: { 
    type: String, 
    enum: ['client', 'merchant', 'driver', 'admin'], 
    default: 'client' 
  },
  wallet: { type: Number, default: 0 },
  defaultPaymentMethod: { type: String, default: 'cash' },
  defaultPayoutAccountId: { type: mongoose.Schema.Types.ObjectId, ref: 'PayoutAccount' },
  phoneVerified: { type: Boolean, default: false },
  emailVerified: { type: Boolean, default: false },
  totalSpent: { type: Number, default: 0 },
  totalEarned: { type: Number, default: 0 },
  referralCode: { type: String, unique: true, sparse: true },
  referredBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  loyaltyPoints: { type: Number, default: 0 },
  loyaltyTier: { type: String, enum: ['bronze', 'silver', 'gold'], default: 'bronze' },
  status: { type: String, enum: ['pending', 'approved', 'rejected'], default: 'pending' },
    isActive: { type: Boolean, default: true },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('User', userSchema);
