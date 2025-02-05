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
    return "Source: $source, Destination: $destination, Airline Name: $airline, "
        "Flight Number: $flightNumber, Departure Time: $departureTime, Arrival Time: $arrivalTime, "
        "Hotel Name: $hotelName, Destination Attractions: $selectedAttractions";
  }
}
