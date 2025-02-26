
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:travel_planner_project/itinerary/itineraries_home_page.dart';
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
  //await deleteDatabaseFile();

  // Initialize the database
  final database = (await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .addMigrations([AppDatabase.migration1to2, AppDatabase.migration2to3]) // Access the static migration variable
      .build());

  await populateDatabase(database);

  String dbPath = await getDatabasesPath();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TravelDetailsProvider("DEFAULT_TRAVEL_ID"),
      child: MyApp(database: database),
    ),
  );
}

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
          //home: ItinerariesHomePage(),
          home: HomePage(),
        )
    );
  }
}




