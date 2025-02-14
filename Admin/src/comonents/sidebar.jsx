import React from "react";
import { Link } from "react-router-dom";
import "./sidebar.css";
import { FaTachometerAlt, FaUsers, FaHandHoldingHeart, FaBox, FaHandsHelping } from "react-icons/fa";

const Sidebar = ({ isOpen }) => {
    return (
        <div className={`sidebar ${isOpen ? "open" : "closed"}`}>
            <h2 className="sidebar-title">Admin Panel</h2>
            <ul className="sidebar-menu">
                <li className="sidebar-item active">
                    {/* <Link to="/dashboard" className="sidebar-link">
                        <FaTachometerAlt className="sidebar-icon" />
                        <span>Dashboard</span> */}
                    {/* </Link> */}
                </li>
                <li className="sidebar-item">
                    <Link to="/users" className="sidebar-link">
                        <FaUsers className="sidebar-icon" />
                        <span>Users</span>
                    </Link>
                </li>
                <li className="sidebar-item">
                    <Link to="/donors" className="sidebar-link">
                        <FaHandHoldingHeart className="sidebar-icon" />
                        <span>Donors</span>
                    </Link>
                </li>
                <li className="sidebar-item">
                    <Link to="/receivers" className="sidebar-link">
                        <FaBox className="sidebar-icon" />
                        <span>Receivers</span>
                    </Link>
                </li>
                <li className="sidebar-item">
                    <Link to="/volunteers" className="sidebar-link">
                        <FaHandsHelping className="sidebar-icon" />
                        <span>Volunteers</span>
                    </Link>
                </li>
            </ul>
        </div>
    );
};

export default Sidebar;
