import 'attraction.dart';

class Itinerary {
   String name;
   final String from;
   final String destination;
   final String departureTime;
   final String arrivalTime;
   String? hotelName;
   int tripMembers;
   double initialBudget;
   List<Attraction> attractions;
  bool isFavorite;

  Itinerary({required this.name,
    required this.from,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.hotelName,
    this.tripMembers = 0,
    this.initialBudget = 0.0,
    List<Attraction>? attractions,
    this.isFavorite = false,
  }) : attractions = attractions ?? [];
}