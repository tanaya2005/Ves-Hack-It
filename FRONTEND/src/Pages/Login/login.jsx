// import React, { useState } from 'react';
// import { useNavigate } from 'react-router-dom'; // Import for navigation after login
// import { useAuth } from '../../context/authcontext'
// import './login.css';

// function Login() {
//   const { login } = useAuth();
//   const navigate = useNavigate(); // Hook for redirection
//   const [showPassword, setShowPassword] = useState(false);
//   const [userType, setUserType] = useState("Donor"); // Default to "donor"
//   const [data, setData] = useState({
//     email: "",
//     password: "",
//     userType: "Donor" // Ensure userType is part of the state
//   });

//   // Handle input change
//   const onchangehandler = (event) => {
//     const { name, value } = event.target;
//     setData((prevData) => ({
//       ...prevData,
//       [name]: value
//     }));
//   };


//   // Handle login submission
//   // Handle login submission
// const handleLogin = async (event) => {
//   event.preventDefault(); // Prevent page reload

//   try {
//     const response = await fetch("http://localhost:4000/api/user/login", {
//       method: "POST",
//       headers: {
//         "Content-Type": "application/json"
//       },
//       body: JSON.stringify(data)
//     });

//     const result = await response.json();

//     if (result.success) {
//       // Use the auth context login function
//       await login(result.token, result.userType, result.profileImage);
//       alert("Login successful!");
//       // Remove this part as it's server-side code and causing the error
//       // res.json({
//       //   success: true,
//       //   token: token,
//       //   userType: user.userType,
//       //   profileImage: user.profileImage
//       // });
//       navigate("/");
//     } else {
//       alert(result.message);
//     }
//   } catch (error) {
//     console.error("Error logging in:", error);
//     alert("Something went wrong. Please try again.");
//   }
// };


//   return (
//     <div className="login-container">
//       {/* Left Side with Image */}
//       <div className="login-image">
//         <img src="./src/assets/login-img.jpg" alt="Login" />
//       </div>

//       {/* Right Side with Login Form */}
//       <div className="login-form">
//         <h2>Login</h2>
//         <form onSubmit={handleLogin}>
//           {/* Email Input */}
//           <input
//             name="email"
//             type="email"
//             placeholder="Email"
//             value={data.email}
//             onChange={onchangehandler}
//             required
//           />

//           {/* Password Field with Show/Hide Feature */}
//           <div className="password-field">
//             <input
//               name="password"
//               type={showPassword ? "text" : "password"}
//               placeholder="Password"
//               value={data.password}
//               onChange={onchangehandler}
//               required
//             />
//             <button
//               type="button"
//               className="toggle-password"
//               onClick={() => setShowPassword(!showPassword)}
//             >
//               {showPassword ? "🙈 Hide" : "👁️ View"}
//             </button>
//           </div>

//           {/* Forgot Password Section */}
//           <div className="forgot-password">
//             <a href="#">Forgot Password?</a>
//           </div>

//           {/* User Type Selection */}
//           <p>You are logging in as:</p>
//           <div className="user-type-selection">
//             <label>
//               <input
//                 type="radio"
//                 name="userType"
//                 value="Donor"
//                 checked={data.userType === "Donor"}
//                 onChange={onchangehandler}
//               />
//               Donor
//             </label>
//             <label>
//               <input
//                 type="radio"
//                 name="userType"
//                 value="Recipient"
//                 checked={data.userType === "Recipient"}
//                 onChange={onchangehandler}
//               />
//               Recipient
//             </label>
//             <label>
//               <input
//                 type="radio"
//                 name="userType"
//                 value="Volunteer"
//                 checked={data.userType === "Volunteer"}
//                 onChange={onchangehandler}
//               />
//               Volunteer
//             </label>
//           </div>

//           {/* Login Button */}
//           <button type="submit">Login</button>
//           <br />
          
//         </form>
//       </div>
//     </div>


//   );
// }

// export default Login;




import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/authcontext';
import { signInWithEmailAndPassword, sendEmailVerification } from "firebase/auth";
import { auth } from '../../firebase/firebase';
import { Link } from 'react-router-dom';
import './login.css';

