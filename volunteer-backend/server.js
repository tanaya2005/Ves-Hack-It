require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const session = require('express-session');
const bcrypt = require('bcrypt');
const cors = require('cors');
const Volunteer = require('./models/Volunteer.js'); // Import Volunteer model

const app = express();
app.use(express.json());
app.use(cors({ origin: "*", credentials: true })); // Adjust if needed

// Configure session middleware
app.use(session({
  secret: "yourSecretKey",
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false } // Set to `true` in production if using HTTPS
}));

// MongoDB Connection
mongoose.connect( "mongodb+srv://tanaya:mongotan@cluster0.9e5vj.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0", {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log("✅ MongoDB Connected"))
.catch(err => console.error("❌ MongoDB Connection Error:", err));

// Volunteer Signup Route
app.post('/signup', async (req, res) => {
  const { fullName, phone, address, email, password } = req.body;

  try {
    const existingUser = await Volunteer.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "Email already exists" });
    }

    const newVolunteer = new Volunteer({ fullName, phone, address, email, password });
    await newVolunteer.save();

    req.session.user = { id: newVolunteer._id, email: newVolunteer.email };
    res.status(201).json({ message: "Signup successful", user: req.session.user });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

// Volunteer Login Route
app.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await Volunteer.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    req.session.user = { id: user._id, email: user.email };
    res.json({ message: "Login successful", user: req.session.user });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

// Logout Route
app.post('/logout', (req, res) => {
  req.session.destroy();
  res.json({ message: "Logged out successfully" });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
