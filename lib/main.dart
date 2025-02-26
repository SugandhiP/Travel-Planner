import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:travel_planner_project/travel_details_provider.dart';
import 'data/populate_data.dart';
import 'database/database.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'itinerary/home_page.dart';

late AppDatabase database;
Future<void> deleteDatabaseFile() async {
  final dbPath = await getDatabasesPath();
  final filePath = join(dbPath, 'app_database.db');

  if (File(filePath).existsSync()) {
    await File(filePath).delete();
  }
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await deleteDatabaseFile();

  // Initialize the database
  database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .addMigrations([AppDatabase.migration1to2])
      .build();

  await populateDatabase(database);

  String dbPath = await getDatabasesPath();

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
      //home: ItinerariesHomePage(),
      home:const HomePage(),
    );
  }
}




