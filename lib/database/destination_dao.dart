import 'package:floor/floor.dart';
import '../model/destination.dart';

@dao
abstract class DestinationDao {
  @Query('SELECT * FROM Destination')
  Future<List<Destination>> getAllDestinations();

  @insert
  Future<int> insertDestination(Destination destination);
}
