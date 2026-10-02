const Favorite = require('../models/Favorite');
exports.toggle = async (req, res) => {
  try {
    const { storeId } = req.params;
    const existing = await Favorite.findOne({ userId: req.user._id, storeId });
    if (existing) {
      await Favorite.deleteOne({ _id: existing._id });
      return res.json({ favorited: false });
    }
    await Favorite.create({ userId: req.user._id, storeId });
    res.status(201).json({ favorited: true });
  } catch (e) { res.status(500).json({ message: e.message }); }
};
exports.getMyFavorites = async (req, res) => {
  try {
    const favs = await Favorite.find({ userId: req.user._id });
    res.json(favs);
  } catch (e) { res.status(500).json({ message: e.message }); }
};
