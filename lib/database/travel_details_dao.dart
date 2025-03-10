import 'package:floor/floor.dart';
import '../model/travel_details.dart';
import '../model/string_type_converters.dart';


@TypeConverters([StringListConverter])
@dao
abstract class TravelDetailsDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTravelDetail(TravelDetails travelDetail);

  @Update()
  Future<void> updateTravelDetail(TravelDetails travelDetail);

  @Query('DELETE FROM TravelDetails WHERE name = :name')
  Future<void> deleteTravelDetail(String name);

  @Query('SELECT * FROM TravelDetails WHERE name = :name')
  Future<TravelDetails?> getTravelDetailByName(String name);

  @Query('SELECT * FROM TravelDetails')
  Future<List<TravelDetails>> getAllTravelDetails();

  @Query('SELECT * FROM TravelDetails WHERE id = :id')
  Future<TravelDetails?> getTravelDetailById(int id);


  @Query('''
    UPDATE TravelDetails 
    SET imagePaths = :imagePaths 
    WHERE id = :id
  ''')
  Future<void> updateImagePaths(int id, String imagePaths);
}


