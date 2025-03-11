import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_planner_project/model/attraction.dart';
import 'package:travel_planner_project/itinerary/attraction_details_page.dart'; // Adjust with your actual import


void main() {

  Future<void> _loadTestAssets() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Future.wait([
      rootBundle.load('assets/placeholder.png'),
      rootBundle.load('assets/image_error.png'),
    ]);
  }

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Load test assets
    await _loadTestAssets();
  });

  testWidgets('AttractionDetailsPage has correct title and details', (
      WidgetTester tester) async {
    // Create a mock Attraction object for testing
    final attraction = Attraction(
      name: 'Test Attraction',
      country: 'Test Country',
      imageUrl: 'https://example.com/image.jpg',
      destinationId: 1,
    );

    // Build the AttractionDetailsPage widget
    await tester.pumpWidget(
      MaterialApp(
        home: AttractionDetailsPage(attraction: attraction),
      ),
    );

    // Verify that the page has the correct title
    expect(find.text('Test Attraction'), findsOneWidget);
    expect(find.text('Country'), findsOneWidget);
    expect(find.text('Test Country'), findsOneWidget);
    expect(find.text('Opening Hours'), findsOneWidget);
    expect(find.text('Closing Time'), findsOneWidget);

    // Verify that the official website button is present
    //expect(find.widgetWithText(ElevatedButton, 'Visit Official Website'), findsOneWidget);
  });
}