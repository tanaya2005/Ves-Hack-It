// const express = require('express');
// const mongoose = require('mongoose');
// const cors = require('cors');
// const multer = require('multer');
// const path = require('path');
// const fs = require('fs');

// const app = express();
// app.use(cors());
// app.use(express.json());
// app.use('/uploads', express.static('uploads'));

// // Configure multer for file upload
// const storage = multer.diskStorage({
//   destination: function (req, file, cb) {
//     cb(null, 'uploads/');
//   },
//   filename: function (req, file, cb) {
//     cb(null, Date.now() + path.extname(file.originalname));
//   },
// });

// const upload = multer({ storage: storage });

// // MongoDB connection
// mongoose
//   .connect('mongodb+srv://tanaya:mongotan@cluster0.9e5vj.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
//     useNewUrlParser: true,
//     useUnifiedTopology: true,
//   })
//   .then(() => console.log('MongoDB Connected'))
//   .catch((err) => console.log(err));

// // Donation Schema (your existing schema)
// const donSchema = new mongoose.Schema({
//   foodName: { type: String, required: true },
//   quantity: { type: String, required: true },
//   description: { type: String, required: true },
//   expiryDateTime: { type: String, required: true },
//   isVeg:{ type: Boolean, default: false },
//   isNonVeg:{ type: Boolean, default: false },
//   location: { type: String, required: true },
//   imageUrl: { type: String, required: true }, // Added organization name
//   createdAt: { type: Date, default: Date.now },// Added organization name
//   latitude: { type: Number, required: true },   // Added for location filtering
//   longitude: { type: Number, required: true } ,  // Added for location filtering
//   isAccepted: { type: Boolean, default: false },
//   needsVolunteer: { type: Boolean,default: false},
//   acceptedBy: {type: String, ref: 'Recipient', default: null},
// }, {
//   timestamps: true
// });

// const acceptedDonationSchema = new mongoose.Schema({
//   foodName: { type: String, required: true },
//   quantity: { type: Number, required: true },
//   description: { type: String, required: true },
//   expiryDateTime: { type: String, required: true },
//   isVeg: { type: Boolean, default: false },
//   isNonVeg: { type: Boolean, default: false },
//   imageUrl: { type: String, required:true },
//   location: { type: String , required:true},
//   latitude: { type: Number , required:true},
//   longitude: { type: Number, required:true },
//   originalDonationId: { type: mongoose.Schema.Types.ObjectId, ref: 'Donation', required: true },
//   donorId: { type: mongoose.Schema.Types.ObjectId, ref: 'Donor', required: true },
//   acceptedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'Recipient', required: true },
//   acceptedAt: { type: Date, default: Date.now },
//   needsVolunteer:{type: Boolean, default: false },
//   isAccepted: {
//     type: Boolean,
//     default: false
// },
// acceptedAt: {
//     type: Date,
//     default: null
// },
// needsVolunteer: {
//     type: Boolean,
//     default: false
// },
// postedBy: {
//     type: String,
//     required: true
// }
// }, {
// timestamps: true
// });

// //Add the acceptance endpoint
// app.post('/api/donations/accept', async (req, res) => {
//   try {
//     const { donationId, needsVolunteer } = req.body;

//     // Validate required fields
//     if (!donationId) {
//       return res.status(400).json({ 
//         error: 'donationId are required.' 
//       });
//     }

//     // Find the donation and recipient in parallel for better performance
//     const [donation] = await Promise.all([
//       Donation.findById(donationId),
//     ]);

//     // Validate donation exists
//     if (!donation) {
//       return res.status(404).json({ error: 'Donation not found.' });
//     }

//     // Check donation availability
//     if (donation.status !== 'available') {
//       return res.status(400).json({ 
//         error: 'Donation is no longer available.',
//         currentStatus: donation.status 
//       });
//     }

//     // Update donation
//     donation.status = 'accepted';
//     donation.needsVolunteer = needsVolunteer;
//     donation.acceptedAt = new Date();

//     await donation.save();

//     // Return success with updated donation
//     res.status(200).json({
//       message: 'Donation accepted successfully!',
//       donation: {
//         id: donation._id,
//         status: donation.status,
//         acceptedAt: donation.acceptedAt,
//         needsVolunteer: donation.needsVolunteer
//       }
//     });
//   } catch (error) {
//     console.error('Error accepting donation:', error);
//     res.status(500).json({ 
//       error: 'Server error while accepting donation.',
//       details: error.message 
//     });
//   }
// });
// const Donation = mongoose.model('Donation', donationSchema);

