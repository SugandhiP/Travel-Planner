import 'package:flutter/material.dart';
import '../model/travel_details.dart';
import '../data/country_list.dart';
import '../model/attraction.dart';
import 'next_page.dart';

class TravelForm extends StatefulWidget {
  const TravelForm({super.key});

  @override
  _TravelFormState createState() => _TravelFormState();
}

class _TravelFormState extends State<TravelForm> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedSource;
  String? _selectedDestination;
  String? _airline;
  String? _flightNumber;
  String? _departureTime;
  String? _arrivalTime;
  String? _hotelName;
  List<String> _selectedAttractions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Travel Planner")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "From (Source)"),
                  items: countryList.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSource = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "To (Destination)"),
                  items: countryList.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDestination = value;
                      _selectedAttractions.clear(); // Reset attractions
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: "Airline Name"),
                  onChanged: (value) => _airline = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Flight Number"),
                  onChanged: (value) => _flightNumber = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Departure Time"),
                  onChanged: (value) => _departureTime = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Arrival Time"),
                  onChanged: (value) => _arrivalTime = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Hotel Name"),
                  onChanged: (value) => _hotelName = value,
                ),
                SizedBox(height: 20),

                if (_selectedDestination != null &&
                    attractionsList.containsKey(_selectedDestination))
                  ExpansionTile(
                    title: Text("Select Attractions"),
                    children: [
                      Column(
                        children: attractionsList[_selectedDestination]!
                            .map((attraction) => CheckboxListTile(
                          title: Text(attraction),
                          value: _selectedAttractions.contains(attraction),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                _selectedAttractions.add(attraction);
                              } else {
                                _selectedAttractions.remove(attraction);
                              }
                            });
                          },
                        ))
                            .toList(),
                      )
                    ],
                  ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedSource == null ||
                        _selectedDestination == null ||
                        _airline == null ||
                        _flightNumber == null ||
                        _departureTime == null ||
                        _arrivalTime == null ||
                        _hotelName == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill all fields before proceeding")),
                      );
                      return;
                    }

                    TravelDetails travelDetails = TravelDetails(
                      source: _selectedSource ?? "Unknown",
                      destination: _selectedDestination ?? "Unknown",
                      airline: _airline ?? "Unknown",
                      flightNumber: _flightNumber ?? "Unknown",
                      departureTime: _departureTime ?? "Unknown",
                      arrivalTime: _arrivalTime ?? "Unknown",
                      hotelName: _hotelName ?? "Unknown",
                      selectedAttractions: _selectedAttractions ?? [],
                    );

                    print("Navigating with: $travelDetails");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NextPage(travelDetails: travelDetails),
                      ),
                    );
                  },

                  child: Text("Save & Next"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
