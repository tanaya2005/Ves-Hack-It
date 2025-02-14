import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './livedonations.css';
import ProtectedRoute from '../../Components/ProtectedRoute/protectedroute.jsx';

const getDistance = (lat1, lon1, lat2, lon2) => {
    const R = 6371;
    const dLat = (lat2 - lat1) * (Math.PI / 180);
    const dLon = (lon2 - lon1) * (Math.PI / 180);
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(lat1 * (Math.PI / 180)) * Math.cos(lat2 * (Math.PI / 180)) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
};

const LiveDonations = () => {
    const [userLocation, setUserLocation] = useState(null);
    const [sortedDonations, setSortedDonations] = useState([]);
    const [loading, setLoading] = useState(true);
    const [acceptingDonation, setAcceptingDonation] = useState(null);

    const fetchDonations = async () => {
        try {
            const response = await axios.get('http://localhost:4000/api/donations/donslist');
            if (response.data.success) {
                return response.data.data.filter(donation => !donation.isAccepted);
            }
            return [];
        } catch (error) {
            console.error('Error fetching donations:', error);
            return [];
        }
    };

    const handleAccept = async (donationId) => {
        if (!window.confirm('Are you sure you want to accept this donation?')) {
            return;
        }

        setAcceptingDonation(donationId);
        try {
            const response = await axios.post('http://localhost:4000/api/donations/accept', {
                donationId
            });

            if (response.data.success) {
                setSortedDonations(prevDonations =>
                    prevDonations.filter(donation => donation._id !== donationId)
                );
                alert('Donation accepted successfully!');
            } else {
                alert('Failed to accept donation. Please try again.');
            }
        } catch (error) {
            console.error('Error accepting donation:', error);
            alert('Error accepting donation. Please try again.');
        } finally {
            setAcceptingDonation(null);
        }
    };

    useEffect(() => {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                async (position) => {
                    const { latitude, longitude } = position.coords;
                    setUserLocation({ latitude, longitude });

                    const donations = await fetchDonations();

                    const donationsWithDistance = donations.map(donation => ({
                        ...donation,
                        distance: getDistance(
                            latitude,
                            longitude,
                            donation.latitude,
                            donation.longitude
                        )
                    }));

                    const sorted = donationsWithDistance.sort((a, b) => a.distance - b.distance);
                    setSortedDonations(sorted);
                    setLoading(false);
                },
                (error) => {
                    console.error("Error getting location:", error);
                    alert("Allow location access to see nearby donations.");
                    setLoading(false);
                }
            );
        } else {
            alert("Geolocation is not supported by this browser.");
            setLoading(false);
        }
    }, []);

    // Function to refresh donations periodically
    useEffect(() => {
        const refreshInterval = setInterval(async () => {
            if (userLocation) {
                const donations = await fetchDonations();
                const donationsWithDistance = donations.map(donation => ({
                    ...donation,
                    distance: getDistance(
                        userLocation.latitude,
                        userLocation.longitude,
                        donation.latitude,
                        donation.longitude
                    )
                }));
                const sorted = donationsWithDistance.sort((a, b) => a.distance - b.distance);
                setSortedDonations(sorted);
            }
        }, 30000); // Refresh every 30 seconds

        return () => clearInterval(refreshInterval);
    }, [userLocation]);

    return (
        <ProtectedRoute allowedRoles={['Donor', 'Recipient', 'Volunteer']}>
            <div className="livedonations">
                <h2>📍 Live Donations Near You</h2>
                {userLocation ? (
                    <p>Your Location: 🌍 {userLocation.latitude.toFixed(3)}, {userLocation.longitude.toFixed(3)}</p>
                ) : (
                    <p>Fetching your location...</p>
                )}

                <div className="donations-container">
                    {loading ? (
                        <p>Loading donations...</p>
                    ) : sortedDonations.length > 0 ? (
                        sortedDonations.map((item) => (
                            <div key={item._id} className="donation-card">
                                <img
                                    src={`http://localhost:4000/uploads/${item.imageUrl}`}
                                    alt={item.foodName}
                                    className="donation-image"
                                />
                                <div className="donation-details">
                                    <h3>{item.foodName}</h3>
                                    <p><strong>Posted by:</strong> {item.organizationName}</p>
                                    <p><strong>Quantity:</strong> {item.quantity}</p>
                                    <p><strong>Expiry:</strong> {item.expiryDateTime}</p>
                                    <p><strong>Location:</strong> {item.location}</p>
                                    <p><strong>Distance:</strong> {item.distance.toFixed(1)} km</p>
                                    <p className="description"><strong>Description:</strong> {item.description}</p>
                                </div>
                                <div className="donation-actions">
                                    <button className="chat-btn">💬 Chat</button>
                                    <button 
                                        className="accept-btn"
                                        onClick={() => handleAccept(item._id)}
                                        disabled={acceptingDonation === item._id}
                                    >
                                        {acceptingDonation === item._id ? 
                                            'Accepting...' : 
                                            '✔ Accept'}
                                    </button>
                                </div>
                            </div>
                        ))
                    ) : (
                        <p className="no-donations">❌ No donations available.</p>
                    )}
                </div>
            </div>
        </ProtectedRoute>
    );
};

export default LiveDonations;
