import 'package:floor/floor.dart';
import 'package:travel_planner_project/model/string_type_converters.dart';
import 'expense.dart';
import 'expense_type_converters.dart';

@Entity(tableName: 'TravelDetails')
class TravelDetails{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  String name;
  String source;
  String destination;
  String airline;
  String flightNumber;
  String departureTime;
  String arrivalTime;
  String hotelName;
  late double initialBudget;
  final int tripMember;
  bool isFavorite;
  @TypeConverters([StringListConverter])
  List<String> selectedAttractions;
  @TypeConverters([ExpenseListConverter])
  List<Expense> expenses;
  String? pdfPath;

  TravelDetails({
    this.id,
    required this.name,
    required this.source,
    required this.destination,
    required this.airline,
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.hotelName,
    this.initialBudget = 0.0,
    this.tripMember = 0,
    required this.selectedAttractions,
    required this.isFavorite,
    required this.expenses,
    this.pdfPath,
  });

  //get id => null;

  factory TravelDetails.fromJson(Map<String, dynamic> json) {
    return TravelDetails(
      name: json['name'],
      source: json['source'],
      destination: json['destination'],
      airline: json['airline'],
      flightNumber: json['flightNumber'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      hotelName: json['hotelName'],
      initialBudget: (json['initialBudget'] as num).toDouble(),
      tripMember: json['tripMember'],
      selectedAttractions: List<String>.from(json['selectedAttractions']),
      isFavorite: json['isFavorite'],
      expenses: (json['expenses'] as List<dynamic>)
          .map((e) => Expense.fromJson(e))
          .toList(),
      pdfPath: json['pdfPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'source': source,
      'destination': destination,
      'airline': airline,
      'flightNumber': flightNumber,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'hotelName': hotelName,
      'initialBudget': initialBudget,
      'tripMember': tripMember,
      'selectedAttractions': selectedAttractions,
      'isFavorite': isFavorite,
      'expenses': expenses.map((e) => e.toJson()).toList(),
      'pdfPath': pdfPath,
    };
  }

  @override
  String toString() {
    return "Source: $source, Destination: $destination, Airline Name: $airline, "
        "Flight Number: $flightNumber, Departure Time: $departureTime, Arrival Time: $arrivalTime, "
        "Hotel Name: $hotelName, Initial Budget(USD): $initialBudget, Trip Members: $tripMember, Destination Attractions: $selectedAttractions,PdfPath:$pdfPath";
  }

  TravelDetails copyWith({
    String? name,
    String? source,
    String? destination,
    String? airline,
    String? flightNumber,
    String? departureTime,
    String? arrivalTime,
    String? hotelName,
    double? initialBudget,
    int? tripMember,
    List<String>? selectedAttractions,
    bool? isFavorite,
    List<Expense>? expenses,
    String? pdfPath,
  }) {
    return TravelDetails(
      name: name ?? this.name,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      airline: airline ?? this.airline,
      flightNumber: flightNumber ?? this.flightNumber,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      hotelName: hotelName ?? this.hotelName,
      initialBudget: initialBudget ?? this.initialBudget,
      tripMember: tripMember ?? this.tripMember,
      selectedAttractions: selectedAttractions ?? this.selectedAttractions,
      isFavorite: isFavorite ?? this.isFavorite,
      expenses: expenses ?? this.expenses,
      pdfPath: pdfPath ?? this.pdfPath,
    );
  }
}

/*
@Entity(tableName: 'Expense')
class TravelDetails {
  @PrimaryKey(autoGenerate: true)
  String name;
  String source;
  String destination;
  String airline;
  String flightNumber;
  String departureTime;
  String arrivalTime;
  String hotelName;
  late final double initialBudget;
  final int tripMember;
  List<String> selectedAttractions;
  bool isFavorite;
  List<Expense> expenses;

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
    required this.expenses,
  });

  get id => null;

  @override
  String toString() {
    return "Source: $source, Destination: $destination, Airline Name: $airline, "
        "Flight Number: $flightNumber, Departure Time: $departureTime, Arrival Time: $arrivalTime, "
        "Hotel Name: $hotelName, Initial Budget(USD): $initialBudget,Trip Members: $tripMember ,Destination Attractions: $selectedAttractions";
  }
}
*/
