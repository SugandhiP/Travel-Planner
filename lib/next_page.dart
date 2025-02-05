import 'package:flutter/material.dart';
import '../model/travel_details.dart';

class NextPage extends StatelessWidget {
  final TravelDetails travelDetails;

  const NextPage({super.key, required this.travelDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Review Travel Plan")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSectionTitle("Flight Details"),
            buildDetailRow("Source", travelDetails.source),
            buildDetailRow("Destination", travelDetails.destination),
            buildDetailRow("Airline", travelDetails.airline),
            buildDetailRow("Flight Number", travelDetails.flightNumber),
            buildDetailRow("Departure Time", travelDetails.departureTime),
            buildDetailRow("Arrival Time", travelDetails.arrivalTime),
            SizedBox(height: 16),

            buildSectionTitle("Hotel"),
            buildDetailRow("Hotel Name", travelDetails.hotelName),
            SizedBox(height: 16),

            buildSectionTitle("Attractions"),
            if (travelDetails.selectedAttractions.isNotEmpty)
              ...travelDetails.selectedAttractions.map((attraction) => buildDetailRow('', attraction)).toList()
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("No attractions selected", style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
