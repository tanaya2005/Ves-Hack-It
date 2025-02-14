import React from "react";
import "./App.css";
import { AuthProvider } from "./context/authcontext";
import Navbar from "./Components/Navbar/navbar";
import { Routes, Route } from "react-router-dom";
import ScrollToTop from ".//ScrollToTop";
import ChatBox from "./Components/Chatbox/chatbox";
import Home from "./Pages/Home/home";
import LiveDonations from "./Pages/LiveDonations/livedonations";
import AddDonation from "./Pages/AddDonation/adddonation";
import Enquire from "./Pages/Enquire/enquire";
import Services from "./Pages/Serv/services";
import Charity from "./Pages/Charity/charity";
import Volunteer from "./Pages/Volunteer/volunteer";
import Login from "./Pages/Login/login";
import Signup from "./Pages/Sign-up/sign-up";
import EditProfile from "./Pages/edit-profile/edit-profile";
import DonationHistory from "./Pages/DonationHistory/DonationHistory";
import Footer from "./Components/Footer/footer";
import Help from "./Pages/Help/help";
import VolunteerLeaderboard from "./Pages/VolunteerLeaderboard/volunteerleaderboard";
import ActiveDonations from "./Pages/ActiveDonation/activedonation";
import ProfileRouter from './Components/ProfileRouter/profilerouter';
import DonorProfile from './Pages/DonorProfile/donorprofile';
import RecipientProfile from './Pages/RecipientProfile/recipientprofile';
import VolunteerProfile from './Pages/VolunteerProfile/volunteerprofile';
import ProtectedRoute from './Components/ProtectedRoute/protectedroute'; // Add this import
import MyDeliveries from './Pages/MyDeliveries/MyDeliveries';

const App = () => {
  return (
    <AuthProvider>
      <div className="app">
        <Navbar />
        <ScrollToTop />

        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/services" element={<Services />} />
          <Route path="/livedonations" element={<LiveDonations />} />
          <Route path="/adddonation" element={<AddDonation />} />
          <Route path="/enquire" element={<Enquire />} />
          <Route path="/charity" element={<Charity />} />
          <Route path="/volunteer" element={<Volunteer />} />
          <Route path="/profile" element={<ProfileRouter />} /> {/* Uncomment and use ProfileRouter */}
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/edit-profile" element={<EditProfile />} />
          <Route path="/donationhistory" element={<DonationHistory />} />
          <Route path="/footer" element={<Footer />} />
          <Route path="/help" element={<Help />} />
          <Route path="/Volunteerleaderboard" element={<VolunteerLeaderboard />} />
          <Route path="/Activedonation" element={<ActiveDonations />} />
          <Route path='/my-deliveries' element={<MyDeliveries />} />
          <Route 
            path="/donorprofile" 
            element={
              <ProtectedRoute allowedRoles={['Donor']}>
                <DonorProfile />
              </ProtectedRoute>
            } 
          />
          <Route 
            path="/recipientprofile" 
            element={
              <ProtectedRoute allowedRoles={['Recipient']}>
                <RecipientProfile />
              </ProtectedRoute>
            } 
          />
          <Route 
            path="/volunteerprofile" 
            element={
              <ProtectedRoute allowedRoles={['Volunteer']}>
                <VolunteerProfile />
              </ProtectedRoute>
            } 
          />
        </Routes>

        <Footer />

        <div className="chat">
          <ChatBox />
        </div>
      </div>
    </AuthProvider>
  );
};

export default App;