// // src/Pages/MyDeliveries/MyDeliveries.jsx
// import React, { useState, useEffect } from 'react';
// import { useAuth } from '../../context/authcontext';
// import axios from 'axios';
// import VolunteerProtectedRoute from '../../Components/ProtectedRouteVolunteer/protectedroutevolunteer.jsx';
// import './MyDeliveries.css';

// const MyDeliveries = () => {
//   const [activeDeliveries, setActiveDeliveries] = useState([]);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const { user } = useAuth();

//   useEffect(() => {
//     const fetchMyDeliveries = async () => {
//       try {
//         const response = await axios.get('http://localhost:4000/api/volunteer/my-deliveries', {
//           headers: {
//             'Authorization': `Bearer ${user?.token}`
//           }
//         });
//         setActiveDeliveries(response.data);
//         setLoading(false);
//       } catch (err) {
//         console.error('Error fetching my deliveries:', err);
//         setError('Failed to load your active deliveries. Please try again later.');
//         setLoading(false);
//       }
//     };

//     if (user?.token) {
//       fetchMyDeliveries();
//     }
//   }, [user]);

//   const handleUpdateStatus = async (orderId, newStatus) => {
//     try {
//       await axios.put(`http://localhost:4000/api/volunteer/update-status/${orderId}`, 
//         { status: newStatus },
//         {
//           headers: {
//             'Authorization': `Bearer ${user?.token}`
//           }
//         }
//       );
      
//       // Update the local state
//       setActiveDeliveries(prevDeliveries => 
//         prevDeliveries.map(delivery => 
//           delivery._id === orderId 
//             ? { ...delivery, status: newStatus } 
//             : delivery
//         )
//       );
      
//       if (newStatus === 'delivered') {
//         // Remove from active list if delivered
//         setActiveDeliveries(prevDeliveries => 
//           prevDeliveries.filter(delivery => delivery._id !== orderId)
//         );
//       }
      
//       alert(`Order status updated to ${newStatus}`);
//     } catch (err) {
//       console.error('Error updating delivery status:', err);
//       alert('Failed to update delivery status. Please try again.');
//     }
//   };

//   return (
//     <VolunteerProtectedRoute allowedRoles={['Volunteer']}>
//       <div className="my-deliveries-page">
//         <header className="my-deliveries-header">
//           <h1>My Active Deliveries</h1>
//           <p>Manage your ongoing food deliveries</p>
//         </header>

//         {loading ? (
//           <div className="loading-spinner">Loading your deliveries...</div>
//         ) : error ? (
//           <div className="error-message">{error}</div>
//         ) : activeDeliveries.length === 0 ? (
//           <div className="no-deliveries-message">
//             <p>You don't have any active deliveries at the moment.</p>
//             <p>Check the available orders page to accept new delivery requests.</p>
//           </div>
//         ) : (
//           <div className="delivery-cards-container">
//             {activeDeliveries.map(delivery => (
//               <div key={delivery._id} className={`delivery-card status-${delivery.status}`}>
//                 <div className="delivery-header">
//                   <span className="order-id">Order #{delivery.orderNumber}</span>
//                   <span className="status-badge">{delivery.status}</span>
//                 </div>
                
//                 <div className="delivery-details">
//                   <div className="location-detail">
//                     <h4>Pickup Location:</h4>
//                     <p>{delivery.pickupLocation}</p>
//                   </div>
                  
//                   <div className="location-detail">
//                     <h4>Drop Location:</h4>
//                     <p>{delivery.dropLocation}</p>
//                   </div>
                  
//                   <div className="food-detail">
//                     <h4>Food Item:</h4>
//                     <p>{delivery.foodName}</p>
//                     <p className="food-quantity">Quantity: {delivery.quantity}</p>
//                   </div>
//                 </div>
                
//                 <div className="action-buttons">
//                   {delivery.status === 'accepted' && (
//                     <button 
//                       className="update-status-btn in-transit"
//                       onClick={() => handleUpdateStatus(delivery._id, 'in_transit')}
//                     >
//                       Mark as In Transit
//                     </button>
//                   )}
                  
//                   {delivery.status === 'in_transit' && (
//                     <button 
//                       className="update-status-btn delivered"
//                       onClick={() => handleUpdateStatus(delivery._id, 'delivered')}
//                     >
//                       Mark as Delivered
//                     </button>
//                   )}
//                 </div>
//               </div>
//             ))}
//           </div>
//         )}
//       </div>
//     </VolunteerProtectedRoute>
//   );
// };

// export default MyDeliveries;

// src/Pages/MyDeliveries/MyDeliveries.jsx
import React, { useState, useEffect } from 'react';
import { useAuth } from '../../context/authcontext';
import axios from 'axios';
import VolunteerProtectedRoute from '../../Components/ProtectedRouteVolunteer/protectedroutevolunteer.jsx';
import './MyDeliveries.css';

