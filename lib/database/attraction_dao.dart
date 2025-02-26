import 'package:floor/floor.dart';
import '../model/attraction.dart';

@dao
abstract class AttractionDao {
  @Query('SELECT * FROM Attraction WHERE destinationId = :destinationId')
  Future<List<Attraction>> getAttractionsForDestination(int destinationId);

  @insert
  Future<void> insertAttraction(Attraction attraction);
}
