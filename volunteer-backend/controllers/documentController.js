const Volunteer = require("../models/Volunteer");

// Upload Documents Controller
exports.uploadDocuments = async (req, res) => {
  try {
    const volunteerId = req.volunteer.id;

    // Get file paths
    const panCard = req.files["panCard"] ? req.files["panCard"][0].path : null;
    const aadharCard = req.files["aadharCard"] ? req.files["aadharCard"][0].path : null;
    const drivingLicense = req.files["drivingLicense"] ? req.files["drivingLicense"][0].path : null;

    // Update volunteer document details
    const volunteer = await Volunteer.findByIdAndUpdate(
      volunteerId,
      {
        "documents.panCard": panCard,
        "documents.aadharCard": aadharCard,
        "documents.drivingLicense": drivingLicense,
        isVerified: false, // Set as unverified until admin verifies
      },
      { new: true }
    );

    res.status(200).json({ message: "Documents uploaded successfully!", volunteer });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error while uploading documents." });
  }
};

// Get Documents Controller
exports.getDocuments = async (req, res) => {
  try {
    const volunteerId = req.volunteer.id;
    const volunteer = await Volunteer.findById(volunteerId).select("documents");

    if (!volunteer) {
      return res.status(404).json({ message: "Volunteer not found." });
    }

    res.status(200).json({ documents: volunteer.documents });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving documents." });
  }
};
