// import React from 'react';
// import { Link } from 'react-router-dom';
// import './volunteer.css';

// // Define assets object with image paths (replace with actual paths)
// const assets = {
//   volunteer1: '/images/volunteer1.jpg',
//   volunteer2: '/images/volunteer2.jpg',
//   volunteer3: '/images/volunteer3.jpg',
//   recipient1: '/images/recipient1.jpg',
//   recipient2: '/images/recipient2.jpg',
//   recipient3: '/images/recipient3.jpg',
// };

// const Volunteer = () => {
//   return (
//     <div className="volunteer-recipient-section">
//       {/* Volunteer Section */}
//       <div className="volunteer-content">
//         {/* Leaderboard Quote Section */}
//         <div className="leaderboard-quote">
//           <h2>🌟 Every Hour Counts, Every Effort Matters!</h2>
//           <p>
//             The <strong>most dedicated volunteers</strong> are making a real difference—<br />
//             <strong>one meal, one act of kindness at a time.</strong><br />
//             Join our mission and leave your impact on the leaderboard!
//           </p>
//         </div>

//         {/* Leaderboard Preview Section */}
//         <div className="leaderboard-preview">
//           <h2>🏆 Top Volunteers</h2>
//           <div className="leaderboard-cards">
//             <div className="leaderboard-card">
//               <img src={assets.volunteer1} alt="Top Volunteer" />
//               <p>🥇 Sarah Smith - 120 Hours</p>
//             </div>
//             <div className="leaderboard-card">
//               <img src={assets.volunteer2} alt="Top Volunteer" />
//               <p>🥈 Daniel Lee - 110 Hours</p>
//             </div>
//             <div className="leaderboard-card">
//               <img src={assets.volunteer3} alt="Top Volunteer" />
//               <p>🥉 Olivia Brown - 95 Hours</p>
//             </div>
//           </div>
//           <br />
//           <Link to="/Volunteerleaderboard" className="view-leaderboard">View Full Leaderboard</Link>
//         </div>

//         {/* Meet Our Volunteers Section */}
//         <div className="meet-volunteers">
//           <h2>🤝 Meet Our Volunteers</h2>
//           <p>Learn about the incredible people who dedicate their time to make a difference.</p>
//           <Link to="/volunteerprofile" className="volunteer-profile-btn">View Volunteer Profiles</Link>
//         </div>
//       </div>

//       {/* Recipient Section */}
//       <div className="recipient-content">
//         {/* Impact Quote Section */}
//         <div className="impact-quote">
//           <h2>🍽️ Every Meal Given, Every Life Touched!</h2>
//           <p>
//             Your kindness is changing lives—<br />
//             Meet the people who have received support and see the impact!
//           </p>
//         </div>

//         {/* Recent Recipients Section */}
//         <div className="recent-recipients">
//           <h2>🌍 Recent Recipients</h2>
//           <div className="recipient-cards">
//             <div className="recipient-card">
//               <img src={assets.recipient1} alt="Recipient" />
//               <p>👤 John Doe - Received 5 Meals</p>
//             </div>
//             <div className="recipient-card">
//               <img src={assets.recipient2} alt="Recipient" />
//               <p>👤 Maria Gomez - Received 10 Meals</p>
//             </div>
//             <div className="recipient-card">
//               <img src={assets.recipient3} alt="Recipient" />
//               <p>👤 Ahmed Khan - Received 7 Meals</p>
//             </div>
//           </div>
//           <br />
//           <Link to="/recipients" className="view-recipients">View All Recipients</Link>
//         </div>

//         {/* Meet Our Recipients Section */}
//         <div className="meet-recipients">
//           <h2>🤝 Meet Our Recipients</h2>
//           <p>Read about the stories of those who have been helped through this platform.</p>
//           <Link to="/recipientprofile" className="recipient-profile-btn">View Recipient Profiles</Link>
//         </div>
//       </div>
//     </div>
//   );
// };

// export default Volunteer;

