import express from "express";
import { loginuser, signupuser, getUserProfile, updateLocation } from "../controllers/usercontroller.js";

import upload from '../middleware/multerConfig.js';


const userRouter = express.Router();
userRouter.post("/signup", upload.fields([
    { name: 'profileImage', maxCount: 1 },
    { name: 'docImage', maxCount: 1 }
]), signupuser);
userRouter.post("/login", loginuser); // Ensure login supports userType
userRouter.get("/profile", getUserProfile);
userRouter.post("/update-location", updateLocation);
export default userRouter;
