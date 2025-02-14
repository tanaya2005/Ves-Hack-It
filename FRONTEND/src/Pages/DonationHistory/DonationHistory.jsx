import React, { useState } from "react";
import "./DonationHistory.css";

const donations = [
  { id: 1, recipient: "XYZ Hospital", accepted: true, time: "1 day ago", quantity: "5 boxes", date: "2025-02-05" },
  { id: 2, recipient: "ABC Community", accepted: false, time: "3 days ago", quantity: "10 meals", date: "2025-02-03" },
  { id: 3, recipient: "DEF Orphanage", accepted: true, time: "1 week ago", quantity: "2 boxes", date: "2025-01-30" },
  { id: 4, recipient: "GHI Shelter", accepted: false, time: "2 weeks ago", quantity: "3 blankets", date: "2025-01-24" }
];

function DonationHistory() {
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("All");
  const [sortOrder, setSortOrder] = useState("newest");

  // Convert boolean to "Accepted" or "Expired"
  const getStatus = (accepted) => (accepted ? "Accepted" : "Expired");

  // Filter Donations by Status
  const filteredDonations = donations.filter(donation =>
    (statusFilter === "All" || getStatus(donation.accepted) === statusFilter) &&
    donation.recipient.toLowerCase().includes(search.toLowerCase())
  );

  // Sort Donations by Date
  const sortedDonations = filteredDonations.sort((a, b) =>
    sortOrder === "newest" ? new Date(b.date) - new Date(a.date) : new Date(a.date) - new Date(b.date)
  );

  return (
    <div className="donation-history-container">
      <h2>Donation History</h2>

      {/* Search Bar */}
      <input
        type="text"
        placeholder="Search by recipient..."
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        className="search-bar"
      />

      {/* Filters */}
      <div className="filters">
        <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)}>
          <option value="All">All</option>
          <option value="Accepted">Accepted</option>
          <option value="Expired">Expired</option>
        </select>

        <select value={sortOrder} onChange={(e) => setSortOrder(e.target.value)}>
          <option value="newest">Newest First</option>
          <option value="oldest">Oldest First</option>
        </select>
      </div>

      {/* Donation List */}
      <div className="donation-list">
        {sortedDonations.length > 0 ? (
          sortedDonations.map((donation) => (
            <div key={donation.id} className="donation-card">
              <h3>Donation to {donation.recipient}</h3>
              <p><strong>Status:</strong> <span className={donation.accepted ? "status-accepted" : "status-expired"}>{getStatus(donation.accepted)}</span></p>
              <p><strong>Time:</strong> {donation.time}</p>
              <p><strong>Quantity:</strong> {donation.quantity}</p>
              <p><strong>Date:</strong> {new Date(donation.date).toDateString()}</p>
            </div>
          ))
        ) : (
          <p className="no-donations">No donations found.</p>
        )}
      </div>
    </div>
  );
}

export default DonationHistory;