// src/components/ProtectedRoute/VolunteerProtectedRoute.jsx
import React from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '../../context/authcontext';
import './protectedroutevolunteer.css';

const VolunteerProtectedRoute = ({ allowedRoles, children }) => {
  const { user } = useAuth();

  // If not logged in
  if (!user?.token) {
    return (
      <div className="protected-container">
        <h2>Want to make a difference? Join us as a volunteer!</h2>
        <p>Please login to continue</p>
        <button 
          className="auth-button" 
          onClick={() => window.location.href = '/login'}
        >
          Login/Signup here
        </button>
      </div>
    );
  }

  // If logged in but wrong role
  if (allowedRoles && !allowedRoles.includes(user.userType)) {
    return (
      <div className="protected-container">
        <h2>Ready to help those in need?</h2>
        <p>Please login as a volunteer to access this feature</p>
        <button 
          className="auth-button"
          onClick={() => window.location.href = '/login'}
        >
          Login/Signup as Volunteer
        </button>
      </div>
    );
  }

  return children;
};

export default VolunteerProtectedRoute;
