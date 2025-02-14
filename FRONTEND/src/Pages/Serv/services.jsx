import React from "react";
import { Link } from "react-router-dom"; // Ensure this is imported for navigation
import { FaHandsHelping, FaRecycle, FaUsers, FaChartLine } from "react-icons/fa"; // Importing required icons
import "./services.css";

const Services = () => {
  return (
    <div>
      {/* About Us Section */}
      <div className="about-us-section">
        {/* Hero Section */}
        <div className="hero-section">
          <h1>🌍 Zero Food Waste, Zero Hunger</h1>
          <p>
            At <strong>KindMeals</strong>, we believe no food should be wasted while people go hungry.
            Our platform bridges the gap between <strong>surplus food</strong> and <strong>those in need</strong>.
          </p>
        </div>

        {/* Services Section */}
        <div className="homecards">
          <ul>
            <li>
              <a className="card-link" href="#">
                <FaHandsHelping size={50} color="#2e7d32" />
                <span>Food Donation</span>
              </a>
            </li>
            <li>
              <a className="card-link" href="#">
                <FaRecycle size={50} color="#2e7d32" />
                <span>Live Tracking</span>
              </a>
            </li>
            <li>
              <a className="card-link" href="#">
                <FaUsers size={50} color="#2e7d32" />
                <span>Volunteer Network</span>
              </a>
            </li>
            <li>
              <a className="card-link" href="#">
                <FaChartLine size={50} color="#2e7d32" />
                <span>Impact Counter</span>
              </a>
            </li>
          </ul>
        </div>

        {/* Impact Counter Section */}
        <div className="impact-counter">
          <h2>🌟 Our Impact So Far</h2>
          <div className="impact-stats">
            <div className="impact-box">
              <h3>📌 12,500+</h3>
              <p>Meals Donated</p>
            </div>
            <div className="impact-box">
              <h3>📌 50+</h3>
              <p>Charities & NGOs Partnered</p>
            </div>
            <div className="impact-box">
              <h3>📌 1,000+</h3>
              <p>Volunteers Engaged</p>
            </div>
            <div className="impact-box">
              <h3>📌 20,000+ kg</h3>
              <p>Food Rescued</p>
            </div>
          </div>
        </div>

        {/* Call-To-Action Section */}
        <div className="cta-section">
          <h2>💙 Be a Part of the Change!</h2>
          <p>Whether you’re a donor, volunteer, or charity—join us in the fight against food waste!</p>
          <br />
          <Link to="/signup" className="auth-button signup">Get Involved</Link>
        </div>
      </div>

      {/* Reviews Section */}
      <div className="reviews-section">
        <h2>💬 What People Say</h2>
        <div className="review-cards">
          <div className="review-card">
            <p>"This platform has made donating food so easy and impactful!"</p>
            <span>- Emily R.</span>
          </div>
          <div className="review-card">
            <p>"A great initiative that helps reduce waste and fight hunger!"</p>
            <span>- James D.</span>
          </div>
          <div className="review-card">
            <p>"I love volunteering here, it's fulfilling and makes a difference."</p>
            <span>- Sophia M.</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Services;
