import 'dart:convert';
import '../database/database.dart';
import '../model/attraction.dart';
import '../model/destination.dart';

Future<void> populateDatabase(AppDatabase database) async {
  final destinationDao = database.destinationDao;
  final attractionDao = database.attractionDao;

  List<Map<String, dynamic>> destinationData = [
    {
      "name": "United States",
      "country": "USA",
      "imageUrl": "https://example.com/usa.jpg",
      "attractions": [
        {"name": "Statue of Liberty", "country": "USA", "imageUrl": "https://example.com/statue.jpg"},
        {"name": "Grand Canyon", "country": "USA", "imageUrl": "https://example.com/canyon.jpg"}
      ]
    },
    {
      "name": "France",
      "country": "France",
      "imageUrl": "https://example.com/france.jpg",
      "attractions": [
        {"name": "Eiffel Tower", "country": "France", "imageUrl": "https://example.com/eiffel.jpg"},
        {"name": "Louvre Museum", "country": "France", "imageUrl": "https://example.com/louvre.jpg"}
      ]
    },
    {
      "name": "Japan",
      "country": "Japan",
      "imageUrl": "https://example.com/japan.jpg",
      "attractions": [
        {"name": "Mount Fuji", "country": "Japan", "imageUrl": "https://example.com/fuji.jpg"},
        {"name": "Tokyo Tower", "country": "Japan", "imageUrl": "https://example.com/tokyo.jpg"}
      ]
    },
    {
      "name": "Italy",
      "country": "Italy",
      "imageUrl": "https://example.com/italy.jpg",
      "attractions": [
        {"name": "Colosseum", "country": "Italy", "imageUrl": "https://example.com/colosseum.jpg"},
        {"name": "Venice Canals", "country": "Italy", "imageUrl": "https://example.com/venice.jpg"}
      ]
    },
    {
      "name": "Australia",
      "country": "Australia",
      "imageUrl": "https://example.com/australia.jpg",
      "attractions": [
        {"name": "Sydney Opera House", "country": "Australia", "imageUrl": "https://example.com/sydney.jpg"},
        {"name": "Great Barrier Reef", "country": "Australia", "imageUrl": "https://example.com/reef.jpg"}
      ]
    },
    {
      "name": "Brazil",
      "country": "Brazil",
      "imageUrl": "https://example.com/brazil.jpg",
      "attractions": [
        {"name": "Christ the Redeemer", "country": "Brazil", "imageUrl": "https://example.com/christ.jpg"},
        {"name": "Amazon Rainforest", "country": "Brazil", "imageUrl": "https://example.com/amazon.jpg"}
      ]
    },
    {
      "name": "United Kingdom",
      "country": "UK",
      "imageUrl": "https://example.com/uk.jpg",
      "attractions": [
        {"name": "Big Ben", "country": "UK", "imageUrl": "https://example.com/bigben.jpg"},
        {"name": "Stonehenge", "country": "UK", "imageUrl": "https://example.com/stonehenge.jpg"}
      ]
    }
  ];


  for (var destinationMap in destinationData) {
    String attractionsJson = json.encode(destinationMap["attractions"]);

    // Insert Destination and get the auto-generated ID
    final destination = Destination(
      name: destinationMap["name"],
      country: destinationMap["country"],
      imageUrl: destinationMap["imageUrl"],
      attractionsJson: attractionsJson,
    );
    int destinationId = await destinationDao.insertDestination(destination);

    // Insert Attractions using the generated destinationId
    List<Attraction> attractions = (destinationMap["attractions"] as List<dynamic>)
        .map((a) => Attraction(
      name: a["name"],
      country: a["country"],
      imageUrl: a["imageUrl"],
      destinationId: destinationId,
    ))
        .toList();

    for (var attraction in attractions) {
      await attractionDao.insertAttraction(attraction);
    }
    print("✅ Attractions Inserted!");
  }
}
