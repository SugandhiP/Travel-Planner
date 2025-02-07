import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/model/itinerary.dart';
import 'package:travel_planner_project/travel_details_provider.dart';

import 'itineraries_home_page.dart';
import 'model/attraction.dart';

class SaveItinerary extends StatefulWidget {
  final TravelDetails travelDetails;

  const SaveItinerary({super.key, required this.travelDetails});

  @override
  _SaveItineraryState createState() => _SaveItineraryState();
}

class _SaveItineraryState extends State<SaveItinerary> {
  final TextEditingController itineraryNameController = TextEditingController();

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
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.travelDetails.name = itineraryNameController.text;
            context.read<TravelDetailsProvider>().addTravelDetails(widget.travelDetails);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ItinerariesHomePage(),
              ),
              );
            }, child: Text("OK"),
          )
          ]
        );
  }
}


/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/model/itinerary.dart';
import 'package:travel_planner_project/itineraries_home_page.dart';
import 'package:travel_planner_project/travel_details_provider.dart';



class SaveItinerary extends StatefulWidget {
  TravelDetails td;
  SaveItinerary({super.key, required this.td});

  @override
  _SaveItineraryState createState() => _SaveItineraryState();
}

class _SaveItineraryState extends State<SaveItinerary> {
  final TextEditingController itineraryNameController = TextEditingController();

  void _handleSave(TravelDetails travelDetail) {
    String name = itineraryNameController.text.trim();
    if (name.isNotEmpty) {
      // Update the itinerary with the name
      travelDetail.name = name;
      // Navigate to TravelPlannerApp and pass the updated itinerary
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ItinerariesHomePage(),
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
          onPressed: () => _handleSave(td as TravelDetails),
          child: Text("OK"),
        ),
      ],
    );
  }
}*/
