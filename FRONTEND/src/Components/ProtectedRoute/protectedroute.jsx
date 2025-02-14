// src/components/ProtectedRoute/ProtectedRoute.jsx
import React from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '../../context/authcontext';
import './protectedroute.css';

const ProtectedRoute = ({ allowedRoles, children }) => {
  const { user } = useAuth();

  // If not logged in
  if (!user?.token) {
    return (
      <div className="protected-container">
        <h2>Want to help the needy, be kind and prevent food waste?</h2>
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
        <h2>Want to help the needy, be kind and prevent food waste?</h2>
        <p>Please login as a donor to access this feature</p>
        <button 
          className="auth-button"
          onClick={() => window.location.href = '/login'}
        >
          Login/Signup as Donor
        </button>
      </div>
    );
  }

  return children;
};

export default ProtectedRoute;