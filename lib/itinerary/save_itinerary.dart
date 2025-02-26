import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/database/travel_details_dao.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/travel_details_provider.dart';

import '../database/database.dart';
import 'itineraries_home_page.dart';

class SaveItinerary extends StatefulWidget {
  final TravelDetails travelDetails;

  const SaveItinerary({super.key, required this.travelDetails});

  @override
  _SaveItineraryState createState() => _SaveItineraryState();
}

class _SaveItineraryState extends State<SaveItinerary> {
  late TravelDetailsDao _travelDetailsDao;
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
          onPressed: () async {
            widget.travelDetails.name = itineraryNameController.text;

            // Initialize the Floor database
            //final database = await $FloorAppDatabase.databaseBuilder('myuse.db').build();
            final database = Provider.of<AppDatabase>(context, listen: false);

            // Save the TravelDetails to the database
            await database.travelDetailsDao.insertTravelDetail(widget.travelDetails);
                //.travelDetailsDao.insertTravelDetails(widget.travelDetails);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ItinerariesHomePage(),
              ),
            );
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}