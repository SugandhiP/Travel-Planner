import 'package:flutter/material.dart';
import '../model/travel_details.dart';
import '../data/country_list.dart';
import '../model/attraction.dart';
import 'itineraries_data_recorded_page.dart';
import 'package:provider/provider.dart';
import '../travel_details_provider.dart';

class ItineraryTravelDetailsPage extends StatefulWidget {
  final TravelDetails? travelDetails;
  final int? index;

  const ItineraryTravelDetailsPage({Key? key, this.travelDetails, this.index})
      : super(key: key);

  @override
  _TravelFormState createState() => _TravelFormState();
}

class _TravelFormState extends State<ItineraryTravelDetailsPage> {
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _arrivalController = TextEditingController();

  @override
  void dispose() {
    _departureController.dispose();
    _arrivalController.dispose();
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
  double? _initialBudget;
  int? _tripMembers;
  List<String> _selectedAttractions = [];

  @override
  void initState() {
    super.initState();
    if (widget.travelDetails != null) {
      _selectedSource = widget.travelDetails!.source;
      _selectedDestination = widget.travelDetails!.destination;
      _airline = widget.travelDetails!.airline;
      _flightNumber = widget.travelDetails!.flightNumber;
      _departureTime = widget.travelDetails!.departureTime;
      _arrivalTime = widget.travelDetails!.arrivalTime;
      _hotelName = widget.travelDetails!.hotelName;
      _initialBudget = widget.travelDetails!.initialBudget;
      _tripMembers = widget.travelDetails!.tripMember;
      _selectedAttractions =
          List.from(widget.travelDetails!.selectedAttractions);

      _departureController.text = widget.travelDetails!.departureTime;
      _arrivalController.text = widget.travelDetails!.arrivalTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centers the content
          children: [
            Text(
              "Travel Planner",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true, // Ensures proper centering

      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedSource,
                  decoration: InputDecoration(
                    labelText: "From (Source)",
                    labelStyle: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    prefixIcon: Icon(Icons.flight_takeoff, color: Colors.blue),
                  ),
                  items: countryList.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country,
                          style: TextStyle(color: Colors.black87)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSource = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Select a source" : null,
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedDestination,
                  decoration: InputDecoration(
                    labelText: "To (Destination)",
                    labelStyle: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.green.shade50,
                    prefixIcon: Icon(Icons.flight_land, color: Colors.green),
                  ),
                  items: countryList.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country,
                          style: TextStyle(color: Colors.black87)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDestination = value;
                      _selectedAttractions.clear();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Select a destination location";
                    }
                    if (_selectedSource != null && value == _selectedSource) {
                      return "Source and destination cannot be the same";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: _airline,
                  decoration: InputDecoration(
                    labelText: "Airline Name",
                    labelStyle: TextStyle(
                        color: Colors.purple, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.purple.shade50,
                    prefixIcon:
                        Icon(Icons.airplanemode_active, color: Colors.purple),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _airline = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter airline name";
                    }
                    if (!RegExp(r'^[a-zA-Z\\s]+$').hasMatch(value)) {
                      return "Please enter valid input";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: _flightNumber,
                  decoration: InputDecoration(
                    labelText: "Flight Number",
                    labelStyle: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.orange.shade50,
                    prefixIcon:
                        Icon(Icons.confirmation_number, color: Colors.orange),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _flightNumber = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter flight number";
                    }
                    if (!RegExp(r'^[a-zA-Z0-9\\s]+$').hasMatch(value)) {
                      return "Flight number should only contain letters and numbers";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _departureController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Departure Date and Time",
                    labelStyle: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.red.shade50,
                    prefixIcon:
                        Icon(Icons.access_time, color: Colors.redAccent),
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
                  validator: (value) =>
                      value!.isEmpty ? "Select departure time" : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _arrivalController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Arrival Date and Time",
                    labelStyle: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.red.shade50,
                    prefixIcon:
                        Icon(Icons.access_time, color: Colors.redAccent),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Select arrival time";
                    }
                    DateTime? departure = _departureTime != null
                        ? DateTime.parse(_departureTime!)
                        : null;
                    DateTime? arrival = _arrivalTime != null
                        ? DateTime.parse(_arrivalTime!)
                        : null;

                    if (departure != null &&
                        arrival != null &&
                        departure.isAtSameMomentAs(arrival)) {
                      return "Arrival time cannot be the same as departure time";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: _hotelName,
                  decoration: InputDecoration(
                    labelText: "Hotel Name",
                    labelStyle: TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.indigo.shade50,
                    prefixIcon: Icon(Icons.hotel, color: Colors.indigo),
                  ),
                  onChanged: (value) => _hotelName = value,
                  validator: (value) {
                    RegExp regExp = RegExp(r'^[a-zA-Z\s]+$');
                    if (value == null || value.isEmpty) {
                      return "Hotel name is required";
                    } else if (!regExp.hasMatch(value)) {
                      return "enter valid input with letters and space";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: _initialBudget?.toString(),
                  decoration: InputDecoration(
                    labelText: "Initial Budget(USD)",
                    labelStyle: TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.brown.shade50,
                    prefixIcon: Icon(Icons.attach_money, color: Colors.brown),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _initialBudget = double.tryParse(value) ?? 0.0;
                    });
                  },
                  validator: (value) {
                    if (value!.isNotEmpty && double.tryParse(value) == null) {
                      return "Enter a valid budget amount";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  initialValue: _tripMembers?.toString(),
                  decoration: InputDecoration(
                    labelText: "Trip Members",
                    labelStyle: TextStyle(
                        color: Colors.teal, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.teal.shade50,
                    prefixIcon: Icon(Icons.group, color: Colors.teal),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _tripMembers = int.tryParse(value) ?? 0;
                    });
                  },
                  validator: (value) {
                    if (value!.isNotEmpty && int.tryParse(value) == null) {
                      return "Enter a valid number of trip members";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                if (_selectedDestination != null &&
                    attractionsList.containsKey(_selectedDestination))
                  ExpansionTile(
                    title: Text("Select Attractions"),
                    children: [
                      Column(
                        children: attractionsList[_selectedDestination]!
                            .map((attraction) => CheckboxListTile(
                                  title: Text(attraction),
                                  value:
                                      _selectedAttractions.contains(attraction),
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
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedSource == null ||
                            _selectedDestination == null ||
                            _airline == null ||
                            _flightNumber == null ||
                            _departureTime == null ||
                            _arrivalTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Please fill all required fields before proceeding")),
                          );
                          return;
                        }

                        TravelDetails travelDetail = TravelDetails(
                          name: "",
                          source: _selectedSource!,
                          destination: _selectedDestination!,
                          airline: _airline!,
                          flightNumber: _flightNumber!,
                          departureTime: _departureTime!,
                          arrivalTime: _arrivalTime!,
                          hotelName: _hotelName!,
                          initialBudget: _initialBudget ?? 0.0,
                          tripMember: _tripMembers ?? 0,
                          selectedAttractions: _selectedAttractions,
                          isFavorite: false,
                        );

                        if (widget.travelDetails != null &&
                            widget.index != null) {
                          // Editing Existing
                          widget.travelDetails!.source = _selectedSource!;
                          widget.travelDetails!.destination =
                              _selectedDestination!;
                          widget.travelDetails!.airline = _airline!;
                          widget.travelDetails!.flightNumber = _flightNumber!;
                          widget.travelDetails!.departureTime = _departureTime!;
                          widget.travelDetails!.arrivalTime = _arrivalTime!;
                          widget.travelDetails!.hotelName = _hotelName!;
                          _initialBudget ?? widget.travelDetails!.initialBudget;
                          _tripMembers ?? widget.travelDetails!.tripMember;
                          //widget.travelDetails!.tripMember = _tripMembers ?? 0;
                          widget.travelDetails!.selectedAttractions =
                              _selectedAttractions;

                          context
                              .read<TravelDetailsProvider>()
                              .updateTravelDetails(
                                  widget.index!, widget.travelDetails!);
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder:
                          // (context) => ItinerariesDataRecordedPage(travelDetails: travelDetail,)),);
                        } else {
                          // Adding New
                          //context.read<TravelDetailsProvider>().addTravelDetails(travelDetail);
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItinerariesDataRecordedPage(
                                travelDetails: travelDetail),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter valid input")),
                        );
                      }
                    },
                    child: Text("Save & Next"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
