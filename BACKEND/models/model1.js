import mongoose from "mongoose";

const donSchema = new mongoose.Schema({
    foodName: { type: String, required: true },
    quantity: { type: String, required: true },
    description: { type: String, required: true },
    expiryDateTime: { type: String, required: true },
    foodType: { type: String, required: true },
    location: { type: String, required: true },
    imageUrl: { type: String, required: true },
    organizationName: { type: String, required: true }, // Added organization name
    latitude: { type: Number, required: true },   // Added for location filtering
    longitude: { type: Number, required: true } ,  // Added for location filtering
    isAccepted: { type: Boolean, default: false }
}, {
    timestamps: true
});

const model1 = mongoose.models.donations || mongoose.model("donations", donSchema);

export default model1;