const express = require('express');
const router = express.Router();
const Volunteer = require('../models/Volunteer');
const bcrypt = require('bcrypt');
const session = require('express-session');

// Middleware for authentication
const authMiddleware = require('../middleware/authMiddleware');

// Initialize session
router.use(session({
  secret: 'volunteerSecretKey',
  resave: false,
  saveUninitialized: false,
  cookie: { secure: false } // Set true for HTTPS
}));

// 🟢 SIGNUP ROUTE
router.post('/signup', async (req, res) => {
  try {
    const { email, password } = req.body;
    let volunteer = await Volunteer.findOne({ email });

    if (volunteer) {
      return res.status(400).json({ msg: 'Volunteer already exists' });
    }

    volunteer = new Volunteer({ email, password });
    await volunteer.save();

    req.session.volunteerId = volunteer._id; // Create session
    res.status(201).json({ msg: 'Signup successful', volunteerId: volunteer._id });
  } catch (err) {
    res.status(500).send('Server Error');
  }
});

// 🟢 LOGIN ROUTE
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const volunteer = await Volunteer.findOne({ email });

    if (!volunteer) {
      return res.status(400).json({ msg: 'Invalid Credentials' });
    }

    const isMatch = await bcrypt.compare(password, volunteer.password);
    if (!isMatch) {
      return res.status(400).json({ msg: 'Invalid Credentials' });
    }

    req.session.volunteerId = volunteer._id; // Save session
    res.json({ msg: 'Login successful', volunteerId: volunteer._id });
  } catch (err) {
    res.status(500).send('Server Error');
  }
});

// 🟢 LOGOUT ROUTE
router.post('/logout', (req, res) => {
  req.session.destroy((err) => {
    if (err) return res.status(500).json({ msg: 'Logout failed' });
    res.json({ msg: 'Logged out successfully' });
  });
});

// 🟢 CHECK SESSION ROUTE (To see if user is logged in)
router.get('/session', authMiddleware, (req, res) => {
  res.json({ msg: 'Session Active', volunteerId: req.session.volunteerId });
});

module.exports = router;
