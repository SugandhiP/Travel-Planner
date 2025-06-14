import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:travel_planner_project/database/database.dart';
import 'package:travel_planner_project/itinerary/home_page.dart';
import 'package:travel_planner_project/itinerary/itinerary_travel_details_page.dart';
import 'package:travel_planner_project/itinerary/pdf_viewer_screen.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import '../expense_tracker/expense_tracker_page.dart';
import 'image_viewer_screen.dart';
import 'itineraries_data_recorded_page.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:typed_data';

class ItinerariesHomePage extends StatefulWidget {
  ItinerariesHomePage({Key? key}) : super(key: key);

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
    setState(() {});
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

  Future<void> _takePhoto(TravelDetails travelDetail) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {

      List<String> existingImages = travelDetail.imagePaths ?? [];

      existingImages.add(pickedFile.path);

      travelDetail.imagePaths = existingImages;

      await database.travelDetailsDao.updateTravelDetail(travelDetail);

      setState(() {});
    }
  }

  Widget _buildPhotoViewButton(TravelDetails travelDetail) {
    return IconButton(
      icon: Icon(Icons.camera_alt, color: Colors.blue),
      onPressed: () => _takePhoto(travelDetail),
    );
  }

  String formatDateTime(String dateTimeString) {
    try {
      DateTime parsedDate = DateTime.parse(dateTimeString);
      return DateFormat('MMMM dd, yyyy - HH:mm').format(parsedDate);
    } catch (e) {
      return dateTimeString;
    }
  }
  Future<void> _generatePDF(int travelDetailId) async {
    try {
      TravelDetails? travelDetail = await database.travelDetailsDao.getTravelDetailById(travelDetailId);

      if (travelDetail == null) {
        print("Error: Travel details not found for ID $travelDetailId!");
        return;
      }

      final pdf = pw.Document();
      final fontData = await rootBundle.load("assets/fonts/Roboto-VariableFont_wdth,wght.ttf");
      final boldFontData = await rootBundle.load("assets/fonts/Roboto-Italic-VariableFont_wdth,wght.ttf");

      final ttf = pw.Font.ttf(fontData.buffer.asByteData());
      final ttfBold = pw.Font.ttf(boldFontData.buffer.asByteData());

      final darkBlue = PdfColor.fromInt(0xFF0A3D62);
      final royalBlue = PdfColor.fromInt(0xFF1E3799);
      final greyBackground = PdfColor.fromInt(0xFFF5F6FA);
      final white =PdfColor.fromInt(0xFFFFFFFF);
      final black = PdfColor.fromInt(0xFF000000);
      final darkGrey = PdfColor.fromInt(0xFF3C3C3C);

      pdf.addPage(
        pw.Page(
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.Container(
              padding: pw.EdgeInsets.all(16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Container(
                    width: double.infinity,
                    padding: pw.EdgeInsets.symmetric(vertical: 14),
                    decoration: pw.BoxDecoration(
                      color: darkBlue,
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        "TRAVEL ITINERARY",
                        style: pw.TextStyle(
                          font: ttfBold,
                          fontSize: 28,
                          color: white,
                        ),
                      ),
                    ),
                  ),

                  pw.SizedBox(height: 20),
                  _buildSectionContainer(
                    title: "Trip Details",
                    titleColor: white,
                    backgroundColor: royalBlue,
                    ttfBold: ttfBold,
                    children: [
                      _buildDetailRow("Name:", travelDetail.name, ttf, ttfBold, white),
                      _buildDetailRow("Source:", travelDetail.source, ttf, ttfBold, white),
                      _buildDetailRow("Destination:", travelDetail.destination, ttf, ttfBold, white),
                      _buildDetailRow("Airline:", travelDetail.airline, ttf, ttfBold, white),
                      _buildDetailRow("Flight Number:", travelDetail.flightNumber, ttf, ttfBold, white),
                    ],
                  ),

                  pw.SizedBox(height: 16),
                  _buildSectionContainer(
                    title: "Flight Timings",
                    titleColor: darkGrey,
                    backgroundColor: greyBackground,
                    ttfBold: ttfBold,
                    children: [
                      _buildDetailRow("Departure:", formatDateTime(travelDetail.departureTime), ttf, ttfBold, black),
                      _buildDetailRow("Arrival:", formatDateTime(travelDetail.arrivalTime), ttf, ttfBold, black),
                    ],
                  ),

                  pw.SizedBox(height: 16),
                  _buildSectionContainer(
                    title: "Accommodation",
                    titleColor: darkGrey,
                    backgroundColor: white,
                    ttfBold: ttfBold,
                    children: [
                      _buildDetailRow("Hotel Name:", travelDetail.hotelName, ttf, ttfBold, black),
                    ],
                  ),

                  pw.SizedBox(height: 16),
                  _buildSectionContainer(
                    title: "Budget & Travelers",
                    titleColor: white,
                    backgroundColor: darkBlue,
                    ttfBold: ttfBold,
                    children: [
                      _buildDetailRow("Budget (USD):", "\$${travelDetail.initialBudget}", ttf, ttfBold, white),
                      _buildDetailRow("Trip Members:", travelDetail.tripMember.toString(), ttf, ttfBold, white),
                    ],
                  ),

                  pw.SizedBox(height: 16),
                  _buildSectionContainer(
                    title: "Attractions to Visit",
                    titleColor: black,
                    backgroundColor: greyBackground,
                    ttfBold: ttfBold,
                    children: [
                      pw.Text(
                        travelDetail.selectedAttractions.isNotEmpty
                            ? travelDetail.selectedAttractions.join(", ")
                            : "No attractions selected",
                        style: pw.TextStyle(font: ttf, fontSize: 16, color: black),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 30),

                  pw.Center(
                    child: pw.Text(
                      "Happy Travels!",
                      style: pw.TextStyle(font: ttfBold, fontSize: 20, color: darkBlue),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/itinerary_${travelDetail.id}.pdf");
      await file.writeAsBytes(await pdf.save());
      travelDetail.pdfPath = file.path;
      await database.travelDetailsDao.updateTravelDetail(travelDetail);

      setState(() {});
      print("PDF successfully saved at: ${file.path}");
    } catch (e) {
      print("Error generating PDF: $e");
    }
  }

  pw.Widget _buildSectionContainer({
    required String title,
    required pw.Font ttfBold,
    required PdfColor titleColor,
    required PdfColor backgroundColor,
    required List<pw.Widget> children,
  }) {
    return pw.Container(
      padding: pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: backgroundColor,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(font: ttfBold, fontSize: 22, color: titleColor)),
          pw.SizedBox(height: 6),
          ...children,
        ],
      ),
    );
  }
// 📌 Key-Value Row Styling for PDF
  pw.Widget _buildDetailRow(
      String key, String value, pw.Font font, pw.Font fontBold, PdfColor color) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4), // Adjust spacing
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            key,
            style: pw.TextStyle(font: fontBold, fontSize: 16, color: color),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(font: font, fontSize: 16, color: color),
          ),
        ],
      ),
    );
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

  Future<void> _sharePdfViaNfc(BuildContext context, String? pdfPath) async {
    if (pdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF not generated yet')),
      );
      return;
    }

    Uint8List pdfBytes = await File(pdfPath).readAsBytes();

    NfcManager nfcManager = NfcManager.instance;
    bool isAvailable = await nfcManager.isAvailable();

    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('NFC is not available on this device')),
      );
      return;
    }

    nfcManager.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tag is not ndef writable')),
        );
        nfcManager.stopSession();
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createMime('application/pdf', pdfBytes),
      ]);

      try {
        await ndef.write(message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF shared successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share PDF: $e')),
        );
      } finally {
        nfcManager.stopSession();
      }
    });
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
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                }
            )
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    travelDetail.name,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
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
                        SizedBox(height: 10),
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
                                _buildPhotoViewButton(travelDetail),
                                IconButton(
                                  icon: Icon(Icons.photo_library, color: Colors.deepPurple),
                                  onPressed: () {
                                    if (travelDetail.imagePaths != null &&
                                        travelDetail.imagePaths!.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageViewerScreen(
                                            imagePaths: travelDetail.imagePaths!,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('No photos available.')),
                                      );
                                    }
                                  },
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
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: travelDetail.pdfPath == null
                                          ? () => _generatePDF(travelDetail.id!)
                                          : () => _viewPDF(travelDetail),
                                      child: Text(travelDetail.pdfPath == null ? "Generate PDF" : "View PDF"),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(150, 45),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => _openExpenseTracker(travelDetail),
                                      child: Text("Expense Tracker"),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(150, 45),
                                        backgroundColor: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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

