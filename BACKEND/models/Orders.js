// models/Order.js
import mongoose from 'mongoose';

const orderSchema = new mongoose.Schema({
  orderNumber: {
    type: String,
    required: true,
    unique: true
  },
  donationId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Donation',
    required: true
  },
  foodName: {
    type: String,
    required: true
  },
  quantity: {
    type: String,
    required: true
  },
  description: String,
  pickupLocation: {
    type: String,
    required: true
  },
  dropLocation: {
    type: String,
    required: true
  },
  pickupCoordinates: {
    latitude: Number,
    longitude: Number
  },
  dropCoordinates: {
    latitude: Number,
    longitude: Number
  },
  estimatedDistance: Number,
  status: {
    type: String,
    enum: ['pending', 'accepted', 'in_transit', 'delivered', 'cancelled'],
    default: 'pending'
  },
  volunteerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Generate a unique order number before saving
orderSchema.pre('save', async function(next) {
  if (!this.isNew) return next();
  
  const count = await this.constructor.countDocuments();
  this.orderNumber = `ORD-${Date.now().toString().slice(-6)}-${count}`;
  next();
});

const Order = mongoose.model('Order', orderSchema);
export default Order;