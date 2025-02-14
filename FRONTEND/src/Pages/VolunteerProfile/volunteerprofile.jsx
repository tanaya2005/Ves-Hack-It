import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import './volunteerprofile.css';
import { useAuth } from '../../context/authcontext';
import { useEffect, useState } from 'react';

function VolunteerProfile() {


  const { userDetails, logout } = useAuth();
  const navigate = useNavigate();
  const [location, setLocation] = useState('');
  const [loading, setLoading] = useState(true);
  const [leaderboard, setLeaderboard] = useState([
    { rank: 1, name: "Sarah Smith", hours: 150 },
    { rank: 2, name: "Daniel Lee", hours: 135 },
    { rank: 3, name: "Olivia Brown", hours: 120 },
    { rank: 4, name: "Alex Johnson", hours: 110 },
    { rank: 5, name: "Emily Davis", hours: 100 }
  ]);

  useEffect(() => {
    const fetchLocation = async () => {
      if (userDetails?.coordinates?.latitude && userDetails?.coordinates?.longitude) {
        try {
          const response = await fetch(
            `https://api.opencagedata.com/geocode/v1/json?q=${userDetails.coordinates.latitude}+${userDetails.coordinates.longitude}&key=YOUR_OPENCAGE_API_KEY`
          );
          const data = await response.json();
          if (data.results?.length > 0) {
            setLocation(data.results[0].formatted);
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

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  if (loading || !userDetails) {
    return <div>Loading...</div>;
  };

   // Helper function to safely display skills
   const displaySkills = () => {
    if (!userDetails.skills) return 'Not specified';
    if (Array.isArray(userDetails.skills)) return userDetails.skills.join(', ');
    return userDetails.skills;
  };

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

      {/* Main Content */}
      <div className="main-content">
        {/* Header */}
        <div className="header-container">
          <h2>Welcome, {userDetails.username}!</h2>
          <div className="profile-section">
            <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Volunteer" />
          </div>
        </div>

          <ul className="vdetails">
          <li>Email-ID: {userDetails.email}</li>
          <li>Contact number: {userDetails.contact}</li>
          {/* <li>Location: {location}</li> */}
          <li>Skills: {displaySkills()}</li>
          <li>About: {userDetails.about}</li>
          <li>Availability: {userDetails.availability || 'Not specified'}</li>
        </ul>

         {/* Previous Contributions  */}
        <div className="previous-contributions">
          <div className="section-header">
            <h3>Previous Contributions</h3>
            <Link to="/previouscontribution" className="view-all-top">View All</Link>
          </div>
          <div className="contribution-wrapper">
            <div className="contribution-card">
              <h4>Organized Food Drive</h4>
              <p><strong>Status:</strong> <span className="status-completed">Completed</span></p>
              <p><strong>Date:</strong> Jan 5, 2024</p>
              <p><strong>Served:</strong> 500+ people</p>
            </div>
            <div className="contribution-card">
              <h4>Assisted in Shelter Meal Distribution</h4>
              <p><strong>Status:</strong> <span className="status-ongoing">Ongoing</span></p>
              <p><strong>Date:</strong> Feb 2, 2024</p>
              <p><strong>Location:</strong> XYZ Shelter</p>
            </div>
          </div>
        </div>

         {/* Leaderboard Section  */}
        <div className="leaderboard-section">
          <h3>🏆 Volunteer Leaderboard</h3>
          <table className="leaderboard-table">
            <thead>
              <tr>
                <th>Rank</th>
                <th>Name</th>
                <th>Hours Served</th>
              </tr>
            </thead>
            <tbody>
              <tr><td>1</td><td>Sarah Smith</td><td>150</td></tr>
              <tr><td>2</td><td>Daniel Lee</td><td>135</td></tr>
              <tr><td>3</td><td>Olivia Brown</td><td>120</td></tr>
              <tr><td>4</td><td>Alex Johnson</td><td>110</td></tr>
              <tr><td>5</td><td>Emily Davis</td><td>100</td></tr>
            </tbody>
          </table>
          <div className="view-link-container">
            <Link to="/Volunteerleaderboard" className="view-leaderboard">View Full Leaderboard</Link>
          </div>
        </div>
      </div>
    </div>
  );
}

export default VolunteerProfile; 

