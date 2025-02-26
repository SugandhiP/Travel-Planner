import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../travel_details_provider.dart';
import 'attraction_page.dart';
import 'itineraries_home_page.dart';
import 'itinerary_travel_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TravelDetailsProvider>(context, listen: false).initializeDatabase()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Travel Planner")),
      body: Consumer<TravelDetailsProvider>(
        builder: (context, destinationProvider, child) {
          final destinations = destinationProvider.destinations
              .where((d) => d.name.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Search Destinations",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                ),
              ),
              if (destinationProvider.destinations.isEmpty)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(), // Show loader when empty
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final destination = destinations[index];

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              destination.imageUrl ?? 'https://via.placeholder.com/60',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
                            ),
                          ),
                          title: Text(destination.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(destination.country),
                          onTap: () {
                            print("📌 Navigating to AttractionsPage with: ${destination.name}");
                            Navigator.push(
                              context,

                              MaterialPageRoute(

                                builder: (context) => AttractionsPage(destination: destination),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ItineraryTravelDetailsPage()),
                        );
                      },
                      icon: Icon(Icons.add, color: Colors.black),
                      label: Text(
                        "New Itinerary",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ItinerariesHomePage()),
                        );
                      },
                      icon: Icon(Icons.list, color: Colors.black),
                      label: Text(
                        "Your Itineraries",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
