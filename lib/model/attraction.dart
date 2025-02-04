class Attraction {
  final String name;
  final DateTime date;
  final String openingTime;
  final String closingTime;
  final String notes;

  Attraction({
    required this.name,
    required this.date,
    required this.openingTime,
    required this.closingTime,
    required this.notes,
  });

  @override
  String toString() {
    return "Attraction: $name, Date: $date, Open: $openingTime, Close: $closingTime, Notes: $notes";
  }
}


const Map<String, List<String>> attractionsList = {
  "United States": ["Statue of Liberty", "Grand Canyon", "Disney World"],
  "Canada": ["Niagara Falls", "Banff National Park", "CN Tower"],
  "United Kingdom": ["Big Ben", "Tower of London", "Stonehenge"],
  "France": ["Eiffel Tower", "Louvre Museum", "Mont Saint-Michel"],
  "Germany": ["Brandenburg Gate", "Neuschwanstein Castle", "Berlin Wall"],
  "Japan": ["Mount Fuji", "Tokyo Tower", "Fushimi Inari Shrine"],
  "India": ["Taj Mahal", "Red Fort", "Jaipur Palace"],
  "China": ["Great Wall of China", "Forbidden City", "Terracotta Army"],
  "Brazil": ["Christ the Redeemer", "Amazon Rainforest", "Sugarloaf Mountain"],
};
