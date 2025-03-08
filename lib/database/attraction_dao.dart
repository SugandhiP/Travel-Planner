import 'package:floor/floor.dart';
import '../model/attraction.dart';

@dao
abstract class AttractionDao {
  @Query('SELECT * FROM Attraction WHERE destinationId = :destinationId')
  Future<List<Attraction>> getAttractionsForDestination(int destinationId);

  @Query('SELECT * FROM Attraction WHERE id = :id')
  Future<Attraction?> getAttractionById(int id);

  @insert
  Future<void> insertAttraction(Attraction attraction);

  @Query('SELECT * FROM Attraction WHERE name = :name')
  Future<Attraction?> getAttractionByName(String name);


}
