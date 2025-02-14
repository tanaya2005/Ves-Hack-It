import DonorModel from "../models/donorModel.js";
import RecipientModel from "../models/recipientModel.js";
import VolunteerModel from "../models/volunteerModel.js";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";
import validator from "validator";
import USERmodel from "../models/usermodel.js";

const loginuser = async (req, res) => {
    const { email, password, userType } = req.body;

    try {
        let user;

        // Search only in the specified collection
        if (userType === "Donor") {
            user = await DonorModel.findOne({ email });
        } else if (userType === "Recipient") {
            user = await RecipientModel.findOne({ email });
        } else if (userType === "Volunteer") {
            user = await VolunteerModel.findOne({ email });
        } else {
            return res.json({ success: false, message: "Invalid userType selected" });
        }

        if (!user) {
            return res.json({ success: false, message: "User doesn't exist in the selected category" });
        }

        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
            return res.json({ success: false, message: "Invalid password! Please try again" });
        }

        const token = createToken(user._id);
        
        res.json({ 
            success: true, 
            token, 
            userType,
            profileImage: user.profileImage // Add this line
        });

    } catch (error) {
        console.log(error);
        res.json({ success: false, message: "Error logging in" });
    }
};

// Function to create a JWT Token
const createToken = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET);
};


const signupuser = async (req, res) => {
    try {
        console.log("Received data:", req.body);

        if (!req.body.password) {
            return res.status(400).json({ success: false, message: "Password is required" });
        }

        // Check if email already exists in any collection
        const emailExists = await Promise.all([
            DonorModel.findOne({ email: req.body.email }),
            RecipientModel.findOne({ email: req.body.email }),
            VolunteerModel.findOne({ email: req.body.email })
        ]);

        if (emailExists.some(user => user !== null)) {
            return res.status(400).json({ 
                success: false, 
                message: "Email already exists. Please use a different email or login." 
            });
        }

        // Hash password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(req.body.password, salt);

        // Get file paths if they exist
        const profileImage = req.files?.profileImage ? req.files.profileImage[0].filename : null;
        const docImage = req.files?.docImage ? req.files.docImage[0].filename : null;

        // Create user based on userType
        let newUser;
        const commonFields = {
            username: req.body.username,
            email: req.body.email,
            contact: req.body.contact,
            password: hashedPassword,
            profileImage,
            about: req.body.about,
            identificationDoc: req.body.identificationDoc,
            docImage
        };

        if (req.body.userType === "Donor") {
            newUser = new DonorModel({
                ...commonFields,
                orgName: req.body.orgName,
                userType: "Donor"
            });
        } else if (req.body.userType === "Recipient") {
            newUser = new RecipientModel({
                ...commonFields,
                orgName: req.body.orgName,
                userType: "Recipient"
            });
        } else if (req.body.userType === "Volunteer") {
            newUser = new VolunteerModel({
                ...commonFields,
                skills: req.body.skills,
                availability: req.body.availability,
                userType: "Volunteer"
            });
        } else {
            return res.status(400).json({ success: false, message: "Invalid user type" });
        }

        const savedUser = await newUser.save();
        const token = createToken(savedUser._id);
        
        res.status(201).json({ 
            success: true, 
            message: "Signup successful!", 
            token,
            userType: savedUser.userType,
            profileImage: savedUser.profileImage 
        });

    } catch (error) {
        console.error("Signup error:", error);
        if (error.code === 11000) {
            res.status(400).json({ 
                success: false, 
                message: "Email already exists. Please use a different email or login." 
            });
        } else {
            res.status(500).json({ 
                success: false, 
                message: "Error during signup. Please try again." 
            });
        }
    }
};

const getUserProfile = async (req, res) => {
    try {
        const token = req.headers.authorization?.split(' ')[1];
        if (!token) {
            return res.status(401).json({ success: false, message: "No token provided" });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const userId = decoded.id;

        // Search in appropriate collection based on userType
        let user = await DonorModel.findById(userId).select('-password');
        if (!user) {
            user = await RecipientModel.findById(userId).select('-password');
        }
        if (!user) {
            user = await VolunteerModel.findById(userId).select('-password');
        }

        if (!user) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        res.json({ success: true, user });
    } catch (error) {
        console.error("Error fetching profile:", error);
        res.status(500).json({ success: false, message: "Error fetching profile" });
    }
};

const updateLocation = async (req, res) => {
    try {
      const token = req.headers.authorization?.split(' ')[1];
      if (!token) {
        return res.status(401).json({ success: false, message: "No token provided" });
      }
  
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const userId = decoded.id;
  
      const { coordinates } = req.body;
      
      const user = await RecipientModel.findByIdAndUpdate(
        userId,
        { coordinates },
        { new: true }
      );
  
      if (!user) {
        return res.status(404).json({ success: false, message: "User not found" });
      }
  
      res.json({ success: true, message: "Location updated successfully" });
    } catch (error) {
      console.error("Error updating location:", error);
      res.status(500).json({ success: false, message: "Error updating location" });
    }
  };
  

export { loginuser, signupuser, getUserProfile , updateLocation};
