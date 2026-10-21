const Favorite = require('../models/Favorite');
const Store = require('../models/Store');

exports.addFavorite = async (req, res) => {
  try {
    const { storeId } = req.params;
    const existing = await Favorite.findOne({ userId: req.user._id, storeId });
    if (existing) return res.status(200).json({ favorited: true });
    await Favorite.create({ userId: req.user._id, storeId });
    res.status(201).json({ favorited: true });
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.removeFavorite = async (req, res) => {
  try {
    const { storeId } = req.params;
    await Favorite.deleteOne({ userId: req.user._id, storeId });
    res.status(200).json({ favorited: false });
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.getMyFavorites = async (req, res) => {
  try {
    const favs = await Favorite.find({ userId: req.user._id }).populate('storeId');
    res.json(favs);
  } catch (e) { res.status(500).json({ message: e.message }); }
};
