import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/database/database.dart';
import 'package:travel_planner_project/itinerary/itinerary_travel_details_page.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import '../travel_details_provider.dart';
import 'itineraries_data_recorded_page.dart';

class ItinerariesHomePage extends StatefulWidget {
  ItinerariesHomePage({super.key});

  @override
  State<ItinerariesHomePage> createState() => _TravelPlannerAState();
}

class _TravelPlannerAState extends State<ItinerariesHomePage> {
  late AppDatabase database;

  @override
  void initState() {
    super.initState();
    database = Provider.of<AppDatabase>(context, listen: false);
  }

  // Future<void> _deleteItinerary(int id) async {
  //   await database.travelDetailsDao.deleteTravelDetail(id);
  //   setState(() {}); // Refresh UI after deletion
  // }

  // Future<void> _toggleFavorite(TravelDetails travelDetail) async {
  //   final updatedTravelDetail = travelDetail.copyWith(isFavorite: !travelDetail.isFavorite);
  //   await database.travelDetailsDao.updateTravelDetail(updatedTravelDetail);
  //   setState(() {}); // Refresh UI
  // }


  void _editItinerary(TravelDetails travelDetail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ItineraryTravelDetailsPage(travelDetails: travelDetail),
      ),
    );
  }

  void _viewItinerary(TravelDetails travelDetail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ItinerariesDataRecordedPage(
              travelDetails: travelDetail,
              isViewing: true,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Your Itineraries",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Takes the user back to HomePage
          },
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<TravelDetailsProvider>(
        builder: (context, provider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView.builder(
                itemCount: provider.travelDetail.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final travelDetail = provider.travelDetail[index];

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: Icon(Icons.flight_outlined, color: Colors
                          .blueAccent, size: 35),
                      title: Text(
                        travelDetail.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        travelDetail.destination,
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 16),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              travelDetail.isFavorite ? Icons.star : Icons
                                  .star_border,
                              color: travelDetail.isFavorite
                                  ? Colors.amber
                                  : Colors.grey,
                            ),
                            onPressed: () async {
                              travelDetail.isFavorite = !travelDetail.isFavorite;
                              await provider.updateTravelDetails(index, travelDetail);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () => _editItinerary(travelDetail),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_red_eye, color: Colors.green),
                            onPressed: () => _viewItinerary(travelDetail),
                          ),
                          IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => provider.deleteTravelDetails(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          );
            },
      ),
    );
  }
}



  /*@override
  Widget build(BuildContext context) {
    final provider = Provider.of<TravelDetailsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Your Itineraries",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Takes the user back to HomePage
          },
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: provider.fetchTravelDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.travelDetail.isEmpty) {
            return Center(child: Text("No itineraries available"));
          }*/

        // future: database.travelDetailsDao.getAllTravelDetails(),
        // builder: (context, snapshot) {
        //   if (snapshot.connectionState == ConnectionState.waiting) {
        //     return Center(child: CircularProgressIndicator());
        //   }
        //   if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //     return Center(child: Text("No itineraries available"));
        //   }
        //
        //   List<TravelDetails> myTravelDetails = snapshot.data!;

          // Sort itineraries: Favorites first, then by departure time
          // myTravelDetails.sort((a, b) {
          //   if (a.isFavorite && !b.isFavorite) return -1;
          //   if (!a.isFavorite && b.isFavorite) return 1;
          //   return a.departureTime.compareTo(b.departureTime);
          // });

          /*return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView.builder(
              itemCount: provider.travelDetail.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final travelDetail = provider.travelDetail[index];

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: Icon(Icons.flight_outlined, color: Colors.blueAccent, size: 35),
                    title: Text(
                      travelDetail.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      travelDetail.destination,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            travelDetail.isFavorite ? Icons.star : Icons.star_border,
                            color: travelDetail.isFavorite ? Colors.amber : Colors.grey,
                          ),
                          onPressed: () => provider.toggleFavorite(travelDetail),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => _editItinerary(travelDetail),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_red_eye, color: Colors.green),
                          onPressed: () => _viewItinerary(travelDetail),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => (){}//_deleteItinerary(travelDetail.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ItineraryTravelDetailsPage()),
          );
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "New Itinerary",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}*/