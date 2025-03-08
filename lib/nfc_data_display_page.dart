// import 'package:flutter/material.dart';
// import 'package:travel_planner_project/model/travel_details.dart';
//
// class NFCDataDisplayPage extends StatelessWidget {
//   final TravelDetails travelDetails;
//
//   NFCDataDisplayPage({required this.travelDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('NFC Data'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Name: ${travelDetails.name}', style: TextStyle(fontSize: 18)),
//             Text('Destination: ${travelDetails.destination}', style: TextStyle(fontSize: 18)),
//             Text('Departure Time: ${travelDetails.departureTime}', style: TextStyle(fontSize: 18)),
//             Text('Arrival Time: ${travelDetails.arrivalTime}', style: TextStyle(fontSize: 18)),
//             Text('Hotel: ${travelDetails.hotelName}', style: TextStyle(fontSize: 18)),
//             Text('Activities: ${travelDetails.flightNumber}', style: TextStyle(fontSize: 18)),
//             Text('Is Favorite: ${travelDetails.isFavorite}', style: TextStyle(fontSize: 18)),
//             // Add more Text widgets to display other properties
//           ],
//         ),
//       ),
//     );
//   }
// }
