const mongoose = require('mongoose');

const serviceRequestSchema = new mongoose.Schema({
  customerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  driverId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null },
  serviceType: { 
    type: String, 
    enum: ['taxi', 'parcel', 'buy_for_me', 'super_express'], 
    required: true 
  },
  pickupLocation: {
    lat: { type: Number },
    lng: { type: Number },
    address: { type: String }
  },
  dropoffLocation: {
    lat: { type: Number },
    lng: { type: Number },
    address: { type: String }
  },
  details: { type: String, default: '' },
  price: { type: Number, required: true },
  deliveryPin: { type: String },
  status: { 
    type: String, 
    enum: ['pending', 'accepted', 'ongoing', 'completed', 'cancelled'], 
    default: 'pending' 
  },
  paymentMethod: { type: String, default: 'cash' },
  isCashCollected: { type: Boolean, default: false }
}, { timestamps: true });

module.exports = mongoose.model('ServiceRequest', serviceRequestSchema);
