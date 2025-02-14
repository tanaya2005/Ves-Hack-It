import express from 'express'
import multer from 'multer' // for creating image storage system
import path from 'path'
import { add_Dons, donslist, removedon, acceptDonation } from '../controllers/doncontroller.js'
import fs from 'fs' // to check if directory exists

// create an express router
const donRouter = express.Router();
// using this router, we can create get, post methods, etc.

// Ensure uploads directory exists
const uploadDir = path.join(process.cwd(), "uploads");
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

// img storage engine using multer storage disk method
const storage = multer.diskStorage({
    destination: uploadDir,
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}${path.extname(file.originalname)}`); // unique filename
    }
});

const upload = multer({ storage: storage }); // middleware upload has been created

donRouter.post("/add", upload.single("image"), add_Dons);
/// "add" endpoint where we used the middleware "upload" we created using multer package to upload the image
donRouter.get("/donslist", donslist);
donRouter.post("/remove", removedon); // NEW: Using POST and sending ID in request body
donRouter.post("/accept", acceptDonation);


export default donRouter;
