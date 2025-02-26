import 'package:floor/floor.dart';
import '../model/travel_details.dart';

@dao
abstract class TravelDetailsDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTravelDetail(TravelDetails travelDetail);

  @Update()
  Future<void> updateTravelDetail(TravelDetails travelDetail);

  @delete
  Future<void> deleteTravelDetail(TravelDetails travelDetail);

  @Query('SELECT * FROM TravelDetails WHERE name = :name')
  Future<TravelDetails?> getTravelDetailByName(String name);

  @Query('SELECT * FROM TravelDetails')
  Future<List<TravelDetails>> getAllTravelDetails();
}
