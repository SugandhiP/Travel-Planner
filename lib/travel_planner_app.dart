import 'package:flutter/material.dart';
import 'package:travel_planner_project/itinerary_form.dart';

import 'model/itinerary.dart';
class TravelPlannerApp extends StatefulWidget {
  const TravelPlannerApp({super.key});

  @override
  State<TravelPlannerApp> createState() => _TravelPlannerAState();
}

class _TravelPlannerAState extends State<TravelPlannerApp> {
  List<Itinerary> itineraries = [];

  void _addItinerary() {

  }

  void _deleteItinerary(int index) {
    setState(() {
      itineraries.removeAt(index);
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      itineraries[index].isFavorite = !itineraries[index].isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Itineraries")),
      body: ListView.builder(
        itemCount: itineraries.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(itineraries[index].name),
            subtitle: Text(itineraries[index].destination),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    itineraries[index].isFavorite ? Icons.star : Icons.star_border,
                    color: itineraries[index].isFavorite ? Colors.yellow : Colors.grey,
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
              builder: (context) => ItineraryForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}