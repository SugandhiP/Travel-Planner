import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/expense_tracker/expense_tracker_page.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/travel_details_provider.dart';

void main() {
  group('ExpenseTrackerPage UI Tests', () {
    late TravelDetails travelDetails;

    setUp(() {
      travelDetails = TravelDetails(
        id: 1,
        name: 'Test Trip',
        source: 'Source',
        destination: 'Destination',
        airline: 'Airline',
        flightNumber: '123',
        departureTime: '10:00',
        arrivalTime: '12:00',
        hotelName: 'Hotel',
        initialBudget: 100.0,
        tripMember: 2,
        selectedAttractions: [],
        isFavorite: false,
        expenses: [],
      );
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<TravelDetailsProvider>(
              create: (context) {
                final provider = TravelDetailsProvider(travelDetails.name);

                provider.initializeDatabase();

                provider.updateBudget(travelDetails.initialBudget);
                return provider;
              },
            ),
          ],
          child: ExpenseTrackerPage(travelDetails: travelDetails),
        ),
      );
    }

    testWidgets('checks the title in the Appbar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Expense Tracker'), findsOneWidget);
    });

    testWidgets('Initial Budget Display Exists', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.textContaining('Initial Budget:'), findsOneWidget);
    });

    testWidgets('checks Expense Button tested to tap it, and it opens dialog', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      final Finder fab = find.byIcon(Icons.add);
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('checks the Expense List', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('checks the Expense Summary ', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.textContaining('Total Expenses:'), findsOneWidget);
    });

    testWidgets('Tapping add expense FAB opens the ExpenseDialog with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AlertDialog, 'Add Expense'), findsOneWidget);
    });


    testWidgets('checks for the "Set Initial Budget" Button exists and also checks its tappable when budget is 0', (WidgetTester tester) async {
      travelDetails = travelDetails.copyWith(initialBudget: 0.0);
      await tester.pumpWidget(createWidgetUnderTest());

      final Finder setBudgetButton = find.text('Set Initial Budget');
      expect(setBudgetButton, findsOneWidget);

      await tester.tap(setBudgetButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('checks by Tapping "Set Initial Budget" shows _BudgetDialog with title', (WidgetTester tester) async {
      travelDetails = travelDetails.copyWith(initialBudget: 0.0);
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Set Initial Budget'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Set Initial Budget'), findsNWidgets(2));
    });

    testWidgets('checks by Tapping add expense  floating action button and  opens a dialog with category dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });

    testWidgets('checks by Tapping add expense floating action button and  opens a dialogue filed with amount text field', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Amount'), findsOneWidget);
    });

    testWidgets('checks the PieChart Exists in the expense tracker page', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(PieChart), findsOneWidget);
    });

    testWidgets('PieChartData has sections for different category', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      final pieChartFinder = find.byType(PieChart);
      expect(pieChartFinder, findsOneWidget);

      final PieChart pieChart = tester.widget(pieChartFinder);
      expect(pieChart.data, isNotNull);

    });

  });
}
