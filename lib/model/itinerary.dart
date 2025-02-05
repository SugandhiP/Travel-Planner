import 'attraction.dart';

class Itinerary {
   String name;
   final String from;
   final String destination;
   int tripMembers;
   double initialBudget;
   final String departureTime;
   final String arrivalTime;
   String? hotelName;
   List<Attraction> attractions;
  bool isFavorite;

  Itinerary({required this.name,
    required this.from,
    required this.destination,
    this.tripMembers = 0,
    this.initialBudget = 0.0,
    required this.departureTime,
    required this.arrivalTime,
    required this.hotelName,
    List<Attraction>? attractions,
    this.isFavorite = false,
  }) : attractions = attractions ?? [];
}