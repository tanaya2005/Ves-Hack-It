const mongoose = require('mongoose');

// Common fields shared between user types
const userFields = {
  username: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  contact: { type: String, required: true },
  currentPassword: { type: String, required: true },
  about: String,
  profileImage: String,
  latitude: Number,
  longitude: Number,
  createdAt: { type: Date, default: Date.now }
};

// Donor Schema
const DonorSchema = new mongoose.Schema({
  ...userFields,
  userType: { type: String, default: 'donor' },
  orgName: { type: String, required: true }
});

// Recipient Schema
const RecipientSchema = new mongoose.Schema({
  ...userFields,
  userType: { type: String, default: 'recipient' },
  orgName: { type: String, required: true }
});

// Volunteer Schema
const VolunteerSchema = new mongoose.Schema({
  ...userFields,
  userType: { type: String, default: 'volunteer' },
  identificationDoc: { type: String, required: true },
  docImage: String
});

// Donation Schema
const DonationSchema = new mongoose.Schema({
  foodName: { type: String, required: true },
  quantity: { type: Number, required: true },
  description: { type: String, required: true },
  expiryDateTime: { type: Date, required: true },
  isVeg: { type: Boolean, default: false },
  isNonVeg: { type: Boolean, default: false },
  imageUrl: String,
  location: { type: String, required: true },
  latitude: Number,
  longitude: Number,
  needsVolunteer: { type: Boolean, default: false },
  isAccepted: { type: Boolean, default: false },
  acceptedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'Recipient' },
  donorId: { type: mongoose.Schema.Types.ObjectId, ref: 'Donor' },
  createdAt: { type: Date, default: Date.now }
});

// Accepted Donation Schema
const AcceptedDonationSchema = new mongoose.Schema({
  ...DonationSchema.obj,
  originalDonationId: { type: mongoose.Schema.Types.ObjectId, ref: 'Donation' },
  postedBy: String
});

// Create models
const Donor = mongoose.model('Donor', DonorSchema);
const Recipient = mongoose.model('Recipient', RecipientSchema);
const Volunteer = mongoose.model('Volunteer', VolunteerSchema);
const Donation = mongoose.model('Donation', DonationSchema);
const AcceptedDonation = mongoose.model('AcceptedDonation', AcceptedDonationSchema);

// Export all models
module.exports = {
  Donor,
  Recipient,
  Volunteer,
  Donation,
  AcceptedDonation
};