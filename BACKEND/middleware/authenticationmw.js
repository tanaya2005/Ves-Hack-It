// authMiddleware.js (New file to handle authentication)
import jwt from "jsonwebtoken";
import DonorModel from "../models/donorModel.js";
import RecipientModel from "../models/recipientModel.js";
import VolunteerModel from "../models/volunteerModel.js";

const authMiddleware = async (req, res, next) => {
    const token = req.header("Authorization");
    
    if (!token) {
        return res.status(401).json({ success: false, message: "Access denied. No token provided." });
    }
    
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        
        let user = await DonorModel.findById(decoded.id) || 
                   await RecipientModel.findById(decoded.id) || 
                   await VolunteerModel.findById(decoded.id);
        
        if (!user) {
            return res.status(401).json({ success: false, message: "Invalid token." });
        }

        req.user = user; // Attach user to request
        next();
    } catch (error) {
        res.status(400).json({ success: false, message: "Invalid token." });
    }
};

export default authMiddleware;

export const authenticateUser = async (req, res, next) => {
    try {
        const token = req.headers.authorization?.split(' ')[1];
        
        if (!token) {
            return res.status(401).json({ message: 'Authentication required' });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        next();
    } catch (error) {
        return res.status(401).json({ message: 'Invalid or expired token' });
    }
};
