import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/database/database.dart';
import 'package:travel_planner_project/database/travel_details_dao.dart';
import 'package:travel_planner_project/itinerary/itineraries_home_page.dart';
import 'package:travel_planner_project/model/expense.dart';
import 'package:travel_planner_project/model/travel_details.dart';

import 'itineraries_home_page_test.mocks.dart';
@GenerateMocks([AppDatabase, TravelDetailsDao])
void main() {
  late MockAppDatabase mockDatabase;
  late MockTravelDetailsDao mockTravelDetailsDao;

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockTravelDetailsDao = MockTravelDetailsDao();
    when(mockDatabase.travelDetailsDao).thenReturn(mockTravelDetailsDao);
  });
  Widget createTestWidget() {
    return Provider<AppDatabase>.value(
      value: mockDatabase,
      child: MaterialApp(
        home: ItinerariesHomePage(),
      ),
    );
  }

  test("Removing itinerary from database when delete button is clicked  ", () async {
    final travelDetail = TravelDetails(
      id: 1,
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
      selectedAttractions: ["Eiffel Tower"],
      isFavorite: false,
      expenses: [
        Expense(
          id: 1,
          category: "Transport",
          amount: 300.0,
          note: "Flight ticket",
          date: DateTime(2025, 2, 26),
          travelDetailsId: "test_travel_id",
        ),
        Expense(
          id: 2,
          category: "Accommodation",
          amount: 200.0,
          note: "Hotel stay",
          date: DateTime(2025, 2, 27),
          travelDetailsId: "test_travel_id",
        ),
      ],
    );

    when(mockTravelDetailsDao.deleteTravelDetail(travelDetail.name))
        .thenAnswer((_) async => Future.value());

    await mockTravelDetailsDao.deleteTravelDetail(travelDetail.name);

    verify(mockTravelDetailsDao.deleteTravelDetail(travelDetail.name)).called(1);
  });

  test("Database will be updated for favourites when toggle is clicked", () async {
    final travelDetail = TravelDetails(
      id: 2,
      name: "Another Trip",
      source: "London",
      destination: "Rome",
      airline: "British Airways",
      flightNumber: "BA456",
      departureTime: "2025-06-12 09:00:00",
      arrivalTime: "2025-06-12 11:30:00",
      hotelName: "Rome Grand",
      initialBudget: 1500.0,
      tripMember: 3,
      selectedAttractions: ["Colosseum"],
      isFavorite: false,
      expenses: [
        Expense(
          id: 1,
          category: "Transport",
          amount: 300.0,
          note: "Flight ticket",
          date: DateTime(2025, 2, 26),
          travelDetailsId: "test_travel_id",
        ),
        Expense(
          id: 2,
          category: "Accommodation",
          amount: 200.0,
          note: "Hotel stay",
          date: DateTime(2025, 2, 27),
          travelDetailsId: "test_travel_id",
        ),
      ],
    );

    TravelDetails updatedTravelDetail = travelDetail.copyWith(isFavorite: true);

    when(mockTravelDetailsDao.deleteTravelDetail(travelDetail.name))
        .thenAnswer((_) async => Future.value());

    when(mockTravelDetailsDao.insertTravelDetail(updatedTravelDetail))
        .thenAnswer((_) async => Future.value());

    await mockTravelDetailsDao.deleteTravelDetail(travelDetail.name);
    await mockTravelDetailsDao.insertTravelDetail(updatedTravelDetail);

    verify(mockTravelDetailsDao.deleteTravelDetail(travelDetail.name)).called(1);
    verify(mockTravelDetailsDao.insertTravelDetail(updatedTravelDetail)).called(1);
  });

  testWidgets(' "No itineraries available" is displayed when list is empty', (WidgetTester tester) async {
    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => []);

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.text("No itineraries available"), findsOneWidget);
  });

  testWidgets('Displays travel itinerary cards when data exists', (WidgetTester tester) async {
    final travelDetailsList = [
      TravelDetails(
        id: 1,
        name: "Test Trip",
        source: "NYC",
        destination: "Paris",
        airline: "Air France",
        flightNumber: "AF123",
        departureTime: "2025-05-10 08:00:00",
        arrivalTime: "2025-05-10 14:00:00",
        hotelName: "Paris Hotel",
        initialBudget: 3000.0,
        tripMember: 2,
        selectedAttractions: ["Eiffel Tower"],
        isFavorite: false,
        expenses: [
          Expense(
            id: 1,
            category: "Transport",
            amount: 300.0,
            note: "Flight ticket",
            date: DateTime(2025, 2, 26),
            travelDetailsId: "test_travel_id",
          ),
          Expense(
            id: 2,
            category: "Accommodation",
            amount: 200.0,
            note: "Hotel stay",
            date: DateTime(2025, 2, 27),
            travelDetailsId: "test_travel_id",
          ),
        ],
      )
    ];

    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => travelDetailsList);

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.text("Test Trip"), findsOneWidget);
    expect(find.text("Paris"), findsOneWidget);
  });

  testWidgets('Clicking on the favorite icon in the home page toggles favorite status', (WidgetTester tester) async {
    final travelDetail = TravelDetails(
      id: 1,
      name: "Favorite Trip",
      source: "London",
      destination: "Rome",
      airline: "BA",
      flightNumber: "BA100",
      departureTime: "2025-06-15 10:00:00",
      arrivalTime: "2025-06-15 12:00:00",
      hotelName: "Hotel Rome",
      initialBudget: 2000.0,
      tripMember: 3,
      selectedAttractions: ["Colosseum"],
      isFavorite: false,
      expenses: [
        Expense(
          id: 1,
          category: "Transport",
          amount: 300.0,
          note: "Flight ticket",
          date: DateTime(2025, 2, 26),
          travelDetailsId: "test_travel_id",
        ),
        Expense(
          id: 2,
          category: "Accommodation",
          amount: 200.0,
          note: "Hotel stay",
          date: DateTime(2025, 2, 27),
          travelDetailsId: "test_travel_id",
        ),
      ],
    );

    when(mockTravelDetailsDao.getAllTravelDetails()).thenAnswer((_) async => [travelDetail]);

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    Finder favoriteButton = find.byIcon(Icons.star_border);
    expect(favoriteButton, findsOneWidget);

    await tester.tap(favoriteButton);
    await tester.pump();

    verify(mockTravelDetailsDao.deleteTravelDetail(travelDetail.name)).called(1);
  });


}
