import express from 'express';
import Order from '../models/Orders.js';
import VolunteerModel from '../models/volunteerModel.js';
import { authenticateUser } from '../middleware/authenticationmw.js';

const router = express.Router();

// Get all available orders for volunteers
router.get('/live-orders', authenticateUser, async (req, res) => {
    try {
        // Only show orders that are pending and have no volunteer assigned
        const availableOrders = await Order.find({
            status: 'pending',
            volunteerId: null
        }).sort({ createdAt: -1 });
        
        res.json(availableOrders);
    } catch (error) {
        console.error('Error fetching live orders:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Accept an order
router.post('/accept-order/:orderId', authenticateUser, async (req, res) => {
    try {
        const { orderId } = req.params;
        const volunteerId = req.user.id;
        
        // Find the volunteer
        const volunteer = await Volunteer.findById(volunteerId);
        if (!volunteer) {
            return res.status(404).json({ message: 'Volunteer not found' });
        }

        // Find the order and check if it's still available
        const order = await Order.findOne({
            _id: orderId,
            status: 'pending',
            volunteerId: null
        });
        
        if (!order) {
            return res.status(404).json({ message: 'Order not found or already accepted' });
        }
        
        // Update the order with volunteer info and change status
        order.volunteerId = volunteerId;
        order.status = 'accepted';
        await order.save();

        // Add order to volunteer's active orders
        volunteer.activeOrders.push(orderId);
        await volunteer.save();
        
        res.json({ success: true, message: 'Order accepted successfully' });
    } catch (error) {
        console.error('Error accepting order:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Get volunteer's active deliveries
router.get('/my-deliveries', authenticateUser, async (req, res) => {
    try {
        const volunteerId = req.user.id;
        
        const activeDeliveries = await Order.find({
            volunteerId,
            status: { $in: ['accepted', 'in_transit'] }
        }).sort({ createdAt: -1 });
        
        res.json(activeDeliveries);
    } catch (error) {
        console.error('Error fetching active deliveries:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Update delivery status
router.put('/update-status/:orderId', authenticateUser, async (req, res) => {
    try {
        const { orderId } = req.params;
        const { status } = req.body;
        const volunteerId = req.user.id;
        
        // Validate the new status
        if (!['in_transit', 'delivered'].includes(status)) {
            return res.status(400).json({ message: 'Invalid status' });
        }
        
        const volunteer = await Volunteer.findById(volunteerId);
        if (!volunteer) {
            return res.status(404).json({ message: 'Volunteer not found' });
        }

        // Find the order and check if it belongs to this volunteer
        const order = await Order.findOne({
            _id: orderId,
            volunteerId
        });
        
        if (!order) {
            return res.status(404).json({ message: 'Order not found or not assigned to you' });
        }
        
        // Update the status
        order.status = status;
        await order.save();

        // If order is delivered, move it from active to completed orders
        if (status === 'delivered') {
            volunteer.activeOrders = volunteer.activeOrders.filter(
                order => order.toString() !== orderId
            );
            volunteer.completedOrders.push(orderId);
            await volunteer.save();
        }
        
        res.json({ success: true, message: `Order status updated to ${status}` });
    } catch (error) {
        console.error('Error updating order status:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

export default router;