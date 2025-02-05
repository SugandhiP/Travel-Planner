import 'package:flutter/material.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/model/itinerary.dart';
import 'package:travel_planner_project/travel_planner_app.dart'; // Import TravelPlannerApp

class SaveItinerary extends StatefulWidget {
  final TravelDetails travelDetails;
  final Itinerary itinerary;

  SaveItinerary({super.key, required this.travelDetails, required this.itinerary});

  @override
  _SaveItineraryState createState() => _SaveItineraryState();
}

class _SaveItineraryState extends State<SaveItinerary> {
  final TextEditingController itineraryNameController = TextEditingController();

  void _handleSave() {
    String name = itineraryNameController.text.trim();
    if (name.isNotEmpty) {
      // Update the itinerary with the name
      widget.itinerary.name = name;

      // Navigate to TravelPlannerApp and pass the updated itinerary
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TravelPlannerApp(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Save Itinerary"),
      content: TextField(
        controller: itineraryNameController,
        decoration: InputDecoration(labelText: "Itinerary Name"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: Text("OK"),
        ),
      ],
    );
  }
}
