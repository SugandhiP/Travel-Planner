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
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Travel Planner", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search Destinations",
                hintText: "Type to search...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<TravelDetailsProvider>(
              builder: (context, destinationProvider, child) {
                final destinations = destinationProvider.destinations
                    .where((d) => d.name.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();

                return destinations.isEmpty
                    ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                  ),
                )
                    : Scrollbar(
                  thickness: 6,
                  radius: Radius.circular(10),
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final destination = destinations[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              destination.imageUrl ?? '',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported, color: Colors.grey),
                            ),
                          ),
                          title: Text(
                            destination.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blueAccent,
                            ),
                          ),
                          subtitle: Text(
                            destination.country,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                          onTap: () {
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
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItineraryTravelDetailsPage()),
                  );
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  "New Itinerary",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItinerariesHomePage()),
                  );
                },
                icon: Icon(Icons.list, color: Colors.white),
                label: Text(
                  "Your Itineraries",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
