import model1 from "../models/model1.js";
import fs from "fs";

const add_Dons = async (req, res) => {
    try {
        // Check if a file was uploaded
        if (!req.file) {
            return res.status(400).json({
                success: false,
                message: "No file uploaded. Ensure you are sending a file with key 'image'."
            });
        }

        // Debug: Log the received data
        console.log("Received form data:", req.body);

        // Create new donation with ALL required fields
        const donations = new model1({
            foodName: req.body.foodName,
            quantity: req.body.quantity,
            description: req.body.description,
            expiryDateTime: req.body.expiryDateTime,
            foodType: req.body.foodType,
            location: req.body.location,
            imageUrl: req.file.filename,
            // Add the missing required fields
            organizationName: req.body.organizationName,
            latitude: parseFloat(req.body.latitude),    // Convert to number
            longitude: parseFloat(req.body.longitude)   // Convert to number
        });

        // Debug: Log the donation object before saving
        console.log("Donation object before save:", donations);

        await donations.save();
        res.json({
            success: true,
            message: "Donation added successfully",
            donation: donations
        });
    } catch (error) {
        console.error("Error adding donation:", error);
        // Send back more detailed error message
        res.status(500).json({
            success: false,
            message: error.message || "Could not add donation. Please try again."
        });
    }
};

// Rest of your controller code remains the same
const donslist = async (req, res) => {
    try {
        const dons = await model1.find({}).sort({ createdAt: -1 });

        if (dons.length === 0) {
            return res.json({
                success: true,
                message: "No donations found",
                data: []
            });
        }

        res.json({
            success: true,
            data: dons
        });
    } catch (error) {
        console.error("Error fetching donations:", error);
        res.status(500).json({
            success: false,
            message: "Error! Could not fetch list"
        });
    }
};

const removedon = async (req, res) => {
    try {
        const dons = await model1.findById(req.body.id);
        if (!dons) {
            return res.status(404).json({
                success: false,
                message: "Donation not found"
            });
        }

        // Delete the associated image
        const imagePath = `uploads/${dons.imageUrl}`;
        if (fs.existsSync(imagePath)) {
            fs.unlinkSync(imagePath);
        }

        await model1.findByIdAndDelete(req.body.id);
        res.json({
            success: true,
            message: "Donation removed successfully"
        });
    } catch (error) {
        console.error("Error removing donation:", error);
        res.status(500).json({
            success: false,
            message: "Failed to remove donation"
        });
    }
};

const acceptDonation = async (req, res) => {
    try {
        const { donationId } = req.body;
        
        const donation = await model1.findByIdAndUpdate(
            donationId,
            { isAccepted: true },
            { new: true }
        );

        if (!donation) {
            return res.status(404).json({
                success: false,
                message: "Donation not found"
            });
        }

        res.json({
            success: true,
            message: "Donation accepted successfully",
            donation
        });
    } catch (error) {
        console.error("Error accepting donation:", error);
        res.status(500).json({
            success: false,
            message: "Failed to accept donation"
        });
    }
};

export { add_Dons, donslist, removedon, acceptDonation };