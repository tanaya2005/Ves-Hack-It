// test/insertSampleDonations.js
import mongoose from 'mongoose';
import model1 from '../models/model1.js';

const insertSampleData = async () => {
    try {
        // Connect to your database
        await mongoose.connect('mongodb://localhost:27017/test');
        
        // Insert the sample donations
        await DonationModel.insertMany(sampleDonations);
        
        console.log('Sample donations inserted successfully!');
    } catch (error) {
        console.error('Error inserting sample data:', error);
    } finally {
        mongoose.disconnect();
    }
};

insertSampleData();