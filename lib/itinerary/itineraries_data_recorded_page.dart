import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/itinerary/save_itinerary.dart';
import 'package:travel_planner_project/travel_details_provider.dart';
import '../../model/travel_details.dart';
import 'itineraries_home_page.dart';
import 'package:travel_planner_project/expense_tracker/expense_tracker_page.dart'; // Import the ExpenseTrackerPage

class ItinerariesDataRecordedPage extends StatelessWidget {
  final TravelDetails travelDetails;
  final bool? isViewing;
  final bool? isEditing;

  const ItinerariesDataRecordedPage({Key? key, required this.travelDetails, this.isViewing, this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Review Travel Itinerary Plan", style: TextStyle(fontWeight: FontWeight.bold),),
          backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            reviewTravelTitle("FLIGHT DETAILS"),
            reviewTravelDetails("Source", travelDetails.source),
            reviewTravelDetails("Destination", travelDetails.destination),
            reviewTravelDetails("Airline Name", travelDetails.airline),
            reviewTravelDetails("Flight Number", travelDetails.airline),
            reviewTravelDetails("Departure Time", travelDetails.departureTime),
            reviewTravelDetails("Arrival Time", travelDetails.arrivalTime),
            reviewTravelDetails(
              "Initial Budget(USD)", travelDetails.initialBudget != 0.0 ? travelDetails.initialBudget.toString() : "0.0",),

            // reviewTravelDetails("Trip Members", travelDetails.tripMember),
            reviewTravelDetails("Trip Members", travelDetails.tripMember != 0 ? travelDetails.tripMember.toString() : "Not Specified"),

            SizedBox(height: 16),

            reviewTravelTitle("HOTEL DETAILS"),
            reviewTravelDetails("Hotel Name", travelDetails.hotelName ?? "Not provided"),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Choose an appropriate color
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Access the TravelDetailsProvider and set the new travelDetailsId
                Provider.of<TravelDetailsProvider>(context, listen: false)
                    .setTravelDetailsId(travelDetails.name);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpenseTrackerPage(travelDetails: travelDetails),
                  ),
                );
              },
              child: Text(
                "Go to Expense Tracker",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 8),
            isViewing == true
                ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Navigate back to the Itinerary Home Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ItinerariesHomePage()),
                );
              },
              child: Text(
                "Back to Home Page",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
                : isEditing == true
                ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                //Save changes while editing
                int index = 0;
                List<TravelDetails> dummy = context.read<TravelDetailsProvider>().travelDetail;
                for (TravelDetails td in dummy) {
                  if (td.name == travelDetails.name) {
                    context.read<TravelDetailsProvider>().deleteTravelDetails(index);
                    context.read<TravelDetailsProvider>().addTravelDetails(travelDetails);
                    break;
                  }
                  ++index;
                }
                // Navigator.pushReplacement(context, MaterialPageRoute(builder:
                // (context) => ItinerariesDataRecordedPage(travelDetails: travelDetail,)),);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItinerariesHomePage()),
                );
              },
              child: Text(
                "Save Changes",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Navigate to Save Itinerary page when the form is not in view mode
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SaveItinerary(travelDetails: travelDetails)),
                );
              },
              child: Text(
                "Save your Itinerary",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
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
