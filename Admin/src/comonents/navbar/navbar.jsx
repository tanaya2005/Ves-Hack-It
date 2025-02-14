import React from "react";
import "./navbar.css";
import { FaBars, FaBell, FaGripHorizontal } from "react-icons/fa";
import { assets } from "../../assets/assets";

const Navbar = ({ toggleSidebar }) => {
    return (
        <div className="navbar">
            {/* Left Side: Logo + Sidebar Toggle */}
            <div className="navbar-left">
                <img src={assets.foododonar} alt="logo" className="navbar-logo" />
                <button className="menu-btn" onClick={toggleSidebar}>
                    <FaBars size={24} />
                </button>
                <h2 className="logo-text">KINDMEALS</h2>
            </div>

            {/* Right Side: Notification, Quick Access, Profile */}
            <div className="navbar-right">
                <FaBell className="icon notification-icon" size={22} />

                <div className="quick-access">
                    <button className="quick-access-btn">
                        <FaGripHorizontal size={18} className="quick-access-icon" />
                        Quick Access
                    </button>
                </div>

                <div className="profile">
                    <img src={assets.profileImg} alt="Profile" className="profile-img" />
                </div>
            </div>
        </div>
    );
};

export default Navbar;
