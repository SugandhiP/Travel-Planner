class TravelDetails {
  String name;
  String source;
  String destination;
  String airline;
  String flightNumber;
  String departureTime;
  String arrivalTime;
  String hotelName;
  final double initialBudget;
  final int tripMember;
  List<String> selectedAttractions;
  bool isFavorite;

  TravelDetails({
    required this.name,
    required this.source,
    required this.destination,
    required this.airline,
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.hotelName,
    this.initialBudget =0.0,
    this.tripMember = 0,
    required this.selectedAttractions,
    required this.isFavorite,
  });

  @override
  String toString() {
    return "Source: $source, Destination: $destination, Airline Name: $airline, "
        "Flight Number: $flightNumber, Departure Time: $departureTime, Arrival Time: $arrivalTime, "
        "Hotel Name: $hotelName, Initial Budget(USD): $initialBudget,Trip Members: $tripMember ,Destination Attractions: $selectedAttractions";
  }
}

