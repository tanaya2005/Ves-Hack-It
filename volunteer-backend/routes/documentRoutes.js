const express = require("express");
const multer = require("multer");
const verifyFirebaseToken = require("../middleware/authMiddleware");
const Document = require("../models/Document");

const router = express.Router();

// Configure Multer for file uploads
const storage = multer.memoryStorage();
const upload = multer({ storage });

// @route   POST /api/documents/upload
// @desc    Upload volunteer documents
router.post("/upload", verifyFirebaseToken, upload.single("document"), async (req, res) => {
  try {
    const { documentType } = req.body;
    const firebaseUID = req.volunteer.uid;
    
    // Save document info to MongoDB
    const newDocument = new Document({
      firebaseUID,
      documentType,
      fileName: req.file.originalname,
      fileData: req.file.buffer, // Storing file as binary (or use cloud storage)
    });

    await newDocument.save();
    res.status(201).json({ message: "Document uploaded successfully!" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error uploading document" });
  }
});

module.exports = router;
