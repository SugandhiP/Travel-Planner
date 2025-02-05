import 'package:flutter/material.dart';

import 'model/itinerary.dart';

class ItineraryProvider with ChangeNotifier {
  final List<Itinerary> _itinerary = [];

  List<Itinerary> get itinerary => _itinerary;

  void addItinerary(Itinerary itinerary) {
    _itinerary.add(itinerary);
    notifyListeners();
  }
}