import 'dart:convert';

import 'package:floor/floor.dart';
import 'attraction.dart';

@entity
class Destination {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String country;
  final String imageUrl;
  final String attractionsJson;

  Destination({this.id, required this.name, required this.country,required this.imageUrl,required this.attractionsJson});

  // Convert JSON String to List<Attraction>
  List<Attraction> get attractions {
    if (attractionsJson.isEmpty) return [];
    List<dynamic> jsonList = json.decode(attractionsJson);
    return jsonList.map((json) => Attraction.fromJson(json)).toList();
  }

  // Convert List<Attraction> to JSON String
  Destination copyWith({List<Attraction>? newAttractions}) {
    return Destination(
      id: id,
      name: name,
      country: country,
      imageUrl: imageUrl,
      attractionsJson: json.encode(newAttractions?.map((a) => a.toJson()).toList() ?? []),
    );
  }
}