// // Donor Schema

// const donorSchema = new mongoose.Schema({
//     username: { type: String, required: true },
//     email: { type: String, required: true, unique: true },
//     contact: { type: String, required: true },
//     currentPassword: { type: String, required: true },
//     userType: { type: String, required: true, default: "donor" },
//     about: { type: String },
//     profileImage: { type: String, required: true },
//     orgName: { type: String, required: true },
//     latitude: {type: Number,required: false},
//     longitude: {type: Number,required: false}

// });

// const Donor = mongoose.model('Donor', donorSchema);

// // Recipient Schema
// const recipientSchema = new mongoose.Schema({
//   username: { type: String, required: true },
//   email: { type: String, required: true, unique: true },
//   contact: { type: String, required: true },
//   currentPassword: { type: String, required: true },
//   userType: { type: String, required: true, default: "recipient" },
//   about: { type: String },
//   profileImage: { type: String, required: true },
//   orgName: { type: String, required: true },
//   latitude: {type: Number,required: false},
//   longitude: {type: Number,required: false}

// });


// const Recipient = mongoose.model('Recipient', recipientSchema);

// const volunteerSchema = new mongoose.Schema({
//   username: { type: String, required: true },
//   email: { type: String, required: true, unique: true },
//   contact: { type: String, required: true },
//   currentPassword: { type: String, required: true },
//   userType: { type: String, required: true, default: "volunteer" },
//   about: { type: String },
//   profileImage: { type: String, required: true },
//   identificationDoc: { type: String, required: true },
//   docImage: { type: String, required: true },
//   latitude: {type: Number,required: false},
//   longitude: {type: Number,required: false}

// });
// // Create uploads directory if it doesn't exist
// if (!fs.existsSync('uploads')) {
//   fs.mkdirSync('uploads');
// }

// // Your existing donation endpoints
// app.post('/api/donations', upload.single('image'), async (req, res) => {
//   try {
//     const { foodName, quantity, description, expiryDateTime, isVeg, isNonVeg, location, latitude, longitude } = req.body;
//     if (!foodName || !quantity || !description || !expiryDateTime) {
//       return res.status(400).json({ error: 'Missing required fields.' });
//     }

//     const donationData = {
//       foodName,
//       quantity: parseInt(quantity),
//       description,
//       expiryDateTime,
//       isVeg: isVeg === 'true',
//       isNonVeg: isNonVeg === 'true',
//       imageUrl: req.file ? `/uploads/${req.file.filename}` : null,
//       location,
//       latitude: parseFloat(latitude),
//       longitude: parseFloat(longitude),
//     };

//     const donation = new Donation(donationData);
//     await donation.save();
//     res.status(201).json({ message: 'Donation saved successfully!', donation });
//   } catch (error) {
//     console.error('Error saving donation:', error);
//     res.status(500).json({ error: 'Error saving donation.' });
//   }
// });

// app.get('/api/donations', async (req, res) => {
//   try {
//     const donations = await Donation.find().sort({ createdAt: -1 });
//     res.json(donations);
//   } catch (error) {
//     console.error('Error fetching donations:', error);
//     res.status(500).json({ error: 'Error fetching donations.' });
//   }
// });

// // New Donor endpoints
// app.post('/api/donors', async (req, res) => {
//   try {
//     const { name, email, phone, location, organization, currentPassword } = req.body;

//     // Validate required fields
//     if (!name || !email || !phone || !location || !organization || !currentPassword) {
//       return res.status(400).json({ error: 'Missing required fields.' });
//     }

//     // Check if email already exists
//     const existingDonor = await Donor.findOne({ email });
//     if (existingDonor) {
//       return res.status(400).json({ error: 'Email already registered' });
//     }

//     const donor = new Donor({
//       name,
//       email,
//       phone,
//       location, 
//       organization,
//       currentPassword
//     });

//     await donor.save();
//     res.status(201).json({ message: 'Donor registered successfully!', donor });
//   } catch (error) {
//     console.error('Error registering donor:', error);
//     res.status(500).json({ error: 'Error registering donor.' });
//   }
// });

// // Get donor profile by email
// app.get('/api/donors/profile', async (req, res) => {
//   try {
//     const { email } = req.query;

//     if (!email) {
//       return res.status(400).json({ error: 'Email is required' });
//     }

//     const donor = await Donor.findOne({ email });
//     if (!donor) {
//       return res.status(404).json({ error: 'Donor not found' });
//     }

//     res.json(donor);
//   } catch (error) {
//     console.error('Error fetching donor profile:', error);
//     res.status(500).json({ error: 'Error fetching donor profile' });
//   }
// });

