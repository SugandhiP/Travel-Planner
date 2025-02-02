import 'attraction.dart';

class Itinerary {
  final String name;
   final String from;
   final String destination;
   final DateTime startDate;
   final DateTime endDate;
   int tripMembers;
   double initialBudget;
   final DateTime departureTime;
   final DateTime arrivalTime;
   final String hotelName;
   List<Attraction> attractions;
  bool isFavorite;

  Itinerary({required this.name,
    required this.from,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.tripMembers = 0,
    this.initialBudget = 0.0,
    required this.departureTime,
    required this.arrivalTime,
    required this.hotelName,
    List<Attraction>? attractions,
    this.isFavorite = false,
  }) : attractions = attractions ?? [];
}