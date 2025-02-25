import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/itinerary/itineraries_home_page.dart';
import 'package:travel_planner_project/travel_details_provider.dart';
import 'database/database.dart';
import 'dart:async';

late AppDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .addMigrations([AppDatabase.migration1to2]) // Access the static migration variable
      .build();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TravelDetailsProvider("DEFAULT_TRAVEL_ID"),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItinerariesHomePage(),
    );
  }
}
