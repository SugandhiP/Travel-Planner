import 'package:floor/floor.dart';

@entity
class Attraction {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String country;
  final String imageUrl;
  //final DateTime date;
  final int destinationId; // Foreign key reference

  Attraction({
    this.id,
    required this.name,
    //required this.date,
    required this.country,
    required this.imageUrl,
    required this.destinationId

  });

  // Convert Attraction to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'country': country,
    'imageUrl': imageUrl,
    'destinationId':destinationId,
  };

  // Convert JSON to Attraction object
  factory Attraction.fromJson(Map<String, dynamic> json) => Attraction(
    id: json['id'],
    name: json['name'],
    country: json['country'],
    imageUrl: json['imageUrl'],
    destinationId: json['destinationId']  ?? 0,
  );

  @override
  String toString() {
    //return "Attraction: $name, Country:$country,Date: $date";
    return "Attraction: $name, Country:$country ,ImageUrl:$imageUrl ,DestinationId:$destinationId";
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
