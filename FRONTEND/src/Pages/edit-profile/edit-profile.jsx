import React, { useState } from "react";
import "./edit-Profile.css";

const EditProfile = () => {
  const [profileImage, setProfileImage] = useState(null);

  const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
      setProfileImage(URL.createObjectURL(file));
    }
  };

  return (
    <div className="edit-profile">
      <h2>Edit Profile</h2>

      {/* Profile Picture Upload */}
      <div className="profile-section">
        <label className="profile-image-label">
          <input type="file" accept="image/*" onChange={handleImageUpload} hidden />
          <img
            src={profileImage || "https://via.placeholder.com/120"}
            alt="Profile"
            className="profile-image"
          />
          <span className="upload-text">Change</span>
        </label>
      </div>

      {/* User Information */}
      <div className="form-group">
        <label>Full Name</label>
        <input type="text" placeholder="Enter full name" />
      </div>

      <div className="form-group">
        <label>Email (Cannot be changed)</label>
        <input type="email" value="user@example.com" disabled />
      </div>

      <div className="form-group">
        <label>Phone Number</label>
        <input type="text" placeholder="Enter phone number" />
      </div>

      <div className="form-group">
        <label>Address</label>
        <input type="text" placeholder="Enter your address" />
      </div>

      <div className="form-group">
        <label>Organization</label>
        <input type="text" placeholder="Enter your organization" />
      </div>

      <div className="form-group">
        <label>About</label>
        <textarea placeholder="Write about yourself..." rows="4"></textarea>
      </div>

      {/* Security Options */}
      <h3>Security</h3>
      <div className="security-section">
        <button className="change-password">Change Password</button>
        <button className="delete-account">Delete Account</button>
      </div>

      {/* Save Button */}
      <button className="save-btn">Save Changes</button>
    </div>
  );
};

export default EditProfile;
