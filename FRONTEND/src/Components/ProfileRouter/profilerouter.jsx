// src/Components/ProfileRouter/profilerouter.jsx
import React from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '../../context/authcontext';

const ProfileRouter = () => {
  const { user, userType, isLoggedIn } = useAuth();
  
  // Add these console logs to debug
  console.log('ProfileRouter - User:', user);
  console.log('ProfileRouter - UserType:', userType);
  console.log('ProfileRouter - IsLoggedIn:', isLoggedIn);

  if (!isLoggedIn) {
    return <Navigate to="/login" replace />;
  }

  // Get userType from user object if direct userType is not available
  const effectiveUserType = userType || user?.userType;
  console.log('ProfileRouter - Effective UserType:', effectiveUserType);

  switch (effectiveUserType) {
    case 'Donor':
      return <Navigate to="/donorprofile" replace />;
    case 'Recipient':
      return <Navigate to="/recipientprofile" replace />;
    case 'Volunteer':
      return <Navigate to="/volunteerprofile" replace />;
    default:
      console.log('No valid user type found, redirecting to login');
      return <Navigate to="/login" replace />;
  }
};

export default ProfileRouter;