// app.post('/getUserProfile', async (req, res) => {
//   const { token } = req.body; // Firebase token sent from Flutter
//   try {
//     // Verify Firebase token and get UID
//     const decodedToken = await admin.auth().verifyIdToken(token);
//     const uid = decodedToken.uid;

//     // Retrieve user data from MongoDB
//     const user = await User.findOne({ uid });
//     if (user) {
//       res.json({ profileData: user.profileData });
//     } else {
//       res.status(404).json({ error: 'User not found' });
//     }
//   } catch (error) {
//     res.status(500).json({ error: 'Failed to authenticate user' });
//   }
// });

// //New Recipient endpoints
// app.post('/api/recipients', async (req, res) => {
//   try {
//     const { name, email, phone, location, recipientId, about, currentPassword } = req.body;

//     // Validate required fields
//     if (!name || !email || !phone || !location || !recipientId || !about || !currentPassword) {
//       return res.status(400).json({ error: 'Missing required fields.' });
//     }

//     // Check if email already exists
//     const existingRecipient = await Recipient.findOne({ email });
//     if (existingRecipient) {
//       return res.status(400).json({ error: 'Email already registered' });
//     }

//     const recipient = new Recipient({
//       name,
//       email,
//       phone,
//       location,
//       recipientId,
//       about,
//       currentPassword
//     });

//     await recipient.save();
//     res.status(201).json({ message: 'Recipient registered successfully!', recipient });
//   } catch (error) {
//     console.error('Error registering recipient:', error);
//     res.status(500).json({ error: 'Error registering recipient.' });
//   }
// });

// // Get recipient profile by email
// app.get('/api/recipients/profile', async (req, res) => {
//   try {
//     const { email } = req.query;

//     if (!email) {
//       return res.status(400).json({ error: 'Email is required' });
//     }

//     const recipient = await Recipient.findOne({ email });
//     if (!recipient) {
//       return res.status(404).json({ error: 'Recipient not found' });
//     }

//     res.json(recipient);
//   } catch (error) {
//     console.error('Error fetching recipient profile:', error);
//     res.status(500).json({ error: 'Error fetching recipient profile' });
//   }
// });


// // Login endpoint for both donors and recipients
// app.post('/api/login', async (req, res) => {
//   try {
//     const { email, currentPassword, role } = req.body;

//     if (!email || !currentPassword || !role) {
//       return res.status(400).json({ error: 'Email, password, and role are required' });
//     }

//     let user;
//     if (role === 'donor') {
//       user = await Donor.findOne({ email });
//     } else if (role === 'recipient') {
//       user = await Recipient.findOne({ email });
//     } else {
//       return res.status(400).json({ error: 'Invalid role' });
//     }

//     if (!user) {
//       return res.status(404).json({ error: 'User not found' });
//     }

//     if (user.currentPassword !== currentPassword) {
//       return res.status(401).json({ error: 'Invalid password' });
//     }

//     res.json({ message: 'Login successful', user });
//   } catch (error) {
//     console.error('Login error:', error);
//     res.status(500).json({ error: 'Error during login' });
//   }
// });

// // Start the server
// const PORT = process.env.PORT || 3000;
// app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));


require('dotenv').config();
const bcrypt = require('bcrypt');
const saltRounds = 10;
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

const upload = multer({
  storage: storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB limit
  fileFilter: (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    if (extname) {
      return cb(null, true);
    }
    cb(new Error('Only JPEG, JPG and PNG files are allowed'));
  }
});

// Create uploads directory if it doesn't exist
if (!fs.existsSync('uploads')) {
  fs.mkdirSync('uploads');
}

