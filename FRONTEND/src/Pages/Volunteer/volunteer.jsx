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

// import React from 'react';
// import { Link } from 'react-router-dom';
// import './volunteer.css';
// import VolunteerProtectedRoute from '../../Components/ProtectedRouteVolunteer/protectedroutevolunteer.jsx';

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
//     <VolunteerProtectedRoute allowedRoles={['Volunteer']}>
//       <div className="volunteer-recipient-section">
//         {/* Volunteer Section */}
//         <div className="volunteer-content">
//           {/* Leaderboard Quote Section */}
//           <div className="leaderboard-quote">
//             <h2>🌟 Every Hour Counts, Every Effort Matters!</h2>
//             <p>
//               The <strong>most dedicated volunteers</strong> are making a real difference—<br />
//               <strong>one meal, one act of kindness at a time.</strong><br />
//               Join our mission and leave your impact on the leaderboard!
//             </p>
//           </div>

//           {/* Leaderboard Preview Section */}
//           <div className="leaderboard-preview">
//             <h2>🏆 Top Volunteers</h2>
//             <div className="leaderboard-cards">
//               <div className="leaderboard-card">
//                 <img src={assets.volunteer1} alt="Top Volunteer" />
//                 <p>🥇 Sarah Smith - 120 Hours</p>
//               </div>
//               <div className="leaderboard-card">
//                 <img src={assets.volunteer2} alt="Top Volunteer" />
//                 <p>🥈 Daniel Lee - 110 Hours</p>
//               </div>
//               <div className="leaderboard-card">
//                 <img src={assets.volunteer3} alt="Top Volunteer" />
//                 <p>🥉 Olivia Brown - 95 Hours</p>
//               </div>
//             </div>
//             <br />
//             <Link to="/Volunteerleaderboard" className="view-leaderboard">View Full Leaderboard</Link>
//           </div>

//           {/* Meet Our Volunteers Section */}
//           <div className="meet-volunteers">
//             <h2>🤝 Meet Our Volunteers</h2>
//             <p>Learn about the incredible people who dedicate their time to make a difference.</p>
//             <Link to="/volunteerprofile" className="volunteer-profile-btn">View Volunteer Profiles</Link>
//           </div>
//         </div>

//         {/* Recipient Section */}
//         <div className="recipient-content">
//           {/* Impact Quote Section */}
//           <div className="impact-quote">
//             <h2>🍽️ Every Meal Given, Every Life Touched!</h2>
//             <p>
//               Your kindness is changing lives—<br />
//               Meet the people who have received support and see the impact!
//             </p>
//           </div>

//           {/* Recent Recipients Section */}
//           <div className="recent-recipients">
//             <h2>🌍 Recent Recipients</h2>
//             <div className="recipient-cards">
//               <div className="recipient-card">
//                 <img src={assets.recipient1} alt="Recipient" />
//                 <p>👤 John Doe - Received 5 Meals</p>
//               </div>
//               <div className="recipient-card">
//                 <img src={assets.recipient2} alt="Recipient" />
//                 <p>👤 Maria Gomez - Received 10 Meals</p>
//               </div>
//               <div className="recipient-card">
//                 <img src={assets.recipient3} alt="Recipient" />
//                 <p>👤 Ahmed Khan - Received 7 Meals</p>
//               </div>
//             </div>
//             <br />
//             <Link to="/recipients" className="view-recipients">View All Recipients</Link>
//           </div>

//           {/* Meet Our Recipients Section */}
//           <div className="meet-recipients">
//             <h2>🤝 Meet Our Recipients</h2>
//             <p>Read about the stories of those who have been helped through this platform.</p>
//             <Link to="/recipientprofile" className="recipient-profile-btn">View Recipient Profiles</Link>
//           </div>
//         </div>
//       </div>
//     </VolunteerProtectedRoute>
//   );
// };

// export default Volunteer;

import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import './volunteer.css';
import VolunteerProtectedRoute from '../../Components/ProtectedRouteVolunteer/protectedroutevolunteer.jsx';
import axios from 'axios';
import { useAuth } from '../../context/authcontext';

