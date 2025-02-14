import React from "react";
import "./previouscontribution.css"; // Make sure you have this CSS file
// import sampleImage from "../assets/food1.jpeg"; // Replace with actual image path

const previousContribution = [
  {
    id: 1,
    title: "Food Donation",
    location: "Mumbai, India",
    date: "Jan 25, 2025",
    feedback: "Your donation helped 20 people!",
    // image: sampleImage, // Replace with actual image URL
  },
  {
    id: 2,
    title: "Clothes Donation",
    location: "Delhi, India",
    date: "Feb 10, 2025",
    feedback: "Families in need benefited from your donation!",
    // image: sampleImage, // Replace with actual image URL
  },
];

const PreviousContributions = () => {
  return (
    <div className="previous-contributions">
      <h2>Previous Contributions</h2>
      <p>Here are the donations you have made in the past.</p>

      <div className="contributions-container">
        {previousContributions.length > 0 ? (
          previousContributions.map((contribution) => (
            <div key={contribution.id} className="contribution-card">
              <img
                src={contribution.image}
                alt={contribution.title}
                className="contribution-image"
              />
              <div className="contribution-details">
                <h3>{contribution.title}</h3>
                <p><strong>Location:</strong> {contribution.location}</p>
                <p><strong>Date:</strong> {contribution.date}</p>
                <p className="feedback">"{contribution.feedback}"</p>
              </div>
              <div className="contribution-actions">
                <button className="details-btn">View Details</button>
                <button className="feedback-btn">Give Feedback</button>
              </div>
            </div>
          ))
        ) : (
          <p className="no-contributions">No past contributions found.</p>
        )}
      </div>
    </div>
  );
};

export default PreviousContributions;
