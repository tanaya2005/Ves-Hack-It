import React, { useState } from "react";
import "./activedonation.css";

const activeDonations = [
  { id: 1, recipient: "XYZ Hospital", time: "2 hours ago", quantity: "8 boxes", date: "2025-02-09" },
  { id: 2, recipient: "ABC Community", time: "5 hours ago", quantity: "15 meals", date: "2025-02-08" },
  { id: 3, recipient: "DEF Orphanage", time: "1 day ago", quantity: "5 blankets", date: "2025-02-07" },
  { id: 4, recipient: "GHI Shelter", time: "2 days ago", quantity: "20 water bottles", date: "2025-02-06" }
];

function ActiveDonations() {
  const [search, setSearch] = useState("");
  const [sortOrder, setSortOrder] = useState("newest");

  // Filter Donations based on search input
  const filteredDonations = activeDonations.filter(donation =>
    donation.recipient.toLowerCase().includes(search.toLowerCase())
  );

  // Sort Donations by Date
  const sortedDonations = filteredDonations.sort((a, b) =>
    sortOrder === "newest" ? new Date(b.date) - new Date(a.date) : new Date(a.date) - new Date(b.date)
  );

  return (
    <div className="active-donations-container">
      <h2>Active Donations</h2>

      {/* Search Bar */}
      <input
        type="text"
        placeholder="Search by recipient..."
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        className="search-bar"
      />

      {/* Sort Dropdown */}
      <div className="filters">
        <select value={sortOrder} onChange={(e) => setSortOrder(e.target.value)}>
          <option value="newest">Newest First</option>
          <option value="oldest">Oldest First</option>
        </select>
      </div>

      {/* Active Donation List */}
      <div className="donation-list">
        {sortedDonations.length > 0 ? (
          sortedDonations.map((donation) => (
            <div key={donation.id} className="donation-card">
              <h3>Donation to {donation.recipient}</h3>
              <p><strong>Time:</strong> {donation.time}</p>
              <p><strong>Quantity:</strong> {donation.quantity}</p>
              <p><strong>Date:</strong> {new Date(donation.date).toDateString()}</p>
            </div>
          ))
        ) : (
          <p className="no-donations">No active donations found.</p>
        )}
      </div>
    </div>
  );
}

export default ActiveDonations;
