const mongoose = require('mongoose');

const tripSchema = new mongoose.Schema({
  driverId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  fromGovernorate: { type: String, required: true },
  toGovernorate: { type: String, required: true },
  departureTime: { type: Date, required: true },
  vehicleType: { type: String, default: 'باص' },
  totalSeats: { type: Number, required: true },
  availableSeats: { type: Number, required: true },
  pricePerSeat: { type: Number, required: true },
  status: { 
    type: String, 
    enum: ['scheduled', 'ongoing', 'completed', 'cancelled'], 
    default: 'scheduled' 
  }
}, { timestamps: true });

module.exports = mongoose.model('Trip', tripSchema);
