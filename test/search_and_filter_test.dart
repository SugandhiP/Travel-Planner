import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/itinerary/home_page.dart';
import 'package:travel_planner_project/model/destination.dart';
import 'package:travel_planner_project/travel_details_provider.dart';

void main() {
  group('HomePage Widget Tests', () {
    late TravelDetailsProvider mockProvider;

    setUp(() {
      mockProvider = TravelDetailsProvider('test_id');
      mockProvider.destinations.addAll([
        Destination(id: 1, name: 'Paris', country: 'France', imageUrl: 'https://example.com/paris.jpg', attractionsJson: '[]'), // Added attractionsJson
        Destination(id: 2, name: 'Tokyo', country: 'Japan', imageUrl: 'https://example.com/tokyo.jpg', attractionsJson: '[]'), // Added attractionsJson
      ]);
    });

    testWidgets('HomePage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<TravelDetailsProvider>.value(
            value: mockProvider,
            child: HomePage(),
          ),
        ),
      );

      expect(find.text('Travel Planner'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Search functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<TravelDetailsProvider>.value(
            value: mockProvider,
            child: HomePage(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'France');
      await tester.pump();

      expect(find.text('France'), findsOneWidget);
      expect(find.text('United'), findsNothing);
    });

    testWidgets('Destination cards are rendered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<TravelDetailsProvider>.value(
            value: mockProvider,
            child: HomePage(),
          ),
        ),
      );

      expect(find.byType(Card), findsNWidgets(2));
      expect(find.text('Paris'), findsOneWidget);
      expect(find.text('Tokyo'), findsOneWidget);
    });

    testWidgets('Bottom navigation buttons are present', (WidgetTester tester) async {
      final mockProvider = TravelDetailsProvider('test_id');

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<TravelDetailsProvider>.value(
            value: mockProvider,
            child: HomePage(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(Duration(seconds: 1));
      expect(find.text('New Itinerary'), findsOneWidget);
      expect(find.text('Your Itineraries'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(InkWell), findsAtLeastNWidgets(2));
    });


  });

}
