import 'package:flutter/material.dart';

import 'model/itinerary.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  List<Itinerary> itineraries = [];
  //final TextEditingController _nameController;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
