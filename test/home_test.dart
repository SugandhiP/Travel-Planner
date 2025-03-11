import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/itinerary/home_page.dart';
import 'package:travel_planner_project/model/destination.dart';
import 'package:travel_planner_project/travel_details_provider.dart';
class MockTravelDetailsProvider extends TravelDetailsProvider {
  MockTravelDetailsProvider() : super("mock_value");

  @override
  List<Destination> get destinations => [
    Destination(name: "Paris", country: "France", imageUrl: "https://example.com/paris.jpg", attractionsJson: ''),
    Destination(name: "New", country: "USA", imageUrl: "https://example.com/ny.jpg", attractionsJson: ''),
  ];
}

void main() {
  late TravelDetailsProvider mockProvider;

  setUp(() {
    mockProvider = MockTravelDetailsProvider();
  });

  Widget createHomePage() {
    return ChangeNotifierProvider<TravelDetailsProvider>.value(
      value: mockProvider,
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }

  testWidgets("Displays the main UI elements", (WidgetTester tester) async {
    await tester.pumpWidget(createHomePage());
    expect(find.text("Travel Planner"), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text("Paris"), findsOneWidget);
    expect(find.text("New Itinerary"), findsOneWidget);
    expect(find.text("Your Itineraries"), findsOneWidget);
  });

  testWidgets("Filters destinations based on search query", (WidgetTester tester) async {
    await tester.pumpWidget(createHomePage());
    expect(find.text("France"), findsOneWidget);
    expect(find.text("USA"), findsOneWidget);
    await tester.enterText(find.byType(TextField), "Paris");
    await tester.pumpAndSettle();
    expect(find.text("France"), findsOneWidget);
    expect(find.text("USA"), findsNothing);
  });



  testWidgets("Displays the correct app bar title", (WidgetTester tester) async {
    await tester.pumpWidget(createHomePage());
    await tester.pumpAndSettle();
    expect(find.text("Travel Planner"), findsOneWidget);
  });

  testWidgets("Displays the search field", (WidgetTester tester) async {
    await tester.pumpWidget(createHomePage());
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets("Displays destination items", (WidgetTester tester) async {
    await tester.pumpWidget(createHomePage());
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsWidgets);
  });














}
