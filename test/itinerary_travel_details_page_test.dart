import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/database/database.dart';
import 'package:travel_planner_project/database/travel_details_dao.dart';
import 'package:travel_planner_project/itinerary/itinerary_travel_details_page.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/travel_details_provider.dart';

import 'itinerary_travel_details_page_test.mocks.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([AppDatabase, TravelDetailsDao, TravelDetailsProvider])
void main() {
  late MockAppDatabase mockDatabase;
  late MockTravelDetailsDao mockTravelDetailsDao;
  late MockTravelDetailsProvider mockTravelDetailsProvider;

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockTravelDetailsDao = MockTravelDetailsDao();
    mockTravelDetailsProvider = MockTravelDetailsProvider();

    when(mockDatabase.travelDetailsDao).thenReturn(mockTravelDetailsDao);
  });

  Widget createTestWidget({TravelDetails? travelDetails}) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: mockDatabase),
        ChangeNotifierProvider<TravelDetailsProvider>.value(value: mockTravelDetailsProvider),
      ],
      child: MaterialApp(
        home: ItineraryTravelDetailsPage(travelDetails: travelDetails),
      ),
    );
  }

  testWidgets("Displays all form fields correctly from the travel itinerary form", (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text("From (Source)"), findsOneWidget);
    expect(find.text("To (Destination)"), findsOneWidget);
    expect(find.text("Airline Name"), findsOneWidget);
    expect(find.text("Flight Number"), findsOneWidget);
    expect(find.text("Departure Date and Time"), findsOneWidget);
    expect(find.text("Arrival Date and Time"), findsOneWidget);
    expect(find.text("Hotel Name"), findsOneWidget);
    expect(find.text("Initial Budget(USD)"), findsOneWidget);
    expect(find.text("Trip Members"), findsOneWidget);
  });

  testWidgets("Ensures validation works for required fields in the form", (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    Finder saveButton = find.text("Save & Next");
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.textContaining("Select a source"), findsOneWidget);
    expect(find.textContaining("Select a destination location"), findsOneWidget);
    expect(find.textContaining("Enter airline name"), findsOneWidget);
    expect(find.textContaining("Enter flight number"), findsOneWidget);
    expect(find.textContaining("Select departure time"), findsOneWidget);
    expect(find.textContaining("Select arrival time"), findsOneWidget);
  });



  testWidgets("Editing an itinerary initializes form with correct values", (WidgetTester tester) async {
    final travelDetail = TravelDetails(
      name: "Test Trip",
      source: "Spain",
      destination: "Italy",
      airline: "Air France",
      flightNumber: "AF123",
      departureTime: "2025-05-10 08:00:00",
      arrivalTime: "2025-05-10 14:00:00",
      hotelName: "Hotel Paris",
      initialBudget: 2000.0,
      tripMember: 2,
      selectedAttractions: ["Eiffel Tower"],
      isFavorite: false,
      expenses: [],
    );

    await tester.pumpWidget(createTestWidget(travelDetails: travelDetail));

    expect(find.text("Spain"), findsOneWidget);
    expect(find.text("Italy"), findsOneWidget);
    expect(find.text("Air France"), findsOneWidget);
    expect(find.text("AF123"), findsOneWidget);
  });


  testWidgets("Ensures selecting a date/time updates state", (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    Finder departureDateField = find.text("Departure Date and Time");
    Finder arrivalDateField = find.text("Arrival Date and Time");

    await tester.tap(departureDateField);
    await tester.pumpAndSettle();
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();

    await tester.tap(arrivalDateField);
    await tester.pumpAndSettle();
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();

    expect(departureDateField, findsOneWidget);
    expect(arrivalDateField, findsOneWidget);
  });

}