import React from 'react';
import { Link } from 'react-router-dom';
import './volunteer.css';
import VolunteerProtectedRoute from '../../Components/ProtectedRouteVolunteer/protectedroutevolunteer.jsx';

// Define assets object with image paths (replace with actual paths)
const assets = {
  volunteer1: '/images/volunteer1.jpg',
  volunteer2: '/images/volunteer2.jpg',
  volunteer3: '/images/volunteer3.jpg',
  recipient1: '/images/recipient1.jpg',
  recipient2: '/images/recipient2.jpg',
  recipient3: '/images/recipient3.jpg',
};

const Volunteer = () => {
  return (
    <VolunteerProtectedRoute allowedRoles={['Volunteer']}>
      <div className="volunteer-recipient-section">
        {/* Volunteer Section */}
        <div className="volunteer-content">
          {/* Leaderboard Quote Section */}
          <div className="leaderboard-quote">
            <h2>🌟 Every Hour Counts, Every Effort Matters!</h2>
            <p>
              The <strong>most dedicated volunteers</strong> are making a real difference—<br />
              <strong>one meal, one act of kindness at a time.</strong><br />
              Join our mission and leave your impact on the leaderboard!
            </p>
          </div>

          {/* Leaderboard Preview Section */}
          <div className="leaderboard-preview">
            <h2>🏆 Top Volunteers</h2>
            <div className="leaderboard-cards">
              <div className="leaderboard-card">
                <img src={assets.volunteer1} alt="Top Volunteer" />
                <p>🥇 Sarah Smith - 120 Hours</p>
              </div>
              <div className="leaderboard-card">
                <img src={assets.volunteer2} alt="Top Volunteer" />
                <p>🥈 Daniel Lee - 110 Hours</p>
              </div>
              <div className="leaderboard-card">
                <img src={assets.volunteer3} alt="Top Volunteer" />
                <p>🥉 Olivia Brown - 95 Hours</p>
              </div>
            </div>
            <br />
            <Link to="/Volunteerleaderboard" className="view-leaderboard">View Full Leaderboard</Link>
          </div>

          {/* Meet Our Volunteers Section */}
          <div className="meet-volunteers">
            <h2>🤝 Meet Our Volunteers</h2>
            <p>Learn about the incredible people who dedicate their time to make a difference.</p>
            <Link to="/volunteerprofile" className="volunteer-profile-btn">View Volunteer Profiles</Link>
          </div>
        </div>

        {/* Recipient Section */}
        <div className="recipient-content">
          {/* Impact Quote Section */}
          <div className="impact-quote">
            <h2>🍽️ Every Meal Given, Every Life Touched!</h2>
            <p>
              Your kindness is changing lives—<br />
              Meet the people who have received support and see the impact!
            </p>
          </div>

          {/* Recent Recipients Section */}
          <div className="recent-recipients">
            <h2>🌍 Recent Recipients</h2>
            <div className="recipient-cards">
              <div className="recipient-card">
                <img src={assets.recipient1} alt="Recipient" />
                <p>👤 John Doe - Received 5 Meals</p>
              </div>
              <div className="recipient-card">
                <img src={assets.recipient2} alt="Recipient" />
                <p>👤 Maria Gomez - Received 10 Meals</p>
              </div>
              <div className="recipient-card">
                <img src={assets.recipient3} alt="Recipient" />
                <p>👤 Ahmed Khan - Received 7 Meals</p>
              </div>
            </div>
            <br />
            <Link to="/recipients" className="view-recipients">View All Recipients</Link>
          </div>

          {/* Meet Our Recipients Section */}
          <div className="meet-recipients">
            <h2>🤝 Meet Our Recipients</h2>
            <p>Read about the stories of those who have been helped through this platform.</p>
            <Link to="/recipientprofile" className="recipient-profile-btn">View Recipient Profiles</Link>
          </div>
        </div>
      </div>
    </VolunteerProtectedRoute>
  );
};

export default Volunteer;