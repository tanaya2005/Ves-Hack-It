import React from 'react'
import './footer.css'
import { FaFacebookF, FaTwitter, FaInstagram, FaLinkedinIn } from "react-icons/fa";

const footer = () => {
  return (
    <div className="social-media-section">
      <h2>📢 Stay Connected With Us</h2>
      <p>Follow us on social media and be part of the movement!</p>
      <div className="social-icons">
        <a href="#" className="social-icon facebook"><FaFacebookF /></a>
        <a href="#" className="social-icon twitter"><FaTwitter /></a>
        <a href="#" className="social-icon instagram"><FaInstagram /></a>
        <a href="#" className="social-icon linkedin"><FaLinkedinIn /></a>
      </div>
    </div>
  )
}

export default footer