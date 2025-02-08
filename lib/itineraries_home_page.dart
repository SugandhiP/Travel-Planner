import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/itinerary_travel_details_page.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/travel_details_provider.dart';
import 'itineraries_data_recorded_page.dart';

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

  void _editItinerary(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ItineraryTravelDetailsPage(travelDetails: myTravelDetails[index]),
      ),
    );
  }

  void _viewItinerary(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItinerariesDataRecordedPage(
          travelDetails: myTravelDetails[index],
          isViewing: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    myTravelDetails.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) {
        return -1;
      } else if (!a.isFavorite && b.isFavorite) {
        return 1;
      } else {
        return a.departureTime.compareTo(b.departureTime);
      }
    });

    myTravelDetails = context.read<TravelDetailsProvider>().travelDetail;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, color: Colors.white),
            SizedBox(width: 8),
            Text("Your Itineraries",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: myTravelDetails.length,
          padding: EdgeInsets.all(12),
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: Icon(Icons.flight, color: Colors.blueAccent, size: 35),
                title: Text(
                  myTravelDetails[index].name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  myTravelDetails[index].destination,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        myTravelDetails[index].isFavorite
                            ? Icons.star
                            : Icons.star_border,
                        color: myTravelDetails[index].isFavorite
                            ? Colors.amber
                            : Colors.grey,
                      ),
                      onPressed: () => _toggleFavorite(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => _editItinerary(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_red_eye, color: Colors.green),
                      onPressed: () => _viewItinerary(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItinerary(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItineraryTravelDetailsPage()),
            );
          },
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: Text(
            "New Itinerary",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent),
    );
  }
}
