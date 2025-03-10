import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/database/database.dart';
import 'package:travel_planner_project/database/travel_details_dao.dart';
import 'package:travel_planner_project/itinerary/save_itinerary.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/itinerary/itineraries_home_page.dart';

import 'save_itinerary_page_test.mocks.dart';

@GenerateMocks([AppDatabase, TravelDetailsDao])
void main() {
  late MockAppDatabase mockDatabase;
  late MockTravelDetailsDao mockTravelDetailsDao;
  late TravelDetails testTravelDetails;

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockTravelDetailsDao = MockTravelDetailsDao();

    when(mockDatabase.travelDetailsDao).thenReturn(mockTravelDetailsDao);

    testTravelDetails = TravelDetails(
      name: "Test Trip",
      source: "New York",
      destination: "Paris",
      airline: "Air France",
      flightNumber: "AF123",
      departureTime: "2025-05-10 08:00:00",
      arrivalTime: "2025-05-10 14:00:00",
      hotelName: "Hotel Paris",
      initialBudget: 2000.0,
      tripMember: 2,
      selectedAttractions: [],
      isFavorite: false,
      expenses: [],
    );

    when(mockTravelDetailsDao.insertTravelDetail(testTravelDetails))
        .thenAnswer((_) async {});
    when(mockTravelDetailsDao.getAllTravelDetails())
        .thenAnswer((_) async => []);
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: mockDatabase),
      ],
      child: MaterialApp(
        home: SaveItinerary(travelDetails: testTravelDetails),
      ),
    );
  }

  testWidgets("Clicking on OK button saves itinerary ", (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.byType(TextField), "My Paris Trip");

    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();

    verify(mockTravelDetailsDao.insertTravelDetail(testTravelDetails)).called(1);
    verify(mockTravelDetailsDao.getAllTravelDetails()).called(1);
    expect(find.byType(ItinerariesHomePage), findsOneWidget);
  });
}
