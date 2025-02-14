import React, { useState } from 'react';
import Navbar from './comonents/navbar/navbar';
import Sidebar from './comonents/sidebar';
// import Dashboard from './pages/dashboard/dashboard';
import './App.css';

const App = () => {
    const [isSidebarOpen, setIsSidebarOpen] = useState(true);

    const toggleSidebar = () => {
        setIsSidebarOpen(!isSidebarOpen);
    };

    return (
        <div className="app-container">
            <Navbar toggleSidebar={toggleSidebar} />
            <Sidebar isOpen={isSidebarOpen} />
            <div className={`app-content ${isSidebarOpen ? "shifted" : ""}`}>
                {/* Your main content here */}
                {/* <h1>Welcome to the Admin Panel</h1> */}
            </div>

            {/* <Routes>
                <Route path="/dashboard" element={<dashboard />} />
            </Routes> */}
        </div>
    );
};

export default App;
