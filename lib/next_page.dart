import 'package:flutter/material.dart';
import '../model/travel_details.dart';

class NextPage extends StatelessWidget {
  final TravelDetails travelDetails;

  const NextPage({super.key, required this.travelDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Review Travel Plan")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(travelDetails.toString()),
      ),
    );
  }
}
