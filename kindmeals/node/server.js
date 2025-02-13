const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const admin = require('firebase-admin');

const app = express();

// 🔹 Middleware
app.use(cors());
app.use(express.json());

// 🔹 Initialize Firebase Admin SDK (Replace with your own Service Account Key)
const serviceAccount = require("./serviceAccountKey.json"); // Make sure this file is in the same directory as server.js
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// 🔹 MongoDB Connection (Replace with your actual MongoDB URI)
const mongoURI = 'mongodb+srv://tanaya:mongotan@cluster0.9e5vj.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

mongoose.connect(mongoURI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const db = mongoose.connection;
db.on('error', console.error.bind(console, 'MongoDB connection error:'));
db.once('open', () => console.log('✅ Connected to MongoDB'));

// 🔹 Define Volunteer Schema
const volunteerSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true }, // Firebase id
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  phone: { type: String, required: true },
  address: { type: String, required: true },
  availableDays: { type: [String], required: true },
  createdAt: { type: Date, default: Date.now },
});

const Volunteer = mongoose.model('Volunteer', volunteerSchema);

// 🔹 Register a Volunteer
app.post('/api/volunteers/register', async (req, res) => {
  try {
    const { id, name, email, phone, address, availableDays } = req.body;

    // Check if volunteer already exists
    let volunteer = await Volunteer.findOne({ id: id });
    if (volunteer) {
      return res.status(400).json({ message: 'Volunteer already exists' });
    }

    // Save new volunteer in MongoDB
    volunteer = new Volunteer({ id: id, name, email, phone, address, availableDays });
    await volunteer.save();

    res.status(201).json({ message: 'Volunteer registered successfully', volunteer });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// 🔹 Login with Firebase Authentication (Token Verification)
app.post('/api/volunteers/login', async (req, res) => {
  try {
    const { token } = req.body;

    // Verify Firebase token
    const decodedToken = await admin.auth().verifyIdToken(token);
    const id = decodedToken.id;

    // Check if user exists
    const volunteer = await Volunteer.findOne({ id: id });
    if (!volunteer) {
      return res.status(404).json({ message: 'Volunteer not found' });
    }

    res.json({ message: 'Login successful', volunteer });
  } catch (error) {
    res.status(401).json({ message: 'Unauthorized - Invalid token' });
  }
});

// 🔹 Get All Volunteers
app.get('/api/volunteers', async (req, res) => {
  try {
    const volunteers = await Volunteer.find();
    res.json(volunteers);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// 🔹 Get Volunteer by ID
app.get('/api/volunteers/:id', async (req, res) => {
  try {
    const volunteer = await Volunteer.findOne({ id: req.params.id });
    if (!volunteer) return res.status(404).json({ message: 'Volunteer not found' });
    res.json(volunteer);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// 🔹 Update Volunteer Data
app.patch('/api/volunteers/:id', async (req, res) => {
  try {
    const updatedVolunteer = await Volunteer.findOneAndUpdate(
      { id: req.params.id },
      req.body,
      { new: true }
    );
    res.json(updatedVolunteer);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// 🔹 Delete Volunteer
app.delete('/api/volunteers/:id', async (req, res) => {
  try {
    await Volunteer.findOneAndDelete({ id: req.params.id });
    res.json({ message: 'Volunteer deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// 🔹 Start Server
const PORT = 5000;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
