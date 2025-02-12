const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Volunteer = require("../models/Volunteer");

// Register Volunteer
exports.registerVolunteer = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { name, email, password, phone } = req.body;

  try {
    let volunteer = await Volunteer.findOne({ email });
    if (volunteer) {
      return res.status(400).json({ msg: "Volunteer already exists" });
    }

    volunteer = new Volunteer({ name, email, password, phone });

    // Hash password
    const salt = await bcrypt.genSalt(10);
    volunteer.password = await bcrypt.hash(password, salt);

    await volunteer.save();

    // Return JSON Web Token (JWT)
    const payload = { volunteer: { id: volunteer.id } };
    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: "7d" },
      (err, token) => {
        if (err) throw err;
        res.json({ token });
      }
    );
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
};

// Login Volunteer
exports.loginVolunteer = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { email, password } = req.body;

  try {
    let volunteer = await Volunteer.findOne({ email });
    if (!volunteer) {
      return res.status(400).json({ msg: "Invalid Credentials" });
    }

    const isMatch = await bcrypt.compare(password, volunteer.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Invalid Credentials" });
    }

    const payload = { volunteer: { id: volunteer.id } };
    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: "7d" },
      (err, token) => {
        if (err) throw err;
        res.json({ token });
      }
    );
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
};
