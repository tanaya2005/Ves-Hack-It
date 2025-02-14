import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom'; // Import for navigation after login
import { useAuth } from '../../context/authcontext'
import './login.css';

function Login() {
  const { login } = useAuth();
  const navigate = useNavigate(); // Hook for redirection
  const [showPassword, setShowPassword] = useState(false);
  const [userType, setUserType] = useState("Donor"); // Default to "donor"
  const [data, setData] = useState({
    email: "",
    password: "",
    userType: "Donor" // Ensure userType is part of the state
  });

  // Handle input change
  const onchangehandler = (event) => {
    const { name, value } = event.target;
    setData((prevData) => ({
      ...prevData,
      [name]: value
    }));
  };


  // Handle login submission
  // Handle login submission
const handleLogin = async (event) => {
  event.preventDefault(); // Prevent page reload

  try {
    const response = await fetch("http://localhost:4000/api/user/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(data)
    });

    const result = await response.json();

    if (result.success) {
      // Use the auth context login function
      await login(result.token, result.userType, result.profileImage);
      alert("Login successful!");
      // Remove this part as it's server-side code and causing the error
      // res.json({
      //   success: true,
      //   token: token,
      //   userType: user.userType,
      //   profileImage: user.profileImage
      // });
      navigate("/");
    } else {
      alert(result.message);
    }
  } catch (error) {
    console.error("Error logging in:", error);
    alert("Something went wrong. Please try again.");
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
          <button type="submit">Login</button>
          <br />
          
        </form>
      </div>
    </div>


  );
}

export default Login;
