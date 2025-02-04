class TravelDetails {
  String source;
  String destination;
  String airline;
  String flightNumber;
  String departureTime;
  String arrivalTime;
  String hotelName;
  List<String> selectedAttractions;

  TravelDetails({
    required this.source,
    required this.destination,
    required this.airline,
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.hotelName,
    required this.selectedAttractions,
  });

  @override
  String toString() {
    return "Source: $source, Destination: $destination, Airline: $airline, "
        "Flight: $flightNumber, Departure: $departureTime, Arrival: $arrivalTime, "
        "Hotel: $hotelName, Attractions: $selectedAttractions";
  }
}
