const mongoose = require("mongoose");

const VolunteerSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true }, // Firebase UID
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  phone: { type: String, required: true },
  profilePic: { type: String, default: "" },
  documents: {
    personal: { type: Boolean, default: false },
    vehicle: { type: Boolean, default: false },
    bankDetails: { type: Boolean, default: false },
    emergency: { type: Boolean, default: false },
  },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("Volunteer", VolunteerSchema);
