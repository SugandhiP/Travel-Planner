import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/itinerary/itineraries_home_page.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/travel_details_provider.dart';

void main() {
  testWidgets(
    'Test to add itinerary  , and checking if the delete button is working properly ',
        (WidgetTester tester) async {
      final mockProvider = TravelDetailsProvider("test_travel_id");
      mockProvider.addTravelDetails(
        TravelDetails(
          name: "Test Itinerary",
          source: "Germany",
          destination: "France",
          airline: "Alaska Airlines",
          flightNumber: "AA123",
          departureTime: "10:00 AM",
          arrivalTime: "1:00 PM",
          hotelName: "Radisson",
          selectedAttractions: [],
          isFavorite: false,
        ),
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<TravelDetailsProvider>.value(value: mockProvider),
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
    },
  );
}
