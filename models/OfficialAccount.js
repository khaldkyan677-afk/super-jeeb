const mongoose = require('mongoose');
const officialAccountSchema = new mongoose.Schema({
  name: { type: String, required: true },
  number: { type: String, required: true },
  type: { type: String },
  isActive: { type: Boolean, default: true },
  addedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
});
module.exports = mongoose.model('OfficialAccount', officialAccountSchema);
