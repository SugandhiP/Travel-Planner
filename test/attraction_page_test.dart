import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_planner_project/itinerary/attraction_page.dart';
import 'dart:convert';
import 'package:travel_planner_project/model/attraction.dart';
import 'package:travel_planner_project/model/destination.dart';

void main() {
  final attractionsList = [
    Attraction(
        name: 'Eiffel Tower',
        country: 'France',
        imageUrl: 'https://example.com/eiffel.jpg',
        destinationId: 1),
    Attraction(
        name: 'Louvre Museum',
        country: 'France',
        imageUrl: 'https://example.com/louvre.jpg',
        destinationId: 2),
    Attraction(
        name: 'Notre Dame',
        country: 'France',
        imageUrl: 'https://example.com/notredame.jpg',
        destinationId: 3),
  ];

  final attractionsJson = json.encode(attractionsList.map((a) => a.toJson()).toList());

  final testDestination = Destination(
    name: 'Paris',
    country: 'France',
    imageUrl: '',
    attractionsJson: attractionsJson,
  );

  testWidgets('Displays attraction name  and filter attraction based on search', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AttractionsPage(destination: testDestination),
      ),
    );
    expect(find.text('Paris'), findsOneWidget);

    expect(find.text('Eiffel Tower'), findsOneWidget);
    expect(find.text('Louvre Museum'), findsOneWidget);
    expect(find.text('Notre Dame'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Eiffel');
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Louvre');
    await tester.pumpAndSettle();

    expect(find.text('Louvre Museum'), findsOneWidget);
    expect(find.text('Eiffel Tower'), findsNothing);
    expect(find.text('Notre Dame'), findsNothing);

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pumpAndSettle();

    expect(find.text("No attractions match your search."), findsOneWidget);
    expect(find.text('Eiffel Tower'), findsNothing);
    expect(find.text('Louvre Museum'), findsNothing);
    expect(find.text('Notre Dame'), findsNothing);
  });
}
