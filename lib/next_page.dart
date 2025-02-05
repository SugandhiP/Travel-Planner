import 'package:flutter/material.dart';
import 'package:travel_planner_project/travel_planner_app.dart';
import '../model/travel_details.dart';

class NextPage extends StatelessWidget {
  final TravelDetails travelDetails;

  const NextPage({super.key, required this.travelDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Review Travel Itinerary Plan")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            reviewTravelTitle("FLIGHT DETAILS"),
            reviewTravelDetails("Source", travelDetails.source),
            reviewTravelDetails("Destination", travelDetails.destination),
            reviewTravelDetails("Airline Name", travelDetails.airline),
            reviewTravelDetails("Flight Number", travelDetails.flightNumber),
            reviewTravelDetails("Departure Time", travelDetails.departureTime),
            reviewTravelDetails("Arrival Time", travelDetails.arrivalTime),
            SizedBox(height: 16),

            reviewTravelTitle("HOTEL DETAILS"),
            reviewTravelDetails("Hotel Name", travelDetails.hotelName),
            SizedBox(height: 16),

            reviewTravelTitle("ATTRACTIONS DETAILS"),
            if (travelDetails.selectedAttractions.isNotEmpty)
              ...travelDetails.selectedAttractions.map((attraction) => reviewTravelDetails('•', attraction)).toList()
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Attractions is not selected.", style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TravelPlannerApp()),
            );
          },
          child: Text(
            "Save your Itinerary",
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget reviewTravelTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }

  Widget reviewTravelDetails(String label, String value) {
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
