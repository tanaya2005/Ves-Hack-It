import React, { createContext, useState, useContext, useEffect } from 'react';

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null); 
    const [isLoggedIn, setIsLoggedIn] = useState(false);
    const [profileImage, setProfileImage] = useState(null);
    const [userType, setUserType] = useState(null);
    const [loading, setLoading] = useState(false);
    const [userDetails, setUserDetails] = useState(null);

    useEffect(() => {
        const token = localStorage.getItem('token');
        const storedProfileImage = localStorage.getItem('profileImage');
        const storedUserType = localStorage.getItem('userType');
        
        if (token) {
            setUser({
                token,
                
                userType: storedUserType,
                profileImage: storedProfileImage
            });
            setIsLoggedIn(true);
            fetchUserProfile(token);
            setProfileImage(storedProfileImage);
            setUserType(storedUserType);
        setLoading(false);
        }
    }, []);


    const fetchUserProfile = async (token) => {
        try {
            const response = await fetch('http://localhost:4000/api/user/profile', {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });
            const data = await response.json();
            if (data.success) {
                setUserDetails(data.user);
                setIsLoggedIn(true);
                setProfileImage(data.user.profileImage);
                setUserType(data.user.userType);
            }
        } catch (error) {
            console.error('Error fetching profile:', error);
        }
    };


    const login = async (token, userType, profileImage) => {
        localStorage.setItem('token', token);
        localStorage.setItem('userType', userType);
        localStorage.setItem('profileImage', profileImage);
        setUser({
            token,
            userType,
            profileImage
        });
        setIsLoggedIn(true);
        setProfileImage(profileImage);
        setUserType(userType);
        await fetchUserProfile(token);
    };

    const logout = () => {
        localStorage.removeItem('token');
        localStorage.removeItem('userType');
        localStorage.removeItem('profileImage');
        setUser(null);
        setIsLoggedIn(false);
        setProfileImage(null);
        setUserType(null);
        setUserDetails(null);
    };

    return (
        <AuthContext.Provider value={{ 
            user, 
            isLoggedIn, 
            profileImage, 
            userType, 
            loading, 
            userDetails,
            setLoading ,
            login, 
            logout 
        }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => useContext(AuthContext);