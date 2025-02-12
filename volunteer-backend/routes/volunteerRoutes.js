const express = require("express");
const router = express.Router();
const Volunteer = require("../models/Volunteer");
const verifyFirebaseToken = require("../middleware/authMiddleware");

// @route   POST /api/volunteer/register
// @desc    Register a new volunteer (Firebase Auth handles authentication)
router.post("/register", verifyFirebaseToken, async (req, res) => {
  try {
    const { name, email, phone, address } = req.body;
    const firebaseUID = req.volunteer.uid; // Get Firebase UID

    // Check if volunteer already exists
    let volunteer = await Volunteer.findOne({ firebaseUID });
    if (volunteer) {
      return res.status(400).json({ message: "Volunteer already registered." });
    }

    // Create new volunteer
    volunteer = new Volunteer({ name, email, phone, address, firebaseUID });
    await volunteer.save();

    res.status(201).json({ message: "Volunteer registered successfully!" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

// @route   GET /api/volunteer/me
// @desc    Get volunteer details
router.get("/me", verifyFirebaseToken, async (req, res) => {
  try {
    const volunteer = await Volunteer.findOne({ firebaseUID: req.volunteer.uid });
    if (!volunteer) {
      return res.status(404).json({ message: "Volunteer not found." });
    }
    res.json(volunteer);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;
