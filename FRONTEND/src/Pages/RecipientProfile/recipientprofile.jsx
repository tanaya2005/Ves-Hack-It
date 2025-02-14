// import React from "react";
// import { Link , useNavigate} from "react-router-dom";
// import "./recipientprofile.css";
// import { useState, useEffect } from "react";
// import { useAuth } from '../../context/authcontext';

// function RecipientProfile() {

//   const { userDetails, logout } = useAuth();
//   const navigate = useNavigate();
//   const [location, setLocation] = useState('');
//   const [loading, setLoading] = useState(true);

  
//   useEffect(() => {
//     // Get user's current location if coordinates exist in userDetails
//     const fetchLocation = async () => {
//       if (userDetails?.coordinates?.latitude && userDetails?.coordinates?.longitude) {
//         try {
//           const response = await fetch(
//             `https://api.opencagedata.com/geocode/v1/json?q=${userDetails.coordinates.latitude}+${userDetails.coordinates.longitude}&key=YOUR_OPENCAGE_API_KEY`
//           );
//           const data = await response.json();
//           if (data.results?.length > 0) {
//             setLocation(data.results[0].formatted);
//           }
//         } catch (error) {
//           console.error('Error fetching location:', error);
//           setLocation('Location not available');
//         }
//       }
//       setLoading(false);
//     };

//     if (userDetails) {
//       fetchLocation();
//     }
//   }, [userDetails]);


//   const handleLogout = () => {
//     logout();
//     navigate('/login');
//   };

//   if (loading || !userDetails) {
//     return <div>Loading...</div>;
//   }

//   return (
//     <div className="profile-container">
//       {/* Sidebar */}
//       <div className="sidebar">
//         <ul>
//           <li><Link to="/help">Help</Link></li>
//           <li><Link to="/language">Language</Link></li>
//           <li><Link to="/edit-profile">Edit Profile</Link></li>
//           <li><Link to="/settings">Settings</Link></li>
//           <li className="logout"><Link to="/logout">Logout</Link></li>
//         </ul>
//       </div>

//       {/* Right Side Content */}
//       <div className="main-content">
//         {/* Header with Profile Section */}
//         <div className="header-container">
//           <h2>Welcome {userDetails.username}!!</h2>
//           <div className="profile-section">
//             <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Profile" />
//             <h3>{userDetails.username}</h3>
//           </div>
//         </div>
//         <ul className="rdetails">
//           <li>Email-ID: {userDetails.email}</li>
//           <li>Contact number: {userDetails.contact} </li>
//           <li>Location:{location}</li>
//           <li>Organisation name:  {userDetails.orgName}</li>
//           <li>About: {userDetails.about}</li>
//         </ul>

//         {/* Donation Sections Side by Side */}
//         <div className="donation-container">
//           {/* Live Donations */}
//           <div className="donation-box">
//             <h3>Live Donations</h3>
//             <Link to="/live-donations" className="view-all">View All</Link>
//             <div className="donation-card">
//               <h4>Food from ABC Foundation</h4>
//               <p><strong>Status:</strong> <span style={{ color: "#FFA500" }}>On the Way</span></p>
//               <p><strong>Time:</strong> 1 hour ago</p>
//               <p><strong>Quantity:</strong> 15 meals</p>
//             </div>
//             <div className="donation-card">
//               <h4>Clothes from XYZ Charity</h4>
//               <p><strong>Status:</strong> <span style={{ color: "#FF4500" }}>Dispatched</span></p>
//               <p><strong>Time:</strong> 3 hours ago</p>
//               <p><strong>Quantity:</strong> 5 boxes</p>
//             </div>
//           </div>

//           {/* Previous Donations */}
//           <div className="donation-box">
//             <h3>Previous Donations</h3>
//             <Link to="/previous-donations" className="view-all">View All</Link>
//             <div className="donation-card">
//               <h4>Groceries from Helping Hands</h4>
//               <p><strong>Status:</strong> <span style={{ color: "#4CAF50" }}>Received</span></p>
//               <p><strong>Time:</strong> 2 days ago</p>
//               <p><strong>Quantity:</strong> 3 bags</p>
//             </div>
//             <div className="donation-card">
//               <h4>Blankets from Winter Warmth</h4>
//               <p><strong>Status:</strong> <span style={{ color: "#008000" }}>Delivered</span></p>
//               <p><strong>Time:</strong> 1 week ago</p>
//               <p><strong>Quantity:</strong> 20 blankets</p>
//             </div>
//           </div>
//         </div>
//       </div>
//     </div>
//   );
// }

// export default RecipientProfile;

import React from "react";
import { Link, useNavigate } from "react-router-dom";
import "./recipientprofile.css";
import { useState, useEffect } from "react";
import { useAuth } from '../../context/authcontext';

