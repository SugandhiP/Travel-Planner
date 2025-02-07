import 'package:flutter/material.dart';
import 'package:travel_planner_project/model/travel_details.dart';

class TravelDetailsProvider extends ChangeNotifier {
  final List<TravelDetails> _travelDetails = [];

  List<TravelDetails> get travelDetail => _travelDetails;

  void addTravelDetails(TravelDetails travelDetail) {
    _travelDetails.add(travelDetail);
    notifyListeners();
  }

}
