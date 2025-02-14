import mongoose from "mongoose";

const volunteerSchema = new mongoose.Schema({
    username: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    contact: { type: String, required: true },
    password: { type: String, required: true },
    userType: { type: String, required: true, default: "volunteer" },
    about: { type: String },
    profileImage: { type: String, required: true },
    skills: { type: String, required: true },
    availability: { type: String, required: true },
    identificationDoc: { type: String, required: true },
    docImage: { type: String, required: true },
    coordinates: {
        latitude: {type: Number,required: false},
    longitude: {type: Number,required: false}
        }
});

const VolunteerModel = mongoose.models.volunteer || mongoose.model("volunteer", volunteerSchema);
export default VolunteerModel;
