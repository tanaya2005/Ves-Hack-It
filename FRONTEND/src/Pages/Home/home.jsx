import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import './home.css';
import { assets } from '../../assets/assets';
import { FaFacebookF, FaTwitter, FaInstagram, FaLinkedinIn } from "react-icons/fa";
import { FaHandsHelping, FaRecycle, FaUsers, FaChartLine } from "react-icons/fa";

const Home = () => {
  // Impact Counter State
  const [impactCount, setImpactCount] = useState(10000);

  useEffect(() => {
    const interval = setInterval(() => {
      setImpactCount(prevCount => prevCount + Math.floor(Math.random() * 5)); // Simulate counter increasing
    }, 3000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="home">
      {/* Hero Section */}
      <div className="hero-section">
        <div className="hero-overlay">
          <h1>Help Feed People with Your Excess Food</h1>
          <p>
            Are you a restaurant, grocery store, farm, cafeteria, or caterer interested in signing up for the Waste No Food program?
            Donating excess food to legitimate charities is a quick, efficient, and tax-deductible way to make an impact on your community.
          </p>
        </div>
      </div>

      {/* Donation Feature Cards */}
      <div className="homecards">
        <ul>
          <li>
            <Link to="/adddonation" className="card-link">
              <img src={assets.fooddonation} alt="Donate" />
              <span>DONATE</span>
            </Link>
          </li>
          <li>
            <Link to="/livedonations" className="card-link">
              <img src={assets.livedonations} alt="Live Donations" />
              <span>VIEW LIVE DONATIONS</span>
            </Link>
          </li>
          <li>
            <Link to="/volunteer" className="card-link">
              <img src={assets.volunteer} alt="Volunteer" />
              <span>VOLUNTEER</span>
            </Link>
          </li>
          <li>
            <Link to="/charity" className="card-link">
              <img src={assets.charity} alt="Charity" />
              <span>CHARITY</span>
            </Link>
          </li>
        </ul>
      </div>

      {/* Login & Signup Section
      <div className="auth-section">
        <Link to="/login" className="auth-button login">Login</Link>
        <Link to="/signup" className="auth-button signup">Sign Up</Link>
      </div> */}

      {/* Leaderboard Section */}
      <div className="leaderboard-section">
        <div className="leaderboard-quote">
          <h2>🏆 Do you have what it takes to be a hero?</h2>
          <p>
            The <strong>top donors and volunteers</strong> are changing lives—<br />
            <strong>one meal, one act of kindness at a time.</strong><br />
            Make your mark on the leaderboard and be a force for good!
          </p>
        </div>

        <div className="leaderboard-preview">
          <h2>🏆 Top Contributors</h2>
          <div className="leaderboard-cards">
            <div className="leaderboard-card">
              <img src={assets.topdonor} alt="Top Donor" />
              <p>🥇 John Doe - 50 Donations</p>
            </div>
            <div className="leaderboard-card">
              <img src={assets.topvolunteer} alt="Top Volunteer" />
              <p>🥇 Sarah Smith - 120 Hours</p>
            </div>
          </div>
          <br />
          <Link to="/leaderboard" className="view-leaderboard">View Full Leaderboard</Link>
        </div>
      </div>

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

      <div className="about-us-section">
        {/* Hero Section */}
        <div className="hero-section">
          <h1>🌍 Zero Food Waste, Zero Hunger</h1>
          <p>
            At <strong>KindMeals</strong>, we believe no food should be wasted while people go hungry.
            Our platform bridges the gap between **surplus food** and **those in need**.
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
    </div>
  );
}

export default Home;
