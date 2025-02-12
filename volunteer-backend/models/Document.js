const mongoose = require("mongoose");

const DocumentSchema = new mongoose.Schema({
  firebaseUID: { type: String, required: true },
  documentType: { type: String, required: true },
  fileName: { type: String, required: true },
  fileData: { type: Buffer, required: true }, // Storing file as binary data
});

module.exports = mongoose.model("Document", DocumentSchema);
