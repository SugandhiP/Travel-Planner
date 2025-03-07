import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:travel_planner_project/database/travel_details_dao.dart';
import 'package:travel_planner_project/model/expense.dart';
import '../model/attraction.dart';
import '../model/destination.dart';
import '../model/expense_type_converters.dart';
import '../model/string_type_converters.dart';
import '../model/travel_details.dart';
import '../model/type_converters.dart';
import 'attraction_dao.dart';
import 'destination_dao.dart';
import 'expense_dao.dart';

part 'database.g.dart';

@Database(version: 4, entities: [Expense,Destination, Attraction, TravelDetails]) // Increment the version
@TypeConverters([
  ExpenseListConverter,
  DateTimeConverter,
  StringListConverter
])
abstract class AppDatabase extends FloorDatabase {
  ExpenseDao get expenseDao;
  DestinationDao get destinationDao;
  AttractionDao get attractionDao;
  TravelDetailsDao get travelDetailsDao;

 static final migration1to2 = Migration(1, 2, (database) async {
  await database.execute('ALTER TABLE Expense ADD COLUMN travelDetailsId TEXT NOT NULL DEFAULT \'\''); // Change type to TEXT and add default value
 });

  static final Migration migration2to3 = Migration(2, 3, (database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS `TravelDetails` (`name` TEXT PRIMARY KEY AUTOINCREMENT NOT NULL,'
        ' `source` TEXT NOT NULL, `destination` TEXT NOT NULL, `airline` TEXT NOT NULL,'
        ' `flightNumber` TEXT NOT NULL, `departureTime` TEXT NOT NULL, `arrivalTime` TEXT NOT NULL,'
        ' `hotelName` TEXT NOT NULL, `initialBudget` REAL NOT NULL, `tripMember` INTEGER NOT NULL,'
        ' `isFavorite` INTEGER NOT NULL, `selectedAttractions` TEXT NOT NULL, `expenses` TEXT NOT NULL)');
  });

  static final Migration migration3to4 = Migration(3, 4, (database) async {
    await database.execute(
        'ALTER TABLE TravelDetails ADD COLUMN pdfPath TEXT'
    );
  });
}
