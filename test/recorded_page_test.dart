import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/itineraries_data_recorded_page.dart';

void main() {
  //Test for displaying the correct sample data
  testWidgets('ItinerariesDataRecordedPage displays correct data', (WidgetTester tester) async {
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
      home: ItinerariesDataRecordedPage(travelDetails: travelDetails),
    ));

    await tester.pumpAndSettle();

    expect(find.text('New York'), findsOneWidget);
    expect(find.text('France'), findsOneWidget);
    expect(find.text('Test Airline'), findsOneWidget);
    expect(find.text('TA123'), findsOneWidget);
    expect(find.text('2025-02-08 10:00'), findsOneWidget);
    expect(find.text('2025-02-08 22:00'), findsOneWidget);
    expect(find.text('1000.0'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Test Hotel'), findsOneWidget);


    await tester.dragUntilVisible(
      find.text('Eiffel Tower'),
      find.byType(ListView),
      const Offset(0, -100),
    );
//scrolls down and check for the 'Eiffel Tower' in the list
    expect(find.text('Eiffel Tower'), findsOneWidget);
//checks for save button
    expect(find.text('Save your Itinerary'), findsOneWidget);
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
