// src/components/Leaderboard.jsx
import React from 'react';
import leaderboard from '../../assets/leaderboard';
import "./volunteerleaderboard.css";

const getRankBadge = (rank) => {
    if (rank === 1) return <span className="rank-badge rank-1">🥇 1st</span>;
    if (rank === 2) return <span className="rank-badge rank-2">🥈 2nd</span>;
    if (rank === 3) return <span className="rank-badge rank-3">🥉 3rd</span>;
    return rank;
  };

const VolunteerLeaderboard = () => {
    return (
        <div className="leaderboard-container">
          <h2>🏆 Volunteer Leaderboard 🏆</h2>
          <table>
            <thead>
              <tr>
                <th>Rank</th>
                <th>Name</th>
                <th>Hours Served</th>
              </tr>
            </thead>
            <tbody>
              {leaderboard
                .sort((a, b) => b.hoursServed - a.hoursServed) // Sort in descending order
                .map((volunteer, index) => (
                  <tr key={index}>
                    <td>{getRankBadge(index + 1)}</td>
                    <td>{volunteer.name}</td>
                    <td>{volunteer.hoursServed}</td>
                  </tr>
                ))}
            </tbody>
          </table>
        </div>
      );
    };

export default VolunteerLeaderboard;
