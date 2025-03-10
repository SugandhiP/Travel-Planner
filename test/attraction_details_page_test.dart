/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_planner_project/model/attraction.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travel_planner_project/itinerary/attraction_details_page.dart'; // Adjust with your actual import

class MockLaunchUrl extends Mock implements Uri {
  @override
  Future<bool> canLaunchUrl(Uri url) async {
    return true;
  }

  @override
  Future<void> launchUrl(Uri url) async {
    print("Launching URL: $url");
  }
}

void main() {
  testWidgets('AttractionDetailsPage has correct title and details', (WidgetTester tester) async {
    // Create a mock Attraction object for testing
    final attraction = Attraction(
      name: 'Test Attraction',
      country: 'Test Country',
      imageUrl: 'https://example.com/image.jpg',
      officialWebsite: 'https://officialwebsite.com',
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
    expect(find.widgetWithText(ElevatedButton, 'Visit Official Website'), findsOneWidget);
  });

  testWidgets('AttractionDetailsPage shows error dialog when URL cannot be launched', (WidgetTester tester) async {
    final attraction = Attraction(
      name: 'Test Attraction',
      country: 'Test Country',
      imageUrl: 'https://example.com/image.jpg',
      officialWebsite: 'https://invalidwebsite.com',
    );

    // Mock canLaunchUrl to return false (simulate a failed URL launch)
    final mockLauncher = MockLaunchUrl();
    when(mockLauncher.canLaunchUrl(any)).thenAnswer((_) async => false);

    await tester.pumpWidget(
      MaterialApp(
        home: AttractionDetailsPage(attraction: attraction),
      ),
    );

    // Tap the button to launch the website
    await tester.tap(find.widgetWithText(ElevatedButton, 'Visit Official Website'));
    await tester.pumpAndSettle();

    // Verify the error dialog is displayed
    expect(find.text("Could not open link"), findsOneWidget);
    expect(find.text("There was a problem opening the official website. Please try again later."), findsOneWidget);
  });

  testWidgets('AttractionDetailsPage opens official website when URL is valid', (WidgetTester tester) async {
    final attraction = Attraction(
      name: 'Test Attraction',
      country: 'Test Country',
      imageUrl: 'https://example.com/image.jpg',
      officialWebsite: 'https://officialwebsite.com',
    );

    // Mock canLaunchUrl to return true (simulate a successful URL launch)
    final mockLauncher = MockLaunchUrl();
    when(mockLauncher.canLaunchUrl(any)).thenAnswer((_) async => true);

    await tester.pumpWidget(
      MaterialApp(
        home: AttractionDetailsPage(attraction: attraction),
      ),
    );

    // Tap the button to launch the website
    await tester.tap(find.widgetWithText(ElevatedButton, 'Visit Official Website'));
    await tester.pumpAndSettle();

    // Verify that launchUrl was called with the correct URL
    verify(mockLauncher.launchUrl(Uri.parse('https://officialwebsite.com'))).called(1);
  });
}*/
