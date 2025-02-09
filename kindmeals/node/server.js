const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const multer = require('multer');
const path = require('path');

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
    cb(null, Date.now() + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });

// MongoDB connection
mongoose.connect('mongodb+srv://tanaya:mongotan@cluster0.9e5vj.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('MongoDB Connected'))
.catch(err => console.log(err));

// Donation Schema
const donationSchema = new mongoose.Schema({
  foodName: String,
  quantity: Number,
  description: String,
  expirationDate: String,
  isVeg: Boolean,
  isNonVeg: Boolean,
  imageUrl: String,
  createdAt: { type: Date, default: Date.now }
});

const Donation = mongoose.model('Donation', donationSchema);

// Create uploads directory if it doesn't exist
const fs = require('fs');
if (!fs.existsSync('uploads')) {
  fs.mkdirSync('uploads');
}

// Handle donation post with file upload
app.post('/api/donations', upload.single('image'), async (req, res) => {
  try {
    const donationData = {
      foodName: req.body.foodName,
      quantity: parseInt(req.body.quantity),
      description: req.body.description,
      expirationDate: req.body.expirationDate,
      isVeg: req.body.isVeg === 'true',
      isNonVeg: req.body.isNonVeg === 'true',
      imageUrl: req.file ? `/uploads/${req.file.filename}` : null
    };

    const donation = new Donation(donationData);
    await donation.save();
    res.status(201).json({ message: 'Donation saved successfully!', donation });
  } catch (error) {
    console.error('Error saving donation:', error);
    res.status(400).json({ error: 'Error saving donation.' });
  }
});

// Get all donations
app.get('/api/donations', async (req, res) => {
  try {
    const donations = await Donation.find().sort({ createdAt: -1 });
    res.json(donations);
  } catch (error) {
    res.status(500).json({ error: 'Error fetching donations.' });
  }
});

app.listen(3000, () => console.log('Server running on http://localhost:3000'));