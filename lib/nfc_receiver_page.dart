// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
// import 'package:provider/provider.dart';
// import 'package:travel_planner_project/database/database.dart';
// import 'package:travel_planner_project/model/travel_details.dart';
// import 'package:travel_planner_project/nfc_data_display_page.dart'; // Import the new page
// import 'package:flutter/foundation.dart';
//
// class NFCReceiverPage extends StatefulWidget {
//   @override
//   _NFCReceiverPageState createState() => _NFCReceiverPageState();
// }
//
// class _NFCReceiverPageState extends State<NFCReceiverPage> {
//   String _nfcData = 'No NFC data yet.';
//   late AppDatabase database;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the database here
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     database = Provider.of<AppDatabase>(context, listen: false);
//   }
//
//   Future<void> _readNFCAndSave() async {
//     if (kIsWeb) {
//       print('NFC is not supported on web.');
//       return;
//     }
//
//     try {
//       // Check NFC availability
//       NFCAvailability availability = await FlutterNfcKit.nfcAvailability;
//       if (availability != NFCAvailability.available) {
//         print('NFC is not available on this device.');
//         return;
//       }
//
//       // Read NFC tag
//       NFCTag tag = await FlutterNfcKit.readNDEF(throwOnUserCancel: false);
//
//       if (tag.ndefMessage != null && tag.ndefMessage!.isNotEmpty) {
//         // Extract JSON data from the first NDEF record
//         NDEFRecord record = tag.ndefMessage!.first;
//         String jsonData = record.payload.toString();
//
//         // Decode JSON data to TravelDetails object
//         TravelDetails travelDetails = TravelDetails.fromJson(jsonDecode(jsonData));
//
//         // Save TravelDetails object to Floor database
//         await database.travelDetailsDao.insertTravelDetail(travelDetails);
//
//         // Navigate to NFCDataDisplayPage
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => NFCDataDisplayPage(travelDetails: travelDetails),
//           ),
//         );
//       } else {
//         print('No NDEF records found on the NFC tag.');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No data found on NFC tag')),
//         );
//       }
//     } catch (e) {
//       print('Error reading from NFC: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error reading from NFC: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('NFC Receiver'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               '$_nfcData',
//               style: TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _readNFCAndSave,
//               child: Text('Read NFC Tag'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