// MongoDB connection
mongoose
   .connect('mongodb+srv://tanaya:mongotan@cluster0.9e5vj.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log('MongoDB Connected'))
  .catch((err) => console.log(err));

// Schemas
const donationSchema = new mongoose.Schema({
  foodName: { type: String, required: true },
  quantity: { type: Number, required: true },
  description: { type: String, required: true },
  expiryDateTime: { type: String, required: true },
  isVeg: { type: Boolean, default: false },
  isNonVeg: { type: Boolean, default: false },
  location: { type: String, required: true },
  imageUrl: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  latitude: { type: Number, required: true },
  longitude: { type: Number, required: true },
  isAccepted: { type: Boolean, default: false },
  needsVolunteer: { type: Boolean, default: false },
  acceptedBy: { type: String, ref: 'Recipient', default: null },
  status: { type: String, default: 'available' },
  postedBy: { type: String, required: true }
}, {
  timestamps: true
});

const acceptedDonationSchema = new mongoose.Schema({
  foodName: { type: String, required: true },
  quantity: { type: Number, required: true },
  description: { type: String, required: true },
  expiryDateTime: { type: String, required: true },
  isVeg: { type: Boolean, default: false },
  isNonVeg: { type: Boolean, default: false },
  imageUrl: { type: String, required: true },
  location: { type: String, required: true },
  latitude: { type: Number, required: true },
  longitude: { type: Number, required: true },
  originalDonationId: { type: mongoose.Schema.Types.ObjectId, ref: 'Donation', required: true },
  donorId: { type: mongoose.Schema.Types.ObjectId, ref: 'Donor', required: true },
  acceptedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'Recipient', required: true },
  acceptedAt: { type: Date, default: Date.now },
  needsVolunteer: { type: Boolean, default: false },
  isAccepted: { type: Boolean, default: false },
  postedBy: { type: String, required: true }
}, {
  timestamps: true
});

const donorSchema = new mongoose.Schema({
  username: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  contact: { type: String, required: true },
  currentPassword: { type: String, required: true },
  userType: { type: String, required: true, default: "donor" },
  about: { type: String },
  profileImage: { type: String, required: true },
  orgName: { type: String, required: true },
  latitude: { type: Number, required: false },
  longitude: { type: Number, required: false }
});

const recipientSchema = new mongoose.Schema({
  username: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  contact: { type: String, required: true },
  currentPassword: { type: String, required: true },
  userType: { type: String, required: true, default: "recipient" },
  about: { type: String },
  profileImage: { type: String, required: true },
  orgName: { type: String, required: true },
  latitude: { type: Number, required: false },
  longitude: { type: Number, required: false }
});

const volunteerSchema = new mongoose.Schema({
  username: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  contact: { type: String, required: true },
  currentPassword: { type: String, required: true },
  userType: { type: String, required: true, default: "volunteer" },
  about: { type: String },
  profileImage: { type: String, required: true },
  identificationDoc: { type: String, required: true },
  docImage: { type: String, required: true },
  latitude: { type: Number, required: false },
  longitude: { type: Number, required: false }
});

// Models
const Donation = mongoose.model('Donation', donationSchema);
const AcceptedDonation = mongoose.model('AcceptedDonation', acceptedDonationSchema);
const Donor = mongoose.model('Donor', donorSchema);
const Recipient = mongoose.model('Recipient', recipientSchema);
const Volunteer = mongoose.model('Volunteer', volunteerSchema);

// Donation Routes
app.post('/api/donations', upload.single('image'), async (req, res) => {
  try {
    const {
      foodName,
      quantity,
      description,
      expiryDateTime,
      isVeg,
      isNonVeg,
      location,
      latitude,
      longitude,
      postedBy
    } = req.body;

    if (!foodName || !quantity || !description || !expiryDateTime || !postedBy) {
      return res.status(400).json({ error: 'Missing required fields.' });
    }

    const donationData = {
      foodName,
      quantity: parseInt(quantity),
      description,
      expiryDateTime,
      isVeg: isVeg === 'true',
      isNonVeg: isNonVeg === 'true',
      imageUrl: req.file ? `/uploads/${req.file.filename}` : null,
      location,
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude),
      postedBy
    };

    const donation = new Donation(donationData);
    await donation.save();
    res.status(201).json({ message: 'Donation saved successfully!', donation });
  } catch (error) {
    console.error('Error saving donation:', error);
    res.status(500).json({ error: 'Error saving donation.' });
  }
});

