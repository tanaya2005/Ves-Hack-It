import express from "express";
import cors from "cors";
import { connectDB } from "./config/db.js";
import donRouter from "./routes/donsroute.js";
import userRouter from "./routes/userroute.js";
import volunteerRoutes from './routes/volunteerRoutes.js';
import path from "path";
import { fileURLToPath } from 'url';
import { EventEmitter } from 'events';  // Add this line
EventEmitter.defaultMaxListeners = 15;  // Add this line


import fs from "fs";
import 'dotenv/config';

// app config
const app = express();
const port = 5000;

// middlewares
app.use(express.json());
app.use(cors()); // Allow cross-origin requests

// db connections
connectDB();

// Ensure "uploads" directory exists
const uploadDir = path.join(process.cwd(), "uploads");
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ... your other imports and middleware

// Add this line to serve files from uploads directory
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
// API endpoints
app.use("/api/donations", donRouter);
app.use("/images", express.static(uploadDir)); // Serves images via http://localhost:4000/images/<filename>
app.use("/api/user", userRouter);


// In your main backend server file (e.g., server.js or index.js)
app.use('/uploads', express.static('uploads'));


// Home route
app.get("/", (req, res) => {
    res.send("API is working");
});

app.use('/api/volunteer', volunteerRoutes);

//this was to handle images on the same ip address
// const PORT = process.env.PORT || 3000;
// const IP = '192.168.x.x'; // Replace with your computer's IP address
// app.listen(PORT, IP, () => console.log(`Server running on http://${IP}:${PORT}`));



// Start server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
