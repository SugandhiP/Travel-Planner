
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:travel_planner_project/travel_details_provider.dart';
import 'data/attraction_data.dart';
import 'data/populate_data.dart';
import 'database/database.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'itinerary/home_page.dart';
import 'model/attraction_details.dart';

late AppDatabase database;
Future<void> main() async {
  debugPrintGestureArenaDiagnostics = false; // Prevents rendering issues
  WidgetsFlutterBinding.ensureInitialized();

  final database = (await $FloorAppDatabase
      .databaseBuilder('app_database1.db')
      .addMigrations([AppDatabase.migration1to2, AppDatabase.migration2to3,AppDatabase.migration3to4, AppDatabase.migration4to5, AppDatabase.migration5to6]) // Access the static migration variable
      .build());

  await populateDatabase(database);

  String dbPath = await getDatabasesPath();
  print("Database Path: $dbPath/app_database1.db");

  final travelDetails = await database.travelDetailsDao.getAllTravelDetails();
  print("Database Entries: ${travelDetails.length}");

  //await populateAttractionDetails(database);

  runApp(
    ChangeNotifierProvider(
      create: (context) => TravelDetailsProvider('DEFAULT_TRAVEL_ID'),
      child: MyApp(database: database),
    ),
  );
}

// Future<void> populateAttractionDetails(AppDatabase database) async {
//   final attractionDetailsDao = database.attractionDetailsDao;
//   for (var entry in attractionDetailsMap.entries) {
//     final attractionName = entry.key;
//     final details = entry.value;
//     // You might want to add an ID or some unique identifier to link
//     // the AttractionDetails to the Attraction.
//     // Here, I'm assuming you'll add a field named 'attractionName' to
//     // AttractionDetails to store the attraction's name.
//     final attractionDetails = AttractionDetails(
//       openingHours: details.openingHours,
//       closingTime: details.closingTime,
//       officialWebsite: details.officialWebsite,
//     );
//     await attractionDetailsDao.insertAttractionDetails(attractionDetails);
//     print('Inserted details for $attractionName');
//   }
// }

class MyApp extends StatelessWidget {
  AppDatabase database;
  MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return Provider<AppDatabase>.value(
        value: database,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Travel Planner',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage(),
        )
    );
  }
}




