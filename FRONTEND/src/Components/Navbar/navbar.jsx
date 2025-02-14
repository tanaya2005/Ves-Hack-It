

import React, { useState, useEffect } from 'react';
import './navbar.css';
import { assets } from '../../assets/assets';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/authcontext';

const Navbar = () => {
  const navigate = useNavigate();
  const { isLoggedIn, userType, logout, profileImage } = useAuth();

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  const getProfileImage = () => {
    if (profileImage) {
      return `http://localhost:4000/uploads/${profileImage}`;
    }
    return assets.profile; // Your default profile image
  };

  return (
    <div className="navbar">
      {/* Left Side - Logo & Brand Name */}
      <div className="left">
        <img src={assets.foododonar} alt="logo" />
        <Link to="/">Kindmeals</Link>
      </div>

      {/* Middle - Navigation Links */}
      <div className="middle">
        <Link to="/">Home</Link>
        <Link to="/services">Services</Link>
        <Link to="/adddonation">Add a Donation</Link>
        <Link to="/livedonations">Live Donations</Link>
        <Link to="/volunteer">Volunteer</Link>
        <Link to="/charity">Charity</Link>
        <Link to="/enquire">Enquire</Link>
      </div>

      {/* Right Side - Language & Auth/Profile */}
      <ul className="right">
        <li>
          <img src={assets.language} className='rimg' alt="change language" />
        </li>
        {isLoggedIn ? (
          <li className="profile-dropdown">
            <img 
              src={getProfileImage()}
              alt="profile" 
              className="profile-image"
              onError={(e) => {
                e.target.onerror = null;
                e.target.src = assets.profile;
              }}
            />
            {/* <div className="dropdown-content">
              <Link to="/profile">Profile</Link>
              <button onClick={handleLogout}>Logout</button>
            </div> */}
            <div className="dropdown-content">
              <Link to="/profile">Profile</Link> {/* This will now automatically redirect based on userType */}
              <button onClick={handleLogout}>Logout</button>
            </div>
          </li>
        ) : (
          <li className="auth-buttons">
            <Link to="/login" className="login-btn">Login</Link>
            <Link to="/signup" className="signup-btn">Sign Up</Link>
          </li>
        )}
      </ul>
    </div>
  );
};

export default Navbar;