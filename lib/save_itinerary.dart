import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/travel_details_provider.dart';

import 'itineraries_home_page.dart';

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