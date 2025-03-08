import 'dart:convert';
import '../database/database.dart';
import '../model/attraction.dart';
import '../model/destination.dart';

Future<void> populateDatabase(AppDatabase database) async {
  final destinationDao = database.destinationDao;
  final attractionDao = database.attractionDao;

  final existingDestinations = await destinationDao.getAllDestinations();
  if (existingDestinations.isNotEmpty) {
    print("Database already populated. Skipping insertion.");
    return;
  }

  List<Map<String, dynamic>> destinationData = [
    {
      "name": "United States",
      "country": "USA",
      "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg",
      "attractions": [
        {"name": "Statue of Liberty", "country": "USA", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"},
        {"name": "Grand Canyon", "country": "USA", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"}
      ]
    },
    {
      "name": "France",
      "country": "France",
      "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg",
      "attractions": [
        {"name": "Eiffel Tower", "country": "France", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"},
        {"name": "Louvre Museum", "country": "France", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"}
      ]
    },
    {
      "name": "Japan",
      "country": "Japan",
      "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg",
      "attractions": [
        {"name": "Mount Fuji", "country": "Japan", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"},
        {"name": "Tokyo Tower", "country": "Japan", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"}
      ]
    },
    {
      "name": "Italy",
      "country": "Italy",
      "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg",
      "attractions": [
        {"name": "Colosseum", "country": "Italy", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"},
        {"name": "Venice Canals", "country": "Italy", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"}
      ]
    },
    {
      "name": "Australia",
      "country": "Australia",
      "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg",
      "attractions": [
        {"name": "Sydney Opera House", "country": "Australia", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"},
        {"name": "Great Barrier Reef", "country": "Australia", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"}
      ]
    },
    {
      "name": "Brazil",
      "country": "Brazil",
      "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg",
      "attractions": [
        {"name": "Christ the Redeemer", "country": "Brazil", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"},
        {"name": "Amazon Rainforest", "country": "Brazil", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"}
      ]
    },
    {
      "name": "United Kingdom",
      "country": "UK",
      "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg",
      "attractions": [
        {"name": "Big Ben", "country": "UK", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"},
        {"name": "Stonehenge", "country": "UK", "imageUrl": "https://images.pexels.com/photos/248159/pexels-photo-248159.jpeg"}
      ]
    }
  ];


  for (var destinationMap in destinationData) {
    String attractionsJson = json.encode(destinationMap["attractions"]);

    final destination = Destination(
      name: destinationMap["name"],
      country: destinationMap["country"],
      imageUrl: destinationMap["imageUrl"],
      attractionsJson: attractionsJson,
    );
    int destinationId = await destinationDao.insertDestination(destination);

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
  }


}

