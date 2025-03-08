import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:travel_planner_project/database/database.dart';
import 'package:travel_planner_project/itinerary/itinerary_travel_details_page.dart';
import 'package:travel_planner_project/itinerary/pdf_viewer_screen.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import '../expense_tracker/expense_tracker_page.dart';
import 'itineraries_data_recorded_page.dart';

class ItinerariesHomePage extends StatefulWidget {
  ItinerariesHomePage({super.key});

  @override
  State<ItinerariesHomePage> createState() => _TravelPlannerAState();
}

class _TravelPlannerAState extends State<ItinerariesHomePage> {
  late AppDatabase database;

  @override
  void initState() {
    super.initState();
    database = Provider.of<AppDatabase>(context, listen: false);
  }

  Future<void> _deleteItinerary(TravelDetails td) async {
    await database.travelDetailsDao.deleteTravelDetail(td.name);
    setState(() {}); // Refresh UI after deletion
  }


  Future<void> _toggleFavorite(TravelDetails travelDetail) async {
    bool isFav = travelDetail.isFavorite;
    TravelDetails newTravelDetails = travelDetail;
    await database.travelDetailsDao.deleteTravelDetail(travelDetail.name);
    newTravelDetails.isFavorite = !isFav;
    await database.travelDetailsDao.insertTravelDetail(newTravelDetails);
    setState(() {});
  }


  void _editItinerary(TravelDetails travelDetail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItineraryTravelDetailsPage(travelDetails: travelDetail),
      ),
    );
  }

  void _viewItinerary(TravelDetails travelDetail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItinerariesDataRecordedPage(
          travelDetails: travelDetail,
          isViewing: true,
        ),
      ),
    );
  }

  void _openExpenseTracker(TravelDetails travelDetail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseTrackerPage(travelDetails: travelDetail),
      ),
    );
  }

  Future<void> _generatePDF(int travelDetailId) async {
    try {
      // ✅ Fetch the correct itinerary by ID
      TravelDetails? travelDetail = await database.travelDetailsDao.getTravelDetailById(travelDetailId);

      if (travelDetail == null) {
        print("Error: Travel details not found for ID $travelDetailId!");
        return;
      }

      final pdf = pw.Document();

      // ✅ Load the font for better styling
      final fontData = await rootBundle.load("assets/fonts/Roboto-VariableFont_wdth,wght.ttf");
      final boldFontData = await rootBundle.load("assets/fonts/Roboto-Italic-VariableFont_wdth,wght.ttf");

      final ttf = pw.Font.ttf(fontData.buffer.asByteData());
      final ttfBold = pw.Font.ttf(boldFontData.buffer.asByteData());

      // ✅ Create the PDF layout
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Travel Itinerary", style: pw.TextStyle(font: ttfBold, fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text("Destination: ${travelDetail.destination}", style: pw.TextStyle(font: ttf, fontSize: 18)),
                pw.Text("Departure: ${travelDetail.departureTime}", style: pw.TextStyle(font: ttf, fontSize: 16)),
              ],
            );
          },
        ),
      );

      // ✅ Save the PDF file
      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/itinerary_${travelDetail.id}.pdf");
      await file.writeAsBytes(await pdf.save());

      // ✅ Update the PDF path in the database
      travelDetail.pdfPath = file.path;
      print('trvael path : $travelDetail.pdfPath');
      await database.travelDetailsDao.updateTravelDetail(travelDetail);

      setState(() {}); // Refresh UI after saving

      print("PDF successfully saved at: ${file.path}");
    } catch (e) {
      print("Error generating PDF: $e");
    }
  }



  void _viewPDF(TravelDetails travelDetail) {
    if (travelDetail.pdfPath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(pdfPath: travelDetail.pdfPath!),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Your Itineraries",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Takes the user back to HomePage
          },
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<TravelDetails>>(
        future: database.travelDetailsDao.getAllTravelDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No itineraries available"));
          }

          List<TravelDetails> myTravelDetails = snapshot.data!;

          // void _toggleFavorite(TravelDetails myTravelDetails) {
          //   setState(() {
          //     if(myTravelDetails.isFavorite)
          //       myTravelDetails.isFavorite = false;
          //     myTravelDetails.isFavorite = true;
          //     //myTravelDetails.isFavorite = !myTravelDetails.isFavorite;
          //   });
          // }

          // Sort itineraries: Favorites first, then by departure time
          myTravelDetails.sort((a, b) {
            if (a.isFavorite && !b.isFavorite) return -1;
            if (!a.isFavorite && b.isFavorite) return 1;
            return a.departureTime.compareTo(b.departureTime);
          });

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView.builder(
              itemCount: myTravelDetails.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final travelDetail = myTravelDetails[index];

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flight_outlined, color: Colors.blueAccent, size: 35),
                            SizedBox(width: 10), // Adds spacing between icon and text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    travelDetail.name,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis, // Prevents text from overflowing
                                  ),
                                  Text(
                                    travelDetail.destination,
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10), // Adds space between text and icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    travelDetail.isFavorite ? Icons.star : Icons.star_border,
                                    color: travelDetail.isFavorite ? Colors.amber : Colors.grey,
                                  ),
                                  onPressed: () => _toggleFavorite(travelDetail),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () => _editItinerary(travelDetail),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_red_eye, color: Colors.green),
                                  onPressed: () => _viewItinerary(travelDetail),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteItinerary(travelDetail),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Generate PDF / View PDF Button
                              ElevatedButton(
                                onPressed: travelDetail.pdfPath == null
                                    ? () => _generatePDF(travelDetail.id!)
                                    : () => _viewPDF(travelDetail),
                                child: Text(travelDetail.pdfPath == null ? "Generate PDF" : "View PDF"),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(150, 45),
                                ),
                              ),
                              SizedBox(width: 12), // Space between buttons

                              // Expense Tracker Button
                              ElevatedButton(
                                onPressed: () => _openExpenseTracker(travelDetail),
                                child: Text("Expense Tracker"),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(150, 45),
                                  backgroundColor: Colors.orange, // Different color for differentiation
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SizedBox(height: 10),
                        // Center(
                        //   child: travelDetail.pdfPath == null
                        //       ? ElevatedButton(
                        //     onPressed: () => _generatePDF(travelDetail.id!),
                        //     child: Text("Generate PDF"),
                        //     style: ElevatedButton.styleFrom(minimumSize: Size(150, 45)),
                        //   )
                        //       : ElevatedButton(
                        //     onPressed: () => _viewPDF(travelDetail),
                        //     child: Text("View PDF"),
                        //     style: ElevatedButton.styleFrom(minimumSize: Size(150, 45)),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ItineraryTravelDetailsPage.isEditing = false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ItineraryTravelDetailsPage()),
          );
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "New Itinerary",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}