const express = require("express");
const Volunteer = require("../models/Volunteer");
const verifyToken = require("../middleware/authMiddleware");
const router = express.Router();

// Register Volunteer
router.post("/register", verifyToken, async (req, res) => {
  const { name, email, phone, profilePic } = req.body;
  try {
    let volunteer = await Volunteer.findOne({ uid: req.user.id });

    if (!volunteer) {
      volunteer = new Volunteer({
        id: req.user.id,
        name,
        email,
        phone,
        profilePic,
      });

      await volunteer.save();
      return res.status(201).json({ message: "Volunteer registered successfully", volunteer });
    }

    res.status(400).json({ message: "Volunteer already exists" });
  } catch (error) {
    res.status(500).json({ message: "Server Error", error });
  }
});

// Get Volunteer Profile
router.get("/profile", verifyToken, async (req, res) => {
  try {
    const volunteer = await Volunteer.findOne({ uid: req.user.uid });
    if (!volunteer) return res.status(404).json({ message: "Volunteer not found" });

    res.json(volunteer);
  } catch (error) {
    res.status(500).json({ message: "Server Error", error });
  }
});

// Upload Documents
router.put("/uploadDocuments", verifyToken, async (req, res) => {
  try {
    const { personal, vehicle, bankDetails, emergency } = req.body;
    const volunteer = await Volunteer.findOneAndUpdate(
      { uid: req.user.uid },
      { $set: { "documents.personal": personal, "documents.vehicle": vehicle, "documents.bankDetails": bankDetails, "documents.emergency": emergency } },
      { new: true }
    );

    if (!volunteer) return res.status(404).json({ message: "Volunteer not found" });

    res.json({ message: "Documents updated successfully", volunteer });
  } catch (error) {
    res.status(500).json({ message: "Server Error", error });
  }
});

module.exports = router;
