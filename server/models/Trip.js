const mongoose = require('mongoose');

const tripSchema = new mongoose.Schema({
  customerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  driverId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  from: { type: String, required: true },
  to: { type: String, required: true },
  distance: { type: Number },
  fare: { type: Number, required: true },
  status: { 
    type: String, 
    enum: ['requested', 'accepted', 'ongoing', 'completed', 'cancelled'], 
    default: 'requested' 
  },
  pin: { type: String },
  startedAt: { type: Date },
  endedAt: { type: Date },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Trip', tripSchema);
