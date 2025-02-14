import React, { useState } from "react";
// import Sidebar from './comonents/sidebar';
import {Link} from 'react-router-dom';
import "./dashboard.css";
import { FaUser, FaHandHoldingHeart, FaUsers, FaBox, FaChartLine, FaMapMarkerAlt } from "react-icons/fa";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, PieChart, Pie, Cell, BarChart, Bar } from "recharts";

const Dashboard = () => {
    const [isOpen, setIsOpen] = useState(true); // State to control sidebar visibility

    // Dummy Data
    const userGrowthData = [
        { month: "Jan", users: 100, donors: 80, receivers: 60 },
        { month: "Feb", users: 200, donors: 160, receivers: 120 },
        { month: "Mar", users: 300, donors: 220, receivers: 180 },
        { month: "Apr", users: 500, donors: 400, receivers: 350 },
        { month: "May", users: 750, donors: 600, receivers: 500 },
        { month: "Jun", users: 1000, donors: 850, receivers: 700 },
    ];

    const donationsData = [
        { name: "Food", value: 500 },
        { name: "Clothes", value: 300 },
        { name: "Money", value: 200 },
    ];

    const monthlyDonations = [
        { month: "Jan", donations: 20 },
        { month: "Feb", donations: 40 },
        { month: "Mar", donations: 60 },
        { month: "Apr", donations: 80 },
        { month: "May", donations: 100 },
        { month: "Jun", donations: 150 },
    ];

    const COLORS = ["#0088FE", "#00C49F", "#FFBB28"];

    const topDonors = [
        { name: "John Doe", amount: "$500" },
        { name: "Jane Smith", amount: "$400" },
        { name: "Alex Johnson", amount: "$350" },
    ];

    return (
        <div className="dashboard-container">
            <Sidebar isOpen={isOpen} /> {/* Sidebar Component */}
            <div className="dashboard">
                <h2 className="dashboard-title">📊 Admin Dashboard</h2>

                {/* Stats Cards */}
                <div className="stats-container">
                    <div className="stats-card">
                        <FaUser className="stats-icon" />
                        <h3>Donors</h3>
                        <p>850+</p>
                    </div>
                    <div className="stats-card">
                        <FaHandHoldingHeart className="stats-icon" />
                        <h3>Receivers</h3>
                        <p>700+</p>
                    </div>
                    <div className="stats-card">
                        <FaUsers className="stats-icon" />
                        <h3>Volunteers</h3>
                        <p>250+</p>
                    </div>
                    <div className="stats-card">
                        <FaBox className="stats-icon" />
                        <h3>Donations</h3>
                        <p>1500+</p>
                    </div>
                </div>

                {/* Charts Section */}
                <div className="charts-container">
                    {/* Users Growth Line Chart */}
                    <div className="chart">
                        <h3>📈 Users & Donations Growth</h3>
                        <ResponsiveContainer width="100%" height={300}>
                            <LineChart data={userGrowthData}>
                                <CartesianGrid strokeDasharray="3 3" />
                                <XAxis dataKey="month" />
                                <YAxis />
                                <Tooltip />
                                <Line type="monotone" dataKey="users" stroke="#0088FE" strokeWidth={3} />
                                <Line type="monotone" dataKey="donors" stroke="#00C49F" strokeWidth={3} />
                                <Line type="monotone" dataKey="receivers" stroke="#FFBB28" strokeWidth={3} />
                            </LineChart>
                        </ResponsiveContainer>
                    </div>

                    {/* Donations Pie Chart */}
                    <div className="chart">
                        <h3>🥧 Donations Breakdown</h3>
                        <ResponsiveContainer width="100%" height={300}>
                            <PieChart>
                                <Pie data={donationsData} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={80} fill="#8884d8">
                                    {donationsData.map((entry, index) => (
                                        <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                                    ))}
                                </Pie>
                                <Tooltip />
                            </PieChart>
                        </ResponsiveContainer>
                    </div>
                </div>

                {/* Monthly Donations Bar Chart */}
                <div className="chart full-width">
                    <h3>📊 Monthly Donations</h3>
                    <ResponsiveContainer width="100%" height={300}>
                        <BarChart data={monthlyDonations}>
                            <CartesianGrid strokeDasharray="3 3" />
                            <XAxis dataKey="month" />
                            <YAxis />
                            <Tooltip />
                            <Bar dataKey="donations" fill="#00C49F" />
                        </BarChart>
                    </ResponsiveContainer>
                </div>

                {/* Top Donors Table */}
                <div className="top-donations">
                    <h3>🏆 Top Donors</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Donation Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            {topDonors.map((donor, index) => (
                                <tr key={index}>
                                    <td>{donor.name}</td>
                                    <td>{donor.amount}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
};

export default Dashboard;
