import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/expense_tracker/expense_tracker_page.dart';
import 'package:travel_planner_project/model/attraction.dart';
import 'package:travel_planner_project/model/destination.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/model/expense.dart';
import 'package:travel_planner_project/travel_details_provider.dart';
class FakeTravelDetailsProvider extends ChangeNotifier implements TravelDetailsProvider {
  List<Expense> _fakeExpenses = [];
  double _fakeBudget = 100.0;
  List<Destination> _destinations = [];

  @override
  List<Expense> get expenses => _fakeExpenses;

  @override
  double get budget => _fakeBudget;

  @override
  List<Destination> get destinations => _destinations;

  void setFakeExpenses(List<Expense> expenses) {
    _fakeExpenses = expenses;
    notifyListeners();
  }

  void setFakeBudget(double budget) {
    _fakeBudget = budget;
    notifyListeners();
  }

  @override
  Future<void> addExpense(Expense expense) async {
    _fakeExpenses.add(expense);
    notifyListeners();
  }

  @override
  Future<void> deleteExpense(Expense expense) async {
    _fakeExpenses.removeWhere((e) => e.id == expense.id);
    notifyListeners();
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    int index = _fakeExpenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _fakeExpenses[index] = expense;
    }
    notifyListeners();
  }

  @override
  Future<void> updateBudget(double newBudget) async {
    _fakeBudget = newBudget;
    notifyListeners();
  }
  @override
  Future<void> fetchTravelDetails() async {}

  @override
  Future<void> fetchDestinations() async {}

  @override
  Future<void> loadExpenses(String travelDetailsId) async {}

  @override
  Future<void> addTravelDetails(TravelDetails travelDetail) async {}

  @override
  Future<void> deleteTravelDetails(TravelDetails travelDetail) async {}

  @override
  Future<void> updateTravelDetails(TravelDetails travelDetail) async {}

  @override
  Future<void> setTravelDetailsId(String travelDetailsId) async {}

  @override
  Future<void> updateTravelDetailsByTravelDetails(TravelDetails updatedTravelDetails) async {}

  @override
  Future<Attraction?> getAttractionDetails(int attractionId) async {
    return null;
  }

  @override
  Future<void> initializeDatabase() async {}

  @override
  List<TravelDetails> get travelDetail => throw UnimplementedError();
}

void main() {
  group('ExpenseTrackerPage UI Tests', () {
    late TravelDetails travelDetails;
    late FakeTravelDetailsProvider fakeProvider;
    late Expense testExpense;

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

      fakeProvider = FakeTravelDetailsProvider();
      testExpense = Expense(
        id: 1,
        category: 'Food',
        amount: 20.0,
        note: 'Lunch',
        travelDetailsId: travelDetails.name,
        date: DateTime.now(),
      );
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: ChangeNotifierProvider<TravelDetailsProvider>.value(
          value: fakeProvider,
          child: ExpenseTrackerPage(travelDetails: travelDetails),
        ),
      );
    }

    testWidgets('Title in Appbar is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Expense Tracker'), findsOneWidget);
    });

    testWidgets('Initial Budget Display Exists', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.textContaining('Initial Budget:'), findsOneWidget);
    });

    testWidgets('Expense Button opens dialog on tap', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Expense List is displayed when there are expenses', (WidgetTester tester) async {
      fakeProvider.setFakeExpenses([testExpense]);
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Deleting an Expense works correctly', (WidgetTester tester) async {
      fakeProvider.setFakeExpenses([testExpense]);
      await tester.pumpWidget(createWidgetUnderTest());

      final deleteButton = find.byIcon(Icons.delete);
      expect(deleteButton, findsOneWidget);

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      expect(fakeProvider.expenses.isEmpty, true);
    });


    testWidgets('Expense Summary correctly updates when budget is exceeded', (WidgetTester tester) async {
      fakeProvider.setFakeExpenses([
        Expense(
          id: 2,
          category: 'Shopping',
          amount: 150.0,
          note: 'Clothes',
          travelDetailsId: travelDetails.name,
          date: DateTime.now(),
        ),
      ]);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('You have exceeded your budget!'), findsOneWidget);
    });

    testWidgets('Expense Summary shows within budget message correctly', (WidgetTester tester) async {
      fakeProvider.setFakeExpenses([
        Expense(
          id: 3,
          category: 'Snacks',
          amount: 30.0,
          note: 'Chips and coffee',
          travelDetailsId: travelDetails.name,
          date: DateTime.now(),
        ),
      ]);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('Great job staying within budget!'), findsOneWidget);
    });
  });




}
