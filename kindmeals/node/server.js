const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static('uploads'));

// Configure multer for file upload
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname)); // Append file extension
  },
});

const upload = multer({ storage: storage });

// MongoDB connection
mongoose
  .connect('mongodb+srv://tanaya:mongotan@cluster0.9e5vj.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log('MongoDB Connected'))
  .catch((err) => console.log(err));

// Donation Schema
const donationSchema = new mongoose.Schema({
  foodName: { type: String, required: true },
  quantity: { type: Number, required: true },
  description: { type: String, required: true },
  expiryDate: { type: String, required: true }, // Ensure this is included
  isVeg: { type: Boolean, default: false },
  isNonVeg: { type: Boolean, default: false },
  imageUrl: { type: String },
  location: { type: String }, // Add location field
  latitude: { type: Number }, // Add latitude field
  longitude: { type: Number }, // Add longitude field
  createdAt: { type: Date, default: Date.now },
});

const Donation = mongoose.model('Donation', donationSchema);

// Create uploads directory if it doesn't exist
if (!fs.existsSync('uploads')) {
  fs.mkdirSync('uploads');
}

// Handle donation post with file upload
app.post('/api/donations', upload.single('image'), async (req, res) => {
  try {
    // Validate required fields
    const { foodName, quantity, description, expiryDate, isVeg, isNonVeg, location, latitude, longitude } = req.body;
    if (!foodName || !quantity || !description || !expiryDate) {
      return res.status(400).json({ error: 'Missing required fields.' });
    }

    const donationData = {
      foodName,
      quantity: parseInt(quantity),
      description,
      expiryDate,
      isVeg: isVeg === 'true',
      isNonVeg: isNonVeg === 'true',
      imageUrl: req.file ? `/uploads/${req.file.filename}` : null,
      location,
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude),
    };

    const donation = new Donation(donationData);
    await donation.save();
    res.status(201).json({ message: 'Donation saved successfully!', donation });
  } catch (error) {
    console.error('Error saving donation:', error);
    res.status(500).json({ error: 'Error saving donation.' });
  }
});

// Get all donations
app.get('/api/donations', async (req, res) => {
  try {
    const donations = await Donation.find().sort({ createdAt: -1 });
    res.json(donations);
  } catch (error) {
    console.error('Error fetching donations:', error);
    res.status(500).json({ error: 'Error fetching donations.' });
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));