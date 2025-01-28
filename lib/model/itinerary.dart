import 'attraction.dart';

class Itinerary {
  final String from;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int tripMembers;
  final int initialBudget;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String hotelName;
  final List<Attraction> attractions;

  const Itinerary(
      this.from,
      this.destination,
      this.startDate,
      this.endDate,
      this.tripMembers,
      this.initialBudget,
      this.departureTime,
      this.arrivalTime,
      this.hotelName,
      this.attractions);
}