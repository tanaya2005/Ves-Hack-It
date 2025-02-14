import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/authcontext'
import './sign-up.css';
import { Link } from 'react-router-dom';

function Signup() {
  const { login } = useAuth();
  const [userType, setUserType] = useState("Donor");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [contact, setContact] = useState("");
  const [about, setAbout] = useState("");
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [profileImage, setProfileImage] = useState(null);
  const [orgName, setOrgName] = useState("");
  const [identificationDoc, setIdentificationDoc] = useState("Aadhaar");
  const [docImage, setDocImage] = useState(null);
  const [skills, setSkills] = useState("");
  const [availability, setAvailability] = useState("");

  const navigate = useNavigate();

  // In sign-up.jsx
  const handleSignup = async (event) => {
    event.preventDefault();

    try {
        const formData = new FormData();

        // Append all form fields
        formData.append("username", username);
        formData.append("email", email);
        formData.append("contact", contact);
        formData.append("password", password);
        formData.append("userType", userType);
        formData.append("about", about);
        formData.append("identificationDoc", identificationDoc);

        // Conditional fields
        if (userType === "Donor" || userType === "Recipient") {
            formData.append("orgName", orgName);
        }
        if (userType === "Volunteer") {
            formData.append("skills", skills);
            formData.append("availability", availability);
        }

        // Files
        if (profileImage) {
            formData.append("profileImage", profileImage);
        }
        if (docImage) {
            formData.append("docImage", docImage);
        }

        const response = await fetch("http://localhost:4000/api/user/signup", {
            method: "POST",
            body: formData
        });

        const data = await response.json();

        if (data.success) {
            await login(data.token, data.userType, data.profileImage);
            alert("Signup successful! You can now contribute!");
            navigate("/");
        } else {
            alert(data.message || "Signup failed. Please try again.");
        }
    } catch (error) {
        console.error("Error signing up:", error);
        alert("Error during signup. Please try again. Make sure you're using a unique email address.");
    }
};


const captureLocation = () => {
  if ("geolocation" in navigator) {
    navigator.geolocation.getCurrentPosition(
      async (position) => {
        const coordinates = {
          latitude: position.coords.latitude,
          longitude: position.coords.longitude
        };
        
        // Send to backend
        try {
          const response = await fetch('http://localhost:4000/api/user/update-location', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${localStorage.getItem('token')}`
            },
            body: JSON.stringify({ coordinates })
          });
          const data = await response.json();
          if (data.success) {
            console.log('Location updated successfully');
          }
        } catch (error) {
          console.error('Error updating location:', error);
        }
      },
      (error) => {
        console.error("Error getting location:", error);
      }
    );
  }
};

  return (
    <div className="signup-container">
      {/* Left Side - Image */}
      <div className="signup-image">
        <img src="./src/assets/login-img.jpg" alt="Signup" />
      </div>

      <div className="signup-form">
        <h2>Sign Up</h2>
        <form onSubmit={handleSignup}>
          <input type="text" placeholder="Full Name" value={username} onChange={(e) => setUsername(e.target.value)} required />
          <input type="email" placeholder="Email Address" value={email} onChange={(e) => setEmail(e.target.value)} required />
          <input type="tel" placeholder="Phone Number" value={contact} onChange={(e) => setContact(e.target.value)} required />

          <div className="password-field">
            <input type={showPassword ? "text" : "password"} placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} required />
            <button type="button" onClick={() => setShowPassword(!showPassword)}>
              {showPassword ? "🙈 Hide" : "👁️ View"}
            </button>
          </div>
          <p>You are signing up as:</p>
          <div className="user-type-selection">
         
          <label><input type="radio" value="Donor" checked={userType === "Donor"} onChange={(e) => setUserType(e.target.value)} /> Donor</label>
          <label><input type="radio" value="Recipient" checked={userType === "Recipient"} onChange={(e) => setUserType(e.target.value)} /> Recipient</label>
          <label><input type="radio" value="Volunteer" checked={userType === "Volunteer"} onChange={(e) => setUserType(e.target.value)} /> Volunteer</label>
      </div>
          {(userType === "Recipient" || userType === "Donor") && (
            <input type="text" placeholder="Organization Name" value={orgName} onChange={(e) => setOrgName(e.target.value)} required />
          )}

          {userType === "Volunteer" && (
            <>
              <input type="text" placeholder="Skills (e.g., Delivery, Coordination)" value={skills} onChange={(e) => setSkills(e.target.value)} required />
              <input type="text" placeholder="Availability" value={availability} onChange={(e) => setAvailability(e.target.value)} required />
            </>
          )}

          <div className="photo">
            Upload Profile Photo:
            <input type="file" accept="image/*" onChange={(e) => setProfileImage(e.target.files[0])} required />
          </div>

          <div className="document-upload">
            <label>Choose an ID Document:</label>
            <select value={identificationDoc} onChange={(e) => setIdentificationDoc(e.target.value)} required>
              <option value="Aadhaar">Aadhaar</option>
              <option value="PAN">PAN</option>
              <option value="Voter ID">Voter ID</option>
            </select>
            <input type="file" accept="image/*" onChange={(e) => setDocImage(e.target.files[0])} required />
          </div>

          <textarea placeholder="Tell us about yourself or your organization" value={about} onChange={(e) => setAbout(e.target.value)} required />
          <button type="submit">Sign Up</button>
          <div className="log-in">
            <br />
           <Link to ="/login" className="login-btn">Already have an account? Log in</Link>
          </div>
        </form>
      </div>
    </div>
  );
}

export default Signup;