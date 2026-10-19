const User = require('../models/User');

exports.applyAsDriver = async (req, res) => {
  try {
    const { name, nationalId, vehicleType, vehicleModel, plateNumber } = req.body;
    
    const user = await User.findById(req.user._id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    user.name = name || user.name;
    user.driverStatus = 'pending';
    user.vehicleType = vehicleType;
    user.vehicleModel = vehicleModel;
    user.plateNumber = plateNumber;
    user.docNationalId = req.body.docNationalId;
    user.docLicense = req.body.docLicense;
    user.docRegistration = req.body.docRegistration;
    user.docVehiclePhoto = req.body.docVehiclePhoto;
    // هنا يمكن إضافة حفظ الوثائق إذا كانت مرفوعة
    
    await user.save();
    res.status(200).json({ success: true, message: 'تم إرسال الطلب بنجاح' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
