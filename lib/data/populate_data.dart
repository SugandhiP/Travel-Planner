import 'dart:convert';
import '../database/database.dart';
import '../model/attraction.dart';
import '../model/destination.dart';

Future<void> populateDatabase(AppDatabase database) async {
  final destinationDao = database.destinationDao;
  final attractionDao = database.attractionDao;

  final existingDestinations = await destinationDao.getAllDestinations();
  if (existingDestinations.isNotEmpty) {
    print("Database already populated. Skipping insertion.");
    return;
  }

  List<Map<String, dynamic>> destinationData = [
    {
      "name": "United States",
      "country": "USA",
      "imageUrl": "https://www.aaronreedphotography.com/images/xl/On-Earth-As-It-Is-In-Heaven-Web2020.jpg",
      "attractions": [
        {"name": "Statue of Liberty", "country": "USA", "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Statue_of_Liberty%2C_NY.jpg/1280px-Statue_of_Liberty%2C_NY.jpg"},
        {"name": "Grand Canyon", "country": "USA", "imageUrl": "https://images.pexels.com/photos/20879885/pexels-photo-20879885/free-photo-of-grand-canyon-national-park.jpeg"}
      ]
    },
    {
      "name": "France",
      "country": "France",
      "imageUrl": "https://thumbs.dreamstime.com/b/paris-eiffel-tower-river-seine-sunset-france-one-most-iconic-landmarks-107376702.jpg",
      "attractions": [
        {"name": "Eiffel Tower", "country": "France", "imageUrl": "https://t4.ftcdn.net/jpg/04/06/66/89/360_F_406668973_3X2cGom7KOgKaLfH7Fyjw7nnUegRlunf.jpg"},
        {"name": "Louvre Museum", "country": "France", "imageUrl": "https://images.pexels.com/photos/2363/france-landmark-lights-night.jpg?cs=srgb&dl=pexels-pixabay-2363.jpg&fm=jpg"}
      ]
    },
    {
      "name": "Japan",
      "country": "Japan",
      "imageUrl": "https://miro.medium.com/v2/resize:fit:10944/1*0_uoTq5jiN1o9hwwWPXOCQ.jpeg",
      "attractions": [
        {"name": "Mount Fuji", "country": "Japan", "imageUrl": "https://static.vecteezy.com/system/resources/thumbnails/038/998/460/small_2x/ai-generated-mt-fuji-mount-fuji-san-tallest-volcano-mountain-in-tokyo-japan-snow-capped-peak-conical-sacred-symbol-purple-orange-sunset-nature-landscape-backdrop-background-wallpaper-travel-photo.jpg"},
        {"name": "Tokyo Tower", "country": "Japan", "imageUrl": "https://t3.ftcdn.net/jpg/00/83/45/28/360_F_83452854_Epa5N806VaHrsnr5oBhUYVSEIqWqJGfO.jpg"}
      ]
    },
    {
      "name": "Italy",
      "country": "Italy",
      "imageUrl": "https://st.depositphotos.com/1007970/1223/i/450/depositphotos_12237433-stock-photo-venice-view-of-grand-canal.jpg",
      "attractions": [
        {"name": "Colosseum", "country": "Italy", "imageUrl": "https://images.pexels.com/photos/1797161/pexels-photo-1797161.jpeg"},
        {"name": "Venice Canals", "country": "Italy", "imageUrl": "https://t3.ftcdn.net/jpg/00/23/62/66/360_F_23626684_te03YBWPisYNxZTizWtJg1u0JeDGjC1S.jpg"}
      ]
    },
    {
      "name": "Australia",
      "country": "Australia",
      "imageUrl": "https://images.squarespace-cdn.com/content/v1/55cb4361e4b08dc9aca88339/1446719036707-P0DDK554G4WOCLENXLH4/image-asset.jpeg",
      "attractions": [
        {"name": "Sydney Opera House", "country": "Australia", "imageUrl": "https://static.vecteezy.com/system/resources/previews/001/435/804/large_2x/sydney-australia-2020-long-exposure-of-the-opera-house-in-sydney-free-photo.jpeg"},
        {"name": "Great Barrier Reef", "country": "Australia", "imageUrl": "https://www.thewanderinglens.com/wp-content/uploads/2014/08/DSC_2603edit.jpg"}
      ]
    },
    {
      "name": "Brazil",
      "country": "Brazil",
      "imageUrl": "https://res.cloudinary.com/enchanting/q_70,f_auto,c_lfill,g_auto/exodus-web/2022/07/Iguassu-Falls_627723601.jpeg",
      "attractions": [
        {"name": "Christ the Redeemer", "country": "Brazil", "imageUrl": "https://images.pexels.com/photos/9977483/pexels-photo-9977483.jpeg"},
        {"name": "Amazon Rainforest", "country": "Brazil", "imageUrl": "https://earth.org/wp-content/uploads/2021/07/35073192954_792375b9fa_b-1200x796.jpeg"}
      ]
    },
    {
      "name": "United Kingdom",
      "country": "UK",
      "imageUrl": "https://t4.ftcdn.net/jpg/01/08/47/29/360_F_108472954_A3Y42CvYf3GLzKKb5CJjVxuoal8TLE9M.jpg",
      "attractions": [
        {"name": "Big Ben", "country": "UK", "imageUrl": "https://thumbs.dreamstime.com/b/big-ben-london-autumn-leaves-32915756.jpg"},
        {"name": "Stonehenge", "country": "UK", "imageUrl": "https://images.pexels.com/photos/1448136/pexels-photo-1448136.jpeg?cs=srgb&dl=pexels-johnnoibn-1448136.jpg&fm=jpg"}
      ]
    }
  ];


  for (var destinationMap in destinationData) {
    String attractionsJson = json.encode(destinationMap["attractions"]);

    final destination = Destination(
      name: destinationMap["name"],
      country: destinationMap["country"],
      imageUrl: destinationMap["imageUrl"],
      attractionsJson: attractionsJson,
    );
    int destinationId = await destinationDao.insertDestination(destination);

    List<Attraction> attractions = (destinationMap["attractions"] as List<dynamic>)
        .map((a) => Attraction(
      name: a["name"],
      country: a["country"],
      imageUrl: a["imageUrl"],
      destinationId: destinationId,
    ))
        .toList();

    for (var attraction in attractions) {
      await attractionDao.insertAttraction(attraction);
    }
  }


}

