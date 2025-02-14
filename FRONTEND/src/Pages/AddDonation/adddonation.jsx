import React, { useState } from 'react';
import './adddonation.css';
import axios from 'axios';
import ProtectedRoute from '../../Components/ProtectedRoute/protectedroute.jsx';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/authcontext';

const AddDonation = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [formData, setFormData] = useState({
    foodName: '',
    quantity: '',
    description: '',
    expiryDateTime: '',
    foodType: '',
    location: '',
    organizationName: '', // Added organization name
    latitude: '',         // Added latitude
    longitude: ''         // Added longitude
  });

  const [selectedImage, setSelectedImage] = useState(null);
  const [imagePreview, setImagePreview] = useState(null);
  const [loadingLocation, setLoadingLocation] = useState(false);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value
    }));
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    setSelectedImage(file);

    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result);
      };
      reader.readAsDataURL(file);
    }
  };

  const getUserLocation = () => {
    setLoadingLocation(true);

    if ('geolocation' in navigator) {
      navigator.geolocation.getCurrentPosition(
        async (position) => {
          const { latitude, longitude } = position.coords;
          console.log('Latitude:', latitude, 'Longitude:', longitude);

          try {
            const response = await fetch(
              `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}`
            );
            const data = await response.json();
            console.log('Location:', data.display_name);

            setFormData((prev) => ({
              ...prev,
              location: data.display_name || `${latitude}, ${longitude}`,
              latitude: latitude,    // Store latitude
              longitude: longitude   // Store longitude
            }));
          } catch (error) {
            console.error('Error fetching location:', error);
            setFormData((prev) => ({
              ...prev,
              location: `${latitude}, ${longitude}`,
              latitude: latitude,    // Store latitude even if address lookup fails
              longitude: longitude   // Store longitude even if address lookup fails
            }));
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
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const formDataToSend = new FormData();
      
      // Convert latitude and longitude to numbers
      const numLatitude = parseFloat(formData.latitude);
      const numLongitude = parseFloat(formData.longitude);

      // Basic validation
      if (!formData.organizationName) {
        alert('Organization name is required');
        return;
      }

      if (isNaN(numLatitude) || isNaN(numLongitude)) {
        alert('Please get your location first');
        return;
      }
      
      // Append all form fields, ensuring proper types
      formDataToSend.append('foodName', formData.foodName);
      formDataToSend.append('quantity', formData.quantity);
      formDataToSend.append('description', formData.description);
      formDataToSend.append('expiryDateTime', formData.expiryDateTime);
      formDataToSend.append('foodType', formData.foodType);
      formDataToSend.append('location', formData.location);
      formDataToSend.append('organizationName', formData.organizationName);
      formDataToSend.append('latitude', numLatitude.toString());
      formDataToSend.append('longitude', numLongitude.toString());
      
      // Append the image file
      if (selectedImage) {
        formDataToSend.append('image', selectedImage);
      } else {
        alert('Please select an image');
        return;
      }

      // Debug logging
      for (let pair of formDataToSend.entries()) {
        console.log('FormData entry:', pair[0], pair[1]);
      }

      const response = await axios.post('http://localhost:4000/api/donations/add', formDataToSend, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });

      if (response.data.success) {
        alert('Donation added successfully!');
        // Reset form
        setFormData({
          foodName: '',
          quantity: '',
          description: '',
          expiryDateTime: '',
          foodType: '',
          location: '',
          organizationName: '',
          latitude: '',
          longitude: ''
        });
        
        setSelectedImage(null);
        setImagePreview(null);
        navigate("/livedonations");
      } else {
        alert(response.data.message || 'Failed to add donation. Please try again.');
      }
    } catch (error) {
      console.error('Error submitting donation:', error);
      if (error.response?.data?.message) {
        alert(`Error: ${error.response.data.message}`);
      } else {
        alert('Failed to add donation. Please try again.');
      }
    }
  };

  return (
    <ProtectedRoute allowedRoles={['Donor']}>
    <div className="donation-form-container">
      <p>
        "Every donation counts – help fight hunger, reduce food waste, and make
        a difference in someone's life today. Your generosity brings hope and
        nourishment to those in need!"
      </p>
      <h2>Add a Donation</h2>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label>Organization Name:</label>
          <input
            type="text"
            name="organizationName"
            value={formData.organizationName}
            onChange={handleInputChange}
            required
            placeholder="Enter your organization name"
          />
        </div>

        <div className="form-group">
          <label>Food Name:</label>
          <input
            type="text"
            name="foodName"
            value={formData.foodName}
            onChange={handleInputChange}
            required
          />
        </div>

        <div className="form-group">
          <label>Food Image:</label>
          <input
            type="file"
            accept="image/*"
            onChange={handleImageChange}
            required
          />
          {imagePreview && (
            <img src={imagePreview} alt="Preview" className="image-preview" />
          )}
        </div>

        <div className="form-group">
          <label>Quantity:</label>
          <input
            type="text"
            name="quantity"
            value={formData.quantity}
            onChange={handleInputChange}
            required
          />
        </div>

        <div className="form-group">
          <label>Description:</label>
          <textarea
            name="description"
            value={formData.description}
            onChange={handleInputChange}
            required
          />
        </div>

        <div className="form-group">
          <label>Expiry Date & Time:</label>
          <input
            type="datetime-local"
            name="expiryDateTime"
            value={formData.expiryDateTime}
            onChange={handleInputChange}
            required
          />
        </div>

        <div className="form-group">
          <label>Food Type:</label>
          <div className="radio-group">
            <label>
              <input
                type="radio"
                name="foodType"
                value="veg"
                checked={formData.foodType === 'veg'}
                onChange={handleInputChange}
                required
              />
              Vegetarian
            </label>
            <label>
              <input
                type="radio"
                name="foodType"
                value="nonveg"
                checked={formData.foodType === 'nonveg'}
                onChange={handleInputChange}
                required
              />
              Non-Vegetarian
            </label>
          </div>
        </div>

        <div className="form-group">
          <label>Location:</label>
          <button
            type="button"
            className="location-btn"
            onClick={getUserLocation}
            disabled={loadingLocation}
          >
            {loadingLocation ? 'Fetching location...' : 'Get My Location'}
          </button>
          {formData.location && <p className="location-text">{formData.location}</p>}
        </div>

        <button type="submit">Submit Donation</button>
      </form>
    </div>
    </ProtectedRoute>
  );
};

export default AddDonation;