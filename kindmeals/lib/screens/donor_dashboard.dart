// import 'package:flutter/material.dart';

// class DonorDashboard extends StatelessWidget {
//   const DonorDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Donor Dashboard')),
//       body: Column(
//         children: [
//           Text('Nearby Registered NGOs (Within 5 km)',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           Expanded(
//             child: ListView.builder(
//               itemCount: 5, // Replace with actual data
//               itemBuilder: (context, index) {
//                 return Card(
//                   elevation: 3,
//                   child: ListTile(
//                     title: Text('NGO #${index + 1}'),
//                     subtitle: Text('Location: City ${index + 1}'),
//                     trailing: Icon(Icons.location_on, color: Colors.green),
//                     onTap: () {
//                       // Navigate to NGO details
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
