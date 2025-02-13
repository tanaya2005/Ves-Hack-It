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
    cb(null, Date.now() + path.extname(file.originalname));
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

// Donation Schema (your existing schema)
const donationSchema = new mongoose.Schema({
  foodName: { type: String, required: true },
  quantity: { type: Number, required: true },
  description: { type: String, required: true },
  expiryDate: { type: String, required: true },
  isVeg: { type: Boolean, default: false },
  isNonVeg: { type: Boolean, default: false },
  imageUrl: { type: String },
  location: { type: String },
  latitude: { type: Number },
  longitude: { type: Number },
  createdAt: { type: Date, default: Date.now },
});

const Donation = mongoose.model('Donation', donationSchema);

// Donor Schema
const donorSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  phone: { type: String, required: true },
  location: { type: String, required: true },
  organization: { type: String, required: true },
  currentPassword: { type: String, required: true },
});

const Donor = mongoose.model('Donor', donorSchema);

// Recipient Schema
const recipientSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  phone: { type: String, required: true },
  location: { type: String, required: true },
  recipientId: { type: String, required: true },
  currentPassword: { type: String, required: true },
  about: { type: String, required: true },
});

const Recipient = mongoose.model('Recipient', recipientSchema);

// Create uploads directory if it doesn't exist
if (!fs.existsSync('uploads')) {
  fs.mkdirSync('uploads');
}

// Your existing donation endpoints
app.post('/api/donations', upload.single('image'), async (req, res) => {
  try {
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

app.get('/api/donations', async (req, res) => {
  try {
    const donations = await Donation.find().sort({ createdAt: -1 });
    res.json(donations);
  } catch (error) {
    console.error('Error fetching donations:', error);
    res.status(500).json({ error: 'Error fetching donations.' });
  }
});

// New Donor endpoints
app.post('/api/donors', async (req, res) => {
  try {
    const { name, email, phone, location, organization, currentPassword } = req.body;

    // Validate required fields
    if (!name || !email || !phone || !location || !organization || !currentPassword) {
      return res.status(400).json({ error: 'Missing required fields.' });
    }

    // Check if email already exists
    const existingDonor = await Donor.findOne({ email });
    if (existingDonor) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    const donor = new Donor({
      name,
      email,
      phone,
      location,
      organization,
      currentPassword
    });

    await donor.save();
    res.status(201).json({ message: 'Donor registered successfully!', donor });
  } catch (error) {
    console.error('Error registering donor:', error);
    res.status(500).json({ error: 'Error registering donor.' });
  }
});

// Get donor profile by email
app.get('/api/donors/profile', async (req, res) => {
  try {
    const { email } = req.query;

    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }

    const donor = await Donor.findOne({ email });
    if (!donor) {
      return res.status(404).json({ error: 'Donor not found' });
    }

    res.json(donor);
  } catch (error) {
    console.error('Error fetching donor profile:', error);
    res.status(500).json({ error: 'Error fetching donor profile' });
  }
});

app.post('/getUserProfile', async (req, res) => {
  const { token } = req.body; // Firebase token sent from Flutter
  try {
    // Verify Firebase token and get UID
    const decodedToken = await admin.auth().verifyIdToken(token);
    const uid = decodedToken.uid;

    // Retrieve user data from MongoDB
    const user = await User.findOne({ uid });
    if (user) {
      res.json({ profileData: user.profileData });
    } else {
      res.status(404).json({ error: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Failed to authenticate user' });
  }
});

//New Recipient endpoints
app.post('/api/recipients', async (req, res) => {
  try {
    const { name, email, phone, location, recipientId, about, currentPassword } = req.body;

    // Validate required fields
    if (!name || !email || !phone || !location || !recipientId || !about || !currentPassword) {
      return res.status(400).json({ error: 'Missing required fields.' });
    }

    // Check if email already exists
    const existingRecipient = await Recipient.findOne({ email });
    if (existingRecipient) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    const recipient = new Recipient({
      name,
      email,
      phone,
      location,
      recipientId,
      about,
      currentPassword
    });

    await recipient.save();
    res.status(201).json({ message: 'Recipient registered successfully!', recipient });
  } catch (error) {
    console.error('Error registering recipient:', error);
    res.status(500).json({ error: 'Error registering recipient.' });
  }
});

// Get recipient profile by email
app.get('/api/recipients/profile', async (req, res) => {
  try {
    const { email } = req.query;

    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }

    const recipient = await Recipient.findOne({ email });
    if (!recipient) {
      return res.status(404).json({ error: 'Recipient not found' });
    }

    res.json(recipient);
  } catch (error) {
    console.error('Error fetching recipient profile:', error);
    res.status(500).json({ error: 'Error fetching recipient profile' });
  }
});


// Login endpoint for both donors and recipients
app.post('/api/login', async (req, res) => {
  try {
    const { email, currentPassword, role } = req.body;

    if (!email || !currentPassword || !role) {
      return res.status(400).json({ error: 'Email, password, and role are required' });
    }

    let user;
    if (role === 'donor') {
      user = await Donor.findOne({ email });
    } else if (role === 'recipient') {
      user = await Recipient.findOne({ email });
    } else {
      return res.status(400).json({ error: 'Invalid role' });
    }

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    if (user.currentPassword !== currentPassword) {
      return res.status(401).json({ error: 'Invalid password' });
    }

    res.json({ message: 'Login successful', user });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Error during login' });
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));