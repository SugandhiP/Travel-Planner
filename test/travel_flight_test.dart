import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/database/database.dart';
import 'package:travel_planner_project/itinerary/itinerary_travel_details_page.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_planner_project/travel_details_provider.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  late TravelDetailsProvider provider;
  setUp(() {
    provider = TravelDetailsProvider("TEST_TRAVEL_ID");
  });

  testWidgets('Finding text fields in the itinerary form', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ItineraryTravelDetailsPage()));

    await tester.pumpAndSettle();

    expect(find.text("From (Source)"), findsOneWidget);
    expect(find.text("To (Destination)"), findsOneWidget);
    expect(find.text("Airline Name"), findsOneWidget);
    expect(find.text("Flight Number"), findsOneWidget);
    expect(find.text("Departure Date and Time"), findsOneWidget);
    expect(find.text("Arrival Date and Time"), findsOneWidget);
    expect(find.text("Hotel Name"), findsOneWidget);
    expect(find.text("Initial Budget(USD)"), findsOneWidget);
    expect(find.text("Trip Members"), findsOneWidget);

    await tester.tap(find.text("Save & Next"));
  });


  testWidgets('Entering form details and navigating successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: ItineraryTravelDetailsPage()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("United States").last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Germany").last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), "Alaska Airlines");
    await tester.enterText(find.byType(TextFormField).at(1), "AA123");
    await tester.enterText(find.byType(TextFormField).at(4), "Radisson Hotel");
    await tester.enterText(find.byType(TextFormField).at(5), "5000");
    await tester.enterText(find.byType(TextFormField).at(6), "5");

    await tester.pump();

    await tester.ensureVisible(find.text("Save & Next"));
    await tester.tap(find.text("Save & Next"));
    await tester.pumpAndSettle();
  });
}
