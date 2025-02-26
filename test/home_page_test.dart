import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_planner_project/database/database.dart';
import 'package:travel_planner_project/itinerary/itineraries_home_page.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/model/expense.dart';
import 'package:travel_planner_project/travel_details_provider.dart';
import 'package:travel_planner_project/database/database.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  testWidgets('Add itinerary and delete it successfully', (WidgetTester tester) async {
    final mockProvider = TravelDetailsProvider("test_travel_id");
    final mockDatabase = MockAppDatabase();

    final testItinerary = TravelDetails(
      name: "Test Itinerary",
      source: "Germany",
      destination: "France",
      airline: "Alaska Airlines",
      flightNumber: "AA123",
      departureTime: "10:00 AM",
      arrivalTime: "1:00 PM",
      hotelName: "Radisson",
      selectedAttractions: [],
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
      isFavorite: false,
    );
    mockProvider.addTravelDetails(testItinerary);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TravelDetailsProvider>.value(value: mockProvider),
          Provider<AppDatabase>.value(value: mockDatabase),
        ],
        child: MaterialApp(home: ItinerariesHomePage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Test Itinerary"), findsOneWidget);
    expect(find.text("France"), findsOneWidget);

    final deleteButton = find.byIcon(Icons.delete);
    expect(deleteButton, findsOneWidget);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    expect(find.text("Test Itinerary"), findsNothing);
    expect(find.text("France"), findsNothing);
  });
}
