import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:travel_planner_project/model/expense.dart';
import '../model/attraction.dart';
import '../model/destination.dart';
import '../model/type_converters.dart';
import 'attraction_dao.dart';
import 'destination_dao.dart';
import 'expense_dao.dart';

part 'database.g.dart';

@Database(version: 2, entities: [Expense,Destination, Attraction]) // Increment the version
@TypeConverters([DateTimeConverter])
abstract class AppDatabase extends FloorDatabase {
  ExpenseDao get expenseDao;
  DestinationDao get destinationDao;
  AttractionDao get attractionDao;

  static final migration1to2 = Migration(1, 2, (database) async {
    await database.execute('ALTER TABLE Expense ADD COLUMN travelDetailsId TEXT NOT NULL DEFAULT \'\''); // Change type to TEXT and add default value

  });


}
