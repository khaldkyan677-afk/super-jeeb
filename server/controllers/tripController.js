const Trip = require('../models/Trip');
const Booking = require('../models/Booking');

exports.createTrip = async (req, res) => {
  try {
    const { fromGovernorate, toGovernorate, departureTime, vehicleType, totalSeats, pricePerSeat } = req.body;
    const trip = await Trip.create({
      driverId: req.user._id, fromGovernorate, toGovernorate, departureTime, vehicleType,
      totalSeats, availableSeats: totalSeats, pricePerSeat
    });
    res.status(201).json({ success: true, trip });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.searchTrips = async (req, res) => {
  try {
    const { from, to } = req.query;
    const trips = await Trip.find({ fromGovernorate: from, toGovernorate: to, status: 'scheduled' }).populate('driverId', 'name phone');
    res.json({ success: true, trips });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.bookTrip = async (req, res) => {
  try {
    const { seatsBooked } = req.body;
    const trip = await Trip.findById(req.params.id);
    if (trip.availableSeats < seatsBooked) return res.status(400).json({ message: 'المقاعد غير كافية' });
    
    const booking = await Booking.create({
      tripId: trip._id, customerId: req.user._id, seatsBooked,
      totalPrice: trip.pricePerSeat * seatsBooked,
      deliveryPin: Math.floor(1000 + Math.random() * 9000).toString()
    });

    trip.availableSeats -= seatsBooked;
    await trip.save();
    res.status(201).json({ success: true, booking });
  } catch (err) { res.status(500).json({ message: err.message }); }
};