const MyDeliveries = () => {
  const [activeDeliveries, setActiveDeliveries] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { user } = useAuth();

  useEffect(() => {
    const fetchMyDeliveries = async () => {
      try {
        // Uncomment the API call when backend is ready
        // const response = await axios.get('http://localhost:4000/api/volunteer/my-deliveries', {
        //   headers: { 'Authorization': `Bearer ${user?.token}` }
        // });
        // setActiveDeliveries(response.data);

        // Sample data for frontend testing
        const sampleData = [
          {
            _id: "1",
            orderNumber: "12345",
            pickupLocation: "Community Center, Sector 10",
            dropLocation: "Orphanage, Street 5",
            foodName: "Vegetable Biryani",
            quantity: "5 plates",
            status: "accepted"
          },
          {
            _id: "2",
            orderNumber: "12346",
            pickupLocation: "Hotel Paradise, Downtown",
            dropLocation: "Elderly Care Home, Block B",
            foodName: "Pasta and Bread",
            quantity: "10 servings",
            status: "in_transit"
          },
          {
            _id: "3",
            orderNumber: "12347",
            pickupLocation: "Café Aroma, MG Road",
            dropLocation: "Local Shelter, City Square",
            foodName: "Sandwiches and Juice",
            quantity: "8 packets",
            status: "delivered"
          }
        ];

        setActiveDeliveries(sampleData);
        setLoading(false);
      } catch (err) {
        console.error('Error fetching my deliveries:', err);
        setError('Failed to load your active deliveries. Please try again later.');
        setLoading(false);
      }
    };

    fetchMyDeliveries();
  }, []);

  const handleUpdateStatus = async (orderId, newStatus) => {
    try {
      // Uncomment when backend is ready
      // await axios.put(`http://localhost:4000/api/volunteer/update-status/${orderId}`, 
      //   { status: newStatus },
      //   {
      //     headers: { 'Authorization': `Bearer ${user?.token}` }
      //   }
      // );

      // Update the local state
      setActiveDeliveries(prevDeliveries => 
        prevDeliveries.map(delivery => 
          delivery._id === orderId ? { ...delivery, status: newStatus } : delivery
        )
      );

      if (newStatus === 'delivered') {
        // Remove from active list if delivered
        setActiveDeliveries(prevDeliveries => 
          prevDeliveries.filter(delivery => delivery._id !== orderId)
        );
      }

      alert(`Order status updated to ${newStatus}`);
    } catch (err) {
      console.error('Error updating delivery status:', err);
      alert('Failed to update delivery status. Please try again.');
    }
  };

  return (
    <VolunteerProtectedRoute allowedRoles={['Volunteer']}>
      <div className="my-deliveries-page">
        <header className="my-deliveries-header">
          <h1>My Active Deliveries</h1>
          <p>Manage your ongoing food deliveries</p>
        </header>

        {loading ? (
          <div className="loading-spinner">Loading your deliveries...</div>
        ) : error ? (
          <div className="error-message">{error}</div>
        ) : activeDeliveries.length === 0 ? (
          <div className="no-deliveries-message">
            <p>You don't have any active deliveries at the moment.</p>
            <p>Check the available orders page to accept new delivery requests.</p>
          </div>
        ) : (
          <div className="delivery-cards-container">
            {activeDeliveries.map(delivery => (
              <div key={delivery._id} className={`delivery-card status-${delivery.status}`}>
                <div className="delivery-header">
                  <span className="order-id">Order #{delivery.orderNumber}</span>
                  <span className={`status-badge status-${delivery.status}`}>{delivery.status}</span>
                </div>
                
                <div className="delivery-details">
                  <div className="location-detail">
                    <h4>Pickup Location:</h4>
                    <p>{delivery.pickupLocation}</p>
                  </div>
                  
                  <div className="location-detail">
                    <h4>Drop Location:</h4>
                    <p>{delivery.dropLocation}</p>
                  </div>
                  
                  <div className="food-detail">
                    <h4>Food Item:</h4>
                    <p>{delivery.foodName}</p>
                    <p className="food-quantity">Quantity: {delivery.quantity}</p>
                  </div>
                </div>
                
                <div className="action-buttons">
                  {delivery.status === 'accepted' && (
                    <button 
                      className="update-status-btn in-transit"
                      onClick={() => handleUpdateStatus(delivery._id, 'in_transit')}
                    >
                      Mark as In Transit
                    </button>
                  )}
                  
                  {delivery.status === 'in_transit' && (
                    <button 
                      className="update-status-btn delivered"
                      onClick={() => handleUpdateStatus(delivery._id, 'delivered')}
                    >
                      Mark as Delivered
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </VolunteerProtectedRoute>
  );
};

export default MyDeliveries;
