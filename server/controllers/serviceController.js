const ServiceRequest = require('../models/ServiceRequest');

exports.createService = async (req, res) => {
  try {
    const { serviceType, pickupLocation, dropoffLocation, details, price } = req.body;
    const service = await ServiceRequest.create({
      customerId: req.user._id, serviceType, pickupLocation, dropoffLocation, details, price,
      deliveryPin: Math.floor(1000 + Math.random() * 9000).toString()
    });
    res.status(201).json({ success: true, service });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getPendingServices = async (req, res) => {
  try {
    const services = await ServiceRequest.find({ status: 'pending' }).populate('customerId', 'name phone');
    res.json({ success: true, services });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.acceptService = async (req, res) => {
  try {
    const service = await ServiceRequest.findByIdAndUpdate(
      req.params.id,
      { driverId: req.user._id, status: 'accepted' },
      { new: true }
    );
    res.json({ success: true, service });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.completeService = async (req, res) => {
  try {
    const { pin } = req.body;
    const service = await ServiceRequest.findById(req.params.id);
    if (service.deliveryPin !== pin) return res.status(400).json({ message: 'كود خاطئ' });
    service.status = 'completed';
    await service.save();
    res.json({ success: true, service });
  } catch (err) { res.status(500).json({ message: err.message }); }
};