const Volunteer = () => {
  const [liveOrders, setLiveOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { user } = useAuth();

  useEffect(() => {
    // Fetch live orders that need delivery
    const fetchLiveOrders = async () => {
      try {
        const response = await axios.get('http://localhost:4000/api/volunteer/live-orders', {
          headers: {
            'Authorization': `Bearer ${user?.token}`
          }
        });
        setLiveOrders(response.data);
        setLoading(false);
      } catch (err) {
        console.error('Error fetching live orders:', err);
        setError('Failed to load available orders. Please try again later.');
        setLoading(false);
      }
    };

    if (user?.token) {
      fetchLiveOrders();
    }
  }, [user]);

  const handleAcceptOrder = async (orderId) => {
    try {
      await axios.post(`http://localhost:4000/api/volunteer/accept-order/${orderId}`, {}, {
        headers: {
          'Authorization': `Bearer ${user?.token}`
        }
      });
      
      // Remove the accepted order from the list
      setLiveOrders(prevOrders => prevOrders.filter(order => order._id !== orderId));
      alert('Order accepted successfully! Please proceed with the delivery.');
    } catch (err) {
      console.error('Error accepting order:', err);
      alert('Failed to accept order. Please try again.');
    }
  };

  return (
    <VolunteerProtectedRoute allowedRoles={['Volunteer']}>
      <div className="volunteer-page">
        <header className="volunteer-header">
          <h1>Volunteer Dashboard</h1>
          <p>Thank you for making a difference in your community!</p>
        </header>

        <section className="live-orders-section">
          <h2>Available Orders for Delivery</h2>
          
          {loading ? (
            <div className="loading-spinner">Loading available orders...</div>
          ) : error ? (
            <div className="error-message">{error}</div>
          ) : liveOrders.length === 0 ? (
            <div className="no-orders-message">
              <p>There are no available orders at the moment.</p>
              <p>Please check back later or contact the admin for more information.</p>
            </div>
          ) : (
            <div className="order-cards-container">
              {liveOrders.map(order => (
                <div key={order._id} className="order-card">
                  <div className="order-header">
                    <span className="order-id">Order #{order.orderNumber}</span>
                    <span className="order-time">Posted: {new Date(order.createdAt).toLocaleString()}</span>
                  </div>
                  
                  <div className="order-details">
                    <div className="location-detail">
                      <h4>Pickup Location:</h4>
                      <p>{order.pickupLocation}</p>
                    </div>
                    
                    <div className="location-detail">
                      <h4>Drop Location:</h4>
                      <p>{order.dropLocation}</p>
                    </div>
                    
                    <div className="food-detail">
                      <h4>Food Item:</h4>
                      <p>{order.foodName}</p>
                      <p className="food-quantity">Quantity: {order.quantity}</p>
                    </div>
                    
                    <div className="additional-info">
                      <h4>Description:</h4>
                      <p>{order.description}</p>
                    </div>
                    
                    {order.estimatedDistance && (
                      <div className="distance-info">
                        <p>Estimated Distance: {order.estimatedDistance} km</p>
                      </div>
                    )}
                  </div>
                  
                  <button 
                    className="accept-order-btn"
                    onClick={() => handleAcceptOrder(order._id)}
                  >
                    Accept Delivery Request
                  </button>
                </div>
              ))}
            </div>
          )}
        </section>
        
        <section className="volunteer-info-section">
          <h2>Important Information</h2>
          <div className="info-cards">
            <div className="info-card">
              <h3>Delivery Guidelines</h3>
              <ul>
                <li>Verify the food items before picking up</li>
                <li>Ensure proper handling and hygiene</li>
                <li>Confirm recipient identity before handover</li>
                <li>Report any issues immediately through the app</li>
              </ul>
            </div>
            
            <div className="info-card">
              <h3>Contact Support</h3>
              <p>Need help with a delivery?</p>
              <p>Contact our support team:</p>
              <p>Phone: (123) 456-7890</p>
              <p>Email: support@fooddonation.org</p>
            </div>
          </div>
        </section>
        
        <section className="my-deliveries-section">
          <h2>My Active Deliveries</h2>
          <Link to="/my-deliveries" className="view-deliveries-btn">
            View My Active Deliveries
          </Link>
        </section>
      </div>
    </VolunteerProtectedRoute>
  );
};

export default Volunteer;