// import React, { createContext, useState, useContext, useEffect } from 'react';

// const AuthContext = createContext(null);

// export const AuthProvider = ({ children }) => {
//     const [user, setUser] = useState(null); 
//     const [isLoggedIn, setIsLoggedIn] = useState(false);
//     const [profileImage, setProfileImage] = useState(null);
//     const [userType, setUserType] = useState(null);
//     const [loading, setLoading] = useState(false);
//     const [userDetails, setUserDetails] = useState(null);

//     useEffect(() => {
//         const token = localStorage.getItem('token');
//         const storedProfileImage = localStorage.getItem('profileImage');
//         const storedUserType = localStorage.getItem('userType');
        
//         if (token) {
//             setUser({
//                 token,
                
//                 userType: storedUserType,
//                 profileImage: storedProfileImage
//             });
//             setIsLoggedIn(true);
//             fetchUserProfile(token);
//             setProfileImage(storedProfileImage);
//             setUserType(storedUserType);
//         setLoading(false);
//         }
//     }, []);


//     const fetchUserProfile = async (token) => {
//         try {
//             const response = await fetch('http://localhost:4000/api/user/profile', {
//                 headers: {
//                     'Authorization': `Bearer ${token}`
//                 }
//             });
//             const data = await response.json();
//             if (data.success) {
//                 setUserDetails(data.user);
//                 setIsLoggedIn(true);
//                 setProfileImage(data.user.profileImage);
//                 setUserType(data.user.userType);
//             }
//         } catch (error) {
//             console.error('Error fetching profile:', error);
//         }
//     };


//     const login = async (token, userType, profileImage) => {
//         localStorage.setItem('token', token);
//         localStorage.setItem('userType', userType);
//         localStorage.setItem('profileImage', profileImage);
//         setUser({
//             token,
//             userType,
//             profileImage
//         });
//         setIsLoggedIn(true);
//         setProfileImage(profileImage);
//         setUserType(userType);
//         await fetchUserProfile(token);
//     };

//     const logout = () => {
//         localStorage.removeItem('token');
//         localStorage.removeItem('userType');
//         localStorage.removeItem('profileImage');
//         setUser(null);
//         setIsLoggedIn(false);
//         setProfileImage(null);
//         setUserType(null);
//         setUserDetails(null);
//     };

//     return (
//         <AuthContext.Provider value={{ 
//             user, 
//             isLoggedIn, 
//             profileImage, 
//             userType, 
//             loading, 
//             userDetails,
//             setLoading ,
//             login, 
//             logout 
//         }}>
//             {children}
//         </AuthContext.Provider>
//     );
// };

// export const useAuth = () => useContext(AuthContext);


import React, { createContext, useState, useContext, useEffect } from 'react';
import { 
  createUserWithEmailAndPassword, 
  signInWithEmailAndPassword,
  signOut,
  sendEmailVerification,
  onAuthStateChanged
} from "firebase/auth";
import { auth } from '../firebase/firebase';

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null); 
    const [isLoggedIn, setIsLoggedIn] = useState(false);
    const [profileImage, setProfileImage] = useState(null);
    const [userType, setUserType] = useState(null);
    const [loading, setLoading] = useState(true);
    const [userDetails, setUserDetails] = useState(null);

    useEffect(() => {
        const unsubscribe = onAuthStateChanged(auth, (firebaseUser) => {
            if (firebaseUser) {
                // User is signed in
                const token = localStorage.getItem('token');
                const storedProfileImage = localStorage.getItem('profileImage');
                const storedUserType = localStorage.getItem('userType');
                
                setUser({
                    token,
                    userType: storedUserType,
                    profileImage: storedProfileImage,
                    email: firebaseUser.email,
                    emailVerified: firebaseUser.emailVerified,
                    uid: firebaseUser.uid
                });
                setIsLoggedIn(true);
                
                if (token) {
                    fetchUserProfile(token);
                }
                
                setProfileImage(storedProfileImage);
                setUserType(storedUserType);
            } else {
                // User is signed out
                setUser(null);
                setIsLoggedIn(false);
                setProfileImage(null);
                setUserType(null);
                setUserDetails(null);
            }
            setLoading(false);
        });

        // Cleanup subscription
        return () => unsubscribe();
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
                setProfileImage(data.user.profileImage);
                setUserType(data.user.userType);
            }
        } catch (error) {
            console.error('Error fetching profile:', error);
        }
    };

    const registerWithFirebase = async (email, password) => {
        try {
            const userCredential = await createUserWithEmailAndPassword(auth, email, password);
            await sendEmailVerification(userCredential.user);
            return { success: true, user: userCredential.user };
        } catch (error) {
            return { success: false, error: error.message };
        }
    };

    const loginWithFirebase = async (email, password) => {
        try {
            const userCredential = await signInWithEmailAndPassword(auth, email, password);
            if (!userCredential.user.emailVerified) {
                return { success: false, error: 'Please verify your email before logging in' };
            }
            return { success: true, user: userCredential.user };
        } catch (error) {
            return { success: false, error: error.message };
        }
    };

    const login = async (token, userType, profileImage) => {
        localStorage.setItem('token', token);
        localStorage.setItem('userType', userType);
        localStorage.setItem('profileImage', profileImage);
        
        const firebaseUser = auth.currentUser;
        setUser({
            token,
            userType,
            profileImage,
            email: firebaseUser?.email,
            emailVerified: firebaseUser?.emailVerified,
            uid: firebaseUser?.uid
        });
        
        setIsLoggedIn(true);
        setProfileImage(profileImage);
        setUserType(userType);
        await fetchUserProfile(token);
    };

    const logout = async () => {
        try {
            await signOut(auth);
            localStorage.removeItem('token');
            localStorage.removeItem('userType');
            localStorage.removeItem('profileImage');
            setUser(null);
            setIsLoggedIn(false);
            setProfileImage(null);
            setUserType(null);
            setUserDetails(null);
        } catch (error) {
            console.error("Error signing out: ", error);
        }
    };

    const resendVerificationEmail = async () => {
        if (auth.currentUser) {
            try {
                await sendEmailVerification(auth.currentUser);
                return { success: true };
            } catch (error) {
                return { success: false, error: error.message };
            }
        }
        return { success: false, error: 'No user is currently signed in' };
    };

    return (
        <AuthContext.Provider value={{ 
            user, 
            isLoggedIn, 
            profileImage, 
            userType, 
            loading, 
            userDetails,
            setLoading,
            registerWithFirebase,
            loginWithFirebase,
            resendVerificationEmail,
            login, 
            logout 
        }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => useContext(AuthContext);