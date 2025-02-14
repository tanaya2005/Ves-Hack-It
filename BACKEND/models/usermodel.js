import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    username: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    contact: { type: String, required: true },
    password: { type: String, required: true },
    userType: {
        type: String,
        required: true,
        enum: ['donor', 'recipient', 'volunteer']
    },
    about: { type: String },

    // Profile Image for all users
    profileImage: { type: String, required: true },

    // Organization Name (Only for Donors & Recipients)
    orgName: { 
        type: String, 
        required: function() { return this.userType === 'donor' || this.userType === 'recipient'; },
        default: null
    },

    // Fields for Volunteers Only
    skills: { 
        type: String, 
        required: function() { return this.userType === 'volunteer'; },
        default: null
    },
    availability: { 
        type: String, 
        required: function() { return this.userType === 'volunteer'; },
        default: null
    },
    identificationDoc: { 
        type: String, 
        required: function() { return this.userType === 'volunteer'; },
        default: null
    },
    docImage: { 
        type: String, 
        required: function() { return this.userType === 'volunteer'; },
        default: null
    }
});

const USERmodel = mongoose.models.user || mongoose.model('user', userSchema);
export default USERmodel;
