import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/itinerary/itineraries_data_recorded_page.dart';
import 'package:travel_planner_project/travel_details_provider.dart';

void main() {
  testWidgets('ItinerariesDataRecordedPage displays correct data', (WidgetTester tester) async {
    // Sample travel details
    final travelDetails = TravelDetails(
      name: 'Test Trip',
      source: 'New York',
      destination: 'France',
      airline: 'Test Airline',
      flightNumber: 'TA123',
      departureTime: '2025-02-08 10:00',
      arrivalTime: '2025-02-08 22:00',
      hotelName: 'Test Hotel',
      initialBudget: 1000.0,
      tripMember: 2,
      selectedAttractions: ['Eiffel Tower', 'Louvre Museum'],
      isFavorite: false,
    );

    // Render the page inside a MaterialApp
    await tester.pumpWidget(MaterialApp(
      home: ItinerariesDataRecordedPage(travelDetails: travelDetails),
    ));

    // Wait for animations to settle
    await tester.pumpAndSettle();

    // Print all text widgets to debug missing text
    debugPrint(find.byType(Text).evaluate().map((e) => (e.widget as Text).data).join("\n"));

    // Verify that expected data is displayed
    expect(find.text('New York'), findsOneWidget);
    expect(find.text('France'), findsOneWidget);
    expect(find.text('Test Airline'), findsOneWidget);
    expect(find.text('TA123'), findsOneWidget);
    expect(find.text('2025-02-08 10:00'), findsOneWidget);
    expect(find.text('2025-02-08 22:00'), findsOneWidget);
    expect(find.text('1000.0'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // Scroll to ensure attractions are visible
    await tester.dragUntilVisible(
      find.textContaining('Eiffel Tower'),
      find.byType(Scrollable),
      const Offset(0, -100),
    );

    // Verify attractions are displayed
    expect(find.text('Eiffel Tower'), findsOneWidget);
    expect(find.text('Louvre Museum'), findsOneWidget);

    // Verify button text
    expect(find.textContaining('Save your Itinerary'), findsOneWidget);
  });






  //Testing for viewing the sample data when the view button is clicked
  testWidgets('ItinerariesDataRecordedPage handles viewing mode correctly', (WidgetTester tester) async {
    final travelDetails = TravelDetails(
      name: 'Test Trip',
      source: 'New York',
      destination: 'France',
      airline: 'Test Airline',
      flightNumber: 'TA123',
      departureTime: '2025-02-08 10:00',
      arrivalTime: '2025-02-08 22:00',
      hotelName: 'Test Hotel',
      initialBudget: 1000.0,
      tripMember: 2,
      selectedAttractions: ['Eiffel Tower', 'Louvre Museum'],
      isFavorite: false,
    );

    await tester.pumpWidget(MaterialApp(
      home: ItinerariesDataRecordedPage(travelDetails: travelDetails, isViewing: true),
    ));

    await tester.pumpAndSettle();

/*checks the 'back to home page button' when this is page opened through view button,
 and also checks for 'save itinerary button' gets disabled*/
    expect(find.text('Back to Home Page'), findsOneWidget);
    expect(find.text('Save your Itinerary'), findsNothing);
  });
}