function RecipientProfile() {
  const { userDetails, logout } = useAuth();
  const navigate = useNavigate();
  const [location, setLocation] = useState('');
  const [loading, setLoading] = useState(true);
  const [loadingLocation, setLoadingLocation] = useState(false);
  const [hasLocation, setHasLocation] = useState(false);
  const [coordinates, setCoordinates] = useState({
    latitude: null,
    longitude: null
  });

  useEffect(() => {
    const fetchLocation = async () => {
      if (userDetails?.coordinates?.latitude && userDetails?.coordinates?.longitude) {
        try {
          const response = await fetch(
            `https://nominatim.openstreetmap.org/reverse?format=json&lat=${userDetails.coordinates.latitude}&lon=${userDetails.coordinates.longitude}`
          );
          const data = await response.json();
          if (data.display_name) {
            setLocation(data.display_name);
            setHasLocation(true);
          }
        } catch (error) {
          console.error('Error fetching location:', error);
          setLocation('Location not available');
        }
      }
      setLoading(false);
    };

    if (userDetails) {
      fetchLocation();
    }
  }, [userDetails]);

  const getUserLocation = () => {
    setLoadingLocation(true);

    if ('geolocation' in navigator) {
      navigator.geolocation.getCurrentPosition(
        async (position) => {
          const { latitude, longitude } = position.coords;
          setCoordinates({ latitude, longitude });

          try {
            const response = await fetch(
              `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}`
            );
            const data = await response.json();
            if (data.display_name) {
              setLocation(data.display_name);
              setHasLocation(true);
            } else {
              setLocation(`${latitude}, ${longitude}`);
              setHasLocation(true);
            }
          } catch (error) {
            console.error('Error fetching location:', error);
            setLocation(`${latitude}, ${longitude}`);
            setHasLocation(true);
          }

          setLoadingLocation(false);
        },
        (error) => {
          console.error('Error getting location:', error);
          setLoadingLocation(false);
          alert('Unable to fetch location. Please enable GPS.');
        }
      );
    } else {
      alert('Geolocation is not supported by your browser.');
      setLoadingLocation(false);
    }
  };

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  if (loading || !userDetails) {
    return <div>Loading...</div>;
  }

  return (
    <div className="profile-container">
      {/* Sidebar */}
      <div className="sidebar">
        <ul>
          <li><Link to="/help">Help</Link></li>
          <li><Link to="/language">Language</Link></li>
          <li><Link to="/edit-profile">Edit Profile</Link></li>
          <li><Link to="/settings">Settings</Link></li>
          <li className="logout"><Link to="/logout">Logout</Link></li>
        </ul>
      </div>

      {/* Right Side Content */}
      <div className="main-content">
        {/* Header with Profile Section */}
        <div className="header-container">
          <h2>Welcome {userDetails.username}!!</h2>
          <div className="profile-section">
            <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Profile" />
            <h3>{userDetails.username}</h3>
          </div>
        </div>
        <ul className="rdetails">
          <li>Email-ID: {userDetails.email}</li>
          <li>Contact number: {userDetails.contact}</li>
          <li>
            Location: {location || 'Not set'}
            {!hasLocation && (
              <button 
                onClick={getUserLocation}
                className="location-button"
                disabled={loadingLocation}
              >
                {loadingLocation ? 'Fetching...' : 'Get Location'}
              </button>
            )}
          </li>
          <li>Organisation name: {userDetails.orgName}</li>
          <li>About: {userDetails.about}</li>
        </ul>

        {/* Donation Sections Side by Side */}
        <div className="donation-container">
          {/* Live Donations */}
          <div className="donation-box">
            <h3>Live Donations</h3>
            <Link to="/live-donations" className="view-all">View All</Link>
            <div className="donation-card">
              <h4>Food from ABC Foundation</h4>
              <p><strong>Status:</strong> <span style={{ color: "#FFA500" }}>On the Way</span></p>
              <p><strong>Time:</strong> 1 hour ago</p>
              <p><strong>Quantity:</strong> 15 meals</p>
            </div>
            <div className="donation-card">
              <h4>Clothes from XYZ Charity</h4>
              <p><strong>Status:</strong> <span style={{ color: "#FF4500" }}>Dispatched</span></p>
              <p><strong>Time:</strong> 3 hours ago</p>
              <p><strong>Quantity:</strong> 5 boxes</p>
            </div>
          </div>

          {/* Previous Donations */}
          <div className="donation-box">
            <h3>Previous Donations</h3>
            <Link to="/previous-donations" className="view-all">View All</Link>
            <div className="donation-card">
              <h4>Groceries from Helping Hands</h4>
              <p><strong>Status:</strong> <span style={{ color: "#4CAF50" }}>Received</span></p>
              <p><strong>Time:</strong> 2 days ago</p>
              <p><strong>Quantity:</strong> 3 bags</p>
            </div>
            <div className="donation-card">
              <h4>Blankets from Winter Warmth</h4>
              <p><strong>Status:</strong> <span style={{ color: "#008000" }}>Delivered</span></p>
              <p><strong>Time:</strong> 1 week ago</p>
              <p><strong>Quantity:</strong> 20 blankets</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default RecipientProfile;