// src/context/authContext.js
import { createContext, useState, useContext, useEffect } from 'react';

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [profileImage, setProfileImage] = useState(null);

  useEffect(() => {
    // Check authentication status on mount
    const token = localStorage.getItem('token');
    const storedProfileImage = localStorage.getItem('profileImage');
    
    if (token) {
      setUser({
        token,
        userType: localStorage.getItem('userType'),
        profileImage: storedProfileImage
      });
      setProfileImage(storedProfileImage);
    }
    setLoading(false);
  }, []);

  const login = async (token, userType, profileImage) => {
    localStorage.setItem('token', token);
    localStorage.setItem('userType', userType);
    localStorage.setItem('profileImage', profileImage);
    
    setUser({
      token,
      userType,
      profileImage
    });
    setProfileImage(profileImage);
  };

  const logout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('userType');
    localStorage.removeItem('profileImage');
    setUser(null);
    setProfileImage(null);
  };

  const updateProfileImage = (newImagePath) => {
    localStorage.setItem('profileImage', newImagePath);
    setProfileImage(newImagePath);
    setUser(prev => ({
      ...prev,
      profileImage: newImagePath
    }));
  };

  const value = {
    user,
    login,
    logout,
    loading,
    profileImage,
    updateProfileImage
  };

  return (
    <AuthContext.Provider value={value}>
      {!loading && children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};