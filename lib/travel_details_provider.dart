import 'package:flutter/material.dart';
import 'package:travel_planner_project/model/travel_details.dart';

class TravelDetailsProvider with ChangeNotifier {
  final List<TravelDetails> _travelDetail = [];

  List<TravelDetails> get travelDetail => _travelDetail;

  void addTravelDetails(TravelDetails travelDetails) {
    _travelDetail.add(travelDetails);
    notifyListeners();
  }

  void deleteTravelDetails(int index) {
    _travelDetail.removeAt(index);
    notifyListeners();
  }

  void updateTravelDetails(int index, TravelDetails travelDetails) {
    _travelDetail[index] = travelDetails;
    notifyListeners();
  }
}
