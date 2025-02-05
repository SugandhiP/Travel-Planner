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

  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _arrivalController = TextEditingController();


  @override
  void dispose() {
    _departureController.dispose();
    super.dispose();
  }
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
                  decoration: InputDecoration(
                    labelText: "From (Source)",
                    labelStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    prefixIcon: Icon(Icons.flight_takeoff, color: Colors.blue),
                  ),
                  items: countryList.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country, style: TextStyle(color: Colors.black87)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSource = value;
                    });
                  },
                  validator: (value) => value == null ? "Select a source" : null,
                ),
                SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "To (Destination)",
                    labelStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.green.shade50,
                    prefixIcon: Icon(Icons.flight_land, color: Colors.green),
                  ),
                  items: countryList.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country, style: TextStyle(color: Colors.black87)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDestination = value;
                      _selectedAttractions.clear(); // Reset attractions
                    });
                  },
                  validator: (value) => value == null ? "Select a destination" : null,
                ),
                SizedBox(height: 12),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Airline Name",
                    labelStyle: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.purple.shade50,
                    prefixIcon: Icon(Icons.airplanemode_active, color: Colors.purple),
                  ),
                  onChanged: (value) => _airline = value,
                  validator: (value) => value!.isEmpty ? "Enter airline name" : null,
                ),
                SizedBox(height: 12),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Flight Number",
                    labelStyle: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.orange.shade50,
                    prefixIcon: Icon(Icons.confirmation_number, color: Colors.orange),
                  ),
                  onChanged: (value) => _flightNumber = value,
                  validator: (value) => value!.isEmpty ? "Enter flight number" : null,
                ),
                SizedBox(height: 12),

                TextFormField(
                  controller: _departureController,
                  readOnly: true, // Prevents manual input
                  decoration: InputDecoration(
                    labelText: "Departure Time",
                    labelStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.red.shade50,
                    prefixIcon: Icon(Icons.access_time, color: Colors.redAccent),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        DateTime finalDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );

                        setState(() {
                          _departureTime = finalDateTime.toString();
                          _departureController.text =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day} ${pickedTime.format(context)}";
                        });
                      }
                    }
                  },
                  validator: (value) => value!.isEmpty ? "Select departure time" : null,
                ),
                SizedBox(height: 12),


                TextFormField(
                  controller: _arrivalController,
                  readOnly: true, // Prevents manual input
                  decoration: InputDecoration(
                    labelText: "Arrival Time",
                    labelStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.red.shade50,
                    prefixIcon: Icon(Icons.access_time, color: Colors.redAccent),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        DateTime finalDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );

                        setState(() {
                          _arrivalTime = finalDateTime.toString();
                          _arrivalController.text =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day} ${pickedTime.format(context)}";
                        });
                      }
                    }
                  },
                  validator: (value) => value!.isEmpty ? "Select arrival time" : null,
                ),
                SizedBox(height: 12),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Hotel Name",
                    labelStyle: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.indigo.shade50,
                    prefixIcon: Icon(Icons.hotel, color: Colors.indigo),
                  ),
                  //onChanged: (value) => _hotelName = value.isNotEmpty ? value : null,
                  onChanged: (value) {
                    _hotelName = value.isEmpty ? null : value;
                  },

                  validator: (value) => null,


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
                        _arrivalTime == null ) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill the required details")),
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
                      hotelName: _hotelName ?? "",
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
