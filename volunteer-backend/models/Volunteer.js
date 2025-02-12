const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const VolunteerSchema = new mongoose.Schema({
  fullName: { type: String, required: true },
  phone: { type: String, required: true },
  address: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true }
});

// Hash password before saving
VolunteerSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

const Volunteer = mongoose.model('Volunteer', VolunteerSchema);
module.exports = Volunteer;