app.get('/api/donations/:id', async (req, res) => {
  try {
    const donation = await Donation.findById(req.params.id);
    if (!donation) {
      return res.status(404).json({ error: 'Donation not found' });
    }
    res.json(donation);
  } catch (error) {
    console.error('Error fetching donation:', error);
    res.status(500).json({ error: 'Error fetching donation' });
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

app.post('/api/donations/accept', async (req, res) => {
  try {
    const { donationId, recipientId, needsVolunteer } = req.body;

    if (!donationId || !recipientId) {
      return res.status(400).json({ error: 'Donation ID and Recipient ID are required.' });
    }

    const donation = await Donation.findById(donationId);
    if (!donation) {
      return res.status(404).json({ error: 'Donation not found.' });
    }

    if (donation.isAccepted) {
      return res.status(400).json({ error: 'Donation has already been accepted.' });
    }

    // Create accepted donation record
    const acceptedDonation = new AcceptedDonation({
      ...donation.toObject(),
      donorId: donation.postedBy,
      acceptedBy: recipientId,
      needsVolunteer: needsVolunteer || false,
      isAccepted: true,
      acceptedAt: new Date()
    });

    // Update original donation
    donation.isAccepted = true;
    donation.acceptedBy = recipientId;
    donation.needsVolunteer = needsVolunteer || false;

    await Promise.all([
      acceptedDonation.save(),
      donation.save()
    ]);

    res.status(200).json({
      message: 'Donation accepted successfully!',
      acceptedDonation
    });
  } catch (error) {
    console.error('Error accepting donation:', error);
    res.status(500).json({ error: 'Server error while accepting donation.' });
  }
});

// User Registration Routes
app.post('/api/donors/register', upload.single('profileImage'), async (req, res) => {
  try {
    const {
      username,
      email,
      contact,
      currentPassword,
      about,
      orgName,
      latitude,
      longitude
    } = req.body;

    if (!username || !email || !contact || !currentPassword || !orgName) {
      return res.status(400).json({ error: 'Missing required fields.' });
    }

    const existingDonor = await Donor.findOne({ email });
    if (existingDonor) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    const donor = new Donor({
      username,
      email,
      contact,
      currentPassword: await bcrypt.hash(currentPassword, saltRounds),
      about,
      profileImage: req.file ? `/uploads/${req.file.filename}` : null,
      orgName,
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude)
    });

    await donor.save();
    res.status(201).json({ message: 'Donor registered successfully!', donor });
  } catch (error) {
    console.error('Error registering donor:', error);
    res.status(500).json({ error: 'Error registering donor.' });
  }
});

app.post('/api/recipients/register', upload.single('profileImage'), async (req, res) => {
  try {
    const {
      username,
      email,
      contact,
      currentPassword,
      about,
      orgName,
      latitude,
      longitude
    } = req.body;

    if (!username || !email || !contact || !currentPassword || !orgName) {
      return res.status(400).json({ error: 'Missing required fields.' });
    }

    const existingRecipient = await Recipient.findOne({ email });
    if (existingRecipient) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    const recipient = new Recipient({
      username,
      email,
      contact,
      currentPassword: await bcrypt.hash(currentPassword, saltRounds),
      about,
      profileImage: req.file ? `/uploads/${req.file.filename}` : null,
      orgName,
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude)
    });

    await recipient.save();
    res.status(201).json({ message: 'Recipient registered successfully!', recipient });
  } catch (error) {
    console.error('Error registering recipient:', error);
    res.status(500).json({ error: 'Error registering recipient.' });
  }
});

app.post('/api/volunteers/register', upload.fields([
  { name: 'profileImage', maxCount: 1 },
  { name: 'docImage', maxCount: 1 }
]), async (req, res) => {
  try {
    const {
      username,
      email,
      contact,
      currentPassword,
      about,
      identificationDoc,
      latitude,
      longitude
    } = req.body;

    if (!username || !email || !contact || !currentPassword || !identificationDoc) {
      return res.status(400).json({ error: 'Missing required fields.' });
    }

    const existingVolunteer = await Volunteer.findOne({ email });
    if (existingVolunteer) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    const volunteer = new Volunteer({
      username,
      email,
      contact,
      currentPassword: await bcrypt.hash(currentPassword, saltRounds),
      about,
      profileImage: req.files['profileImage'] ? `/uploads/${req.files['profileImage'][0].filename}` : null,
      identificationDoc,
      docImage: req.files['docImage'] ? `/uploads/${req.files['docImage'][0].filename}` : null,
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude)
    });

    await volunteer.save();
    res.status(201).json({ message: 'Volunteer registered successfully!', volunteer });
  } catch (error) {
    console.error('Error registering volunteer:', error);
    res.status(500).json({ error: 'Error registering volunteer.' });
  }
});

// Profile Routes
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

// Login Route
app.post('/api/login', async (req, res) => {
  try {
    const { email, currentPassword, userType } = req.body;

    if (!email || !currentPassword || !userType) {
      return res.status(400).json({ error: 'Email, password, and user type are required' });
    }

    let user;
    switch (userType) {
      case 'donor':
        user = await Donor.findOne({ email });
        break;
      case 'recipient':
        user = await Recipient.findOne({ email });
        break;
      case 'volunteer':
        user = await Volunteer.findOne({ email });
        break;
      default:
        return res.status(400).json({ error: 'Invalid user type' });
    }

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const isMatch = await bcrypt.compare(currentPassword, user.currentPassword);
    if (!isMatch) {
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