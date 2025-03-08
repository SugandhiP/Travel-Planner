import 'package:floor/floor.dart';

@Entity(tableName: 'AttractionDetails')
class AttractionDetails {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String openingHours;
  final String closingTime;
  final String officialWebsite;

  AttractionDetails({
    this.id,
    required this.openingHours,
    required this.closingTime,
    required this.officialWebsite,
  });

  // Convert AttractionDetails to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'openingHours': openingHours,
    'closingTime': closingTime,
    'officialWebsite': officialWebsite,
  };

  // Convert JSON to AttractionDetails object
  factory AttractionDetails.fromJson(Map<String, dynamic> json) => AttractionDetails(
    id: json['id'],
    openingHours: json['opening_hours'] ?? '',
    closingTime: json['closing_time'] ?? '',
    officialWebsite: json['official_website'] ?? '',
  );

  @override
  String toString() {
    return "Opening Hours: $openingHours, Closing Time: $closingTime, Website: $officialWebsite";
  }
}

