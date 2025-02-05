import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner_project/itinerary_travel_details.dart';
import 'package:travel_planner_project/next_page.dart';

void main() {
  testWidgets('Finding text fields in the itinerary form', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TravelForm()));


    await tester.pumpAndSettle();

    expect(find.text("From (Source)"), findsOneWidget);
    expect(find.text("To (Destination)"), findsOneWidget);
    expect(find.text("Airline Name"), findsOneWidget);
    expect(find.text("Flight Number"), findsOneWidget);
    expect(find.text("Departure Time"), findsOneWidget);
    expect(find.text("Arrival Time"), findsOneWidget);
    expect(find.text("Hotel Name"), findsOneWidget);

    await tester.tap(find.text("Save & Next"));
  });


  testWidgets('Entering the details in the form and testing until successful navigation to next page ', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TravelForm()));

    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("United States").last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Germany").last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), "Alaska Airlines");
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).at(1), "AA123");
    await tester.pump();


    await tester.tap(find.byType(TextFormField).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();


    await tester.tap(find.byType(TextFormField).at(3));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(4), "Radisson Hotel");
    await tester.pump();

    await tester.ensureVisible(find.text("Save & Next"));
    await tester.tap(find.text("Save & Next"));
    await tester.pumpAndSettle();

    expect(find.byType(NextPage), findsOneWidget);
  });
}
