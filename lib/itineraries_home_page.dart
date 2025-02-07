import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/itinerary_travel_details_page.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/travel_details_provider.dart';


class ItinerariesHomePage extends StatefulWidget {
  //TravelDetails td = new TravelDetails(source: "", destination: "", airline: "", flightNumber: "", departureTime: "", arrivalTime: "", hotelName: "", selectedAttractions: List<Attraction>? attractions); : attractions = attractions ?? [];
  const ItinerariesHomePage({super.key});

  @override
  State<ItinerariesHomePage> createState() => _TravelPlannerAState();
}

class _TravelPlannerAState extends State<ItinerariesHomePage> {
  List<TravelDetails> myTravelDetails = [];

  void _deleteItinerary(int index) {
    setState(() {
      myTravelDetails.removeAt(index);
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      myTravelDetails[index].isFavorite = !myTravelDetails[index].isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    myTravelDetails = context.read<TravelDetailsProvider>().travelDetail;
    return Scaffold(
      appBar: AppBar(title: const Text("Itineraries")),
      body: ListView.builder(
        itemCount: myTravelDetails.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(myTravelDetails[index].name),
            subtitle: Text(myTravelDetails[index].destination),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    myTravelDetails[index].isFavorite ? Icons.star : Icons.star_border,
                    color: myTravelDetails[index].isFavorite ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(index),
                ),
                IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteItinerary(index)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              //builder: (context) => ItineraryForm(),
              builder: (context) => ItineraryTravelDetailsPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}