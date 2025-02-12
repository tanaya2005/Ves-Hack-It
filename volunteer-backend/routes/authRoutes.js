const express = require('express');
const bcrypt = require('bcryptjs');
const Volunteer = require('../models/Volunteer');
const router = express.Router();

// 🟢 Volunteer Registration (Signup)
router.post('/register', async (req, res) => {
  const { name, email, password } = req.body;

  try {
    let user = await Volunteer.findOne({ email });
    if (user) return res.status(400).json({ message: 'User already exists' });

    const hashedPassword = await bcrypt.hash(password, 10);
    user = new Volunteer({ name, email, password: hashedPassword });
    await user.save();

    req.session.userId = user._id; // Store session
    res.json({ message: 'Volunteer registered successfully' });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// 🔵 Volunteer Login
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await Volunteer.findOne({ email });
    if (!user) return res.status(400).json({ message: 'User not found' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: 'Invalid password' });

    req.session.userId = user._id; // Store session
    res.json({ message: 'Login successful' });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// 🔴 Volunteer Logout
router.post('/logout', (req, res) => {
  req.session.destroy(err => {
    if (err) return res.status(500).json({ message: 'Logout failed' });
    res.json({ message: 'Logout successful' });
  });
});

// 🟠 Check if Volunteer is Logged In
router.get('/me', async (req, res) => {
  if (!req.session.userId) return res.status(401).json({ message: 'Not logged in' });

  const user = await Volunteer.findById(req.session.userId).select('-password');
  res.json(user);
});

module.exports = router;
