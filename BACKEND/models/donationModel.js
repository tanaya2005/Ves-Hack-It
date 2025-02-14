// // models/donationModel.js
// import mongoose from 'mongoose';

// const donationSchema = new mongoose.Schema({
//     foodName: {
//         type: String,
//         required: [true, "Food name is required"]
//     },
//     organizationName: {
//         type: String,
//         required: [true, "Organization name is required"]
//     },
//     quantity: {
//         type: String,
//         required: [true, "Quantity is required"]
//     },
//     description: {
//         type: String,
//         required: [true, "Description is required"]
//     },
//     expiryDateTime: {
//         type: Date,
//         required: [true, "Expiry date and time is required"]
//     },
//     location: {
//         type: String,
//         required: [true, "Location is required"]
//     },
//     latitude: {
//         type: Number,
//         required: [true, "Latitude is required"]
//     },
//     longitude: {
//         type: Number,
//         required: [true, "Longitude is required"]
//     },
//     imageUrl: {
//         type: String,
//         required: [true, "Image URL is required"]
//     },
//     donorId: {
//         type: mongoose.Schema.Types.ObjectId,
//         ref: 'User',
//         required: [true, "Donor ID is required"]
//     },
//     status: {
//         type: String,
//         enum: ['available', 'accepted', 'completed'],
//         default: 'available'
//     },
//     acceptedBy: {
//         type: mongoose.Schema.Types.ObjectId,
//         ref: 'User',
//         default: null
//     },
//     acceptedAt: {
//         type: Date,
//         default: null
//     },
//     createdAt: {
//         type: Date,
//         default: Date.now
//     },
//     updatedAt: {
//         type: Date,
//         default: Date.now
//     }
// }, {
//     timestamps: true
// });

// // Add index for location-based queries
// donationSchema.index({ latitude: 1, longitude: 1 });

// // Pre-save middleware to update the updatedAt field
// donationSchema.pre('save', function(next) {
//     this.updatedAt = new Date();
//     next();
// });

// // Virtual field for distance calculation (can be used when needed)
// donationSchema.virtual('distance').get(function() {
//     return this._distance;
// });

// donationSchema.set('toJSON', {
//     virtuals: true,
//     transform: function(doc, ret) {
//         ret.id = ret._id;
//         delete ret._id;
//         delete ret.__v;
//         return ret;
//     }
// });

// const DonationModel = mongoose.model('Donation', donationSchema);

// export default DonationModel;