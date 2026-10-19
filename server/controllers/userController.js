const User = require('../models/User');

exports.applyAsDriver = async (req, res) => {
  try {
    const { name, nationalId, vehicleType, vehicleModel, plateNumber, docNationalId, docLicense, docRegistration, docVehiclePhoto } = req.body;
    
    // البحث عن المستخدم وتحديثه
    const user = await User.findById(req.user._id || req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    user.name = name || user.name;
    user.driverStatus = 'pending'; // هذه هي النقطة الأهم
    user.vehicleType = vehicleType;
    user.vehicleModel = vehicleModel;
    user.plateNumber = plateNumber;
    user.docNationalId = docNationalId;
    user.docLicense = docLicense;
    user.docRegistration = docRegistration;
    user.docVehiclePhoto = docVehiclePhoto;
    
    await user.save();
    console.log(`✅ المستخدم ${user.phone} قدم طلب مندوب بنجاح.`);
    res.status(200).json({ success: true, message: 'تم إرسال الطلب بنجاح' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: err.message });
  }
};