function Login() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [showPassword, setShowPassword] = useState(false);
  const [data, setData] = useState({
    email: "",
    password: "",
    userType: "Donor"
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  
  // Handle input change
  const onchangehandler = (event) => {
    const { name, value } = event.target;
    setData((prevData) => ({
      ...prevData,
      [name]: value
    }));
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

  // Handle login submission
  const handleLogin = async (event) => {
    event.preventDefault();
    setError('');
    setLoading(true);

    try {
      // First, authenticate with Firebase
      const firebaseResult = await loginWithFirebase(data.email, data.password);
      
      if (!firebaseResult.success) {
        setError(firebaseResult.error);
        setLoading(false);
        return;
      }

      // If Firebase authentication is successful, continue with your backend login
      const response = await fetch("http://localhost:4000/api/user/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          ...data,
          firebaseUid: firebaseResult.user.uid
        })
      });

      const result = await response.json();

      if (result.success) {
        // Use the auth context login function
        await login(result.token, result.userType, result.profileImage);
        navigate("/");
      } else {
        setError(result.message || "Login failed. Please try again.");
      }
    } catch (error) {
      console.error("Error logging in:", error);
      setError("Something went wrong. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  const handleResendVerification = async () => {
    try {
      // Need to sign in first to get the current user
      await signInWithEmailAndPassword(auth, data.email, data.password);
      const result = await resendVerificationEmail();
      
      if (result.success) {
        setError('Verification email has been resent. Please check your inbox.');
      } else {
        setError(`Failed to resend: ${result.error}`);
      }
    } catch (error) {
      setError(`Error: ${error.message}`);
    }
  };

  return (
    <div className="login-container">
      {/* Left Side with Image */}
      <div className="login-image">
        <img src="./src/assets/login-img.jpg" alt="Login" />
      </div>

      {/* Right Side with Login Form */}
      <div className="login-form">
        <h2>Login</h2>
        
        {error && (
          <div className="error-message">
            {error}
            {error.includes('verify your email') && (
              <button type="button" onClick={handleResendVerification} className="resend-button">
                Resend Verification Email
              </button>
            )}
          </div>
        )}
        
        <form onSubmit={handleLogin}>
          {/* Email Input */}
          <input
            name="email"
            type="email"
            placeholder="Email"
            value={data.email}
            onChange={onchangehandler}
            required
          />

          {/* Password Field with Show/Hide Feature */}
          <div className="password-field">
            <input
              name="password"
              type={showPassword ? "text" : "password"}
              placeholder="Password"
              value={data.password}
              onChange={onchangehandler}
              required
            />
            <button
              type="button"
              className="toggle-password"
              onClick={() => setShowPassword(!showPassword)}
            >
              {showPassword ? "🙈 Hide" : "👁️ View"}
            </button>
          </div>

          {/* Forgot Password Section */}
          <div className="forgot-password">
            <a href="#">Forgot Password?</a>
          </div>

          {/* User Type Selection */}
          <p>You are logging in as:</p>
          <div className="user-type-selection">
            <label>
              <input
                type="radio"
                name="userType"
                value="Donor"
                checked={data.userType === "Donor"}
                onChange={onchangehandler}
              />
              Donor
            </label>
            <label>
              <input
                type="radio"
                name="userType"
                value="Recipient"
                checked={data.userType === "Recipient"}
                onChange={onchangehandler}
              />
              Recipient
            </label>
            <label>
              <input
                type="radio"
                name="userType"
                value="Volunteer"
                checked={data.userType === "Volunteer"}
                onChange={onchangehandler}
              />
              Volunteer
            </label>
          </div>

          {/* Login Button */}
          <button type="submit" disabled={loading}>
            {loading ? 'Logging in...' : 'Login'}
          </button>
          <br />
          <div className="sign-up">
            <Link to="/signup" className="signup-btn">New here? Create an account</Link>
          </div>
        </form>
      </div>
    </div>
  );
}

export default Login;