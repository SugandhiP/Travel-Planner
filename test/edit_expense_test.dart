import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/expense_tracker/expense_tracker_page.dart';
import 'package:travel_planner_project/model/attraction.dart';
import 'package:travel_planner_project/model/destination.dart';
import 'package:travel_planner_project/model/expense.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import 'package:travel_planner_project/travel_details_provider.dart';

class FakeTravelDetailsProvider extends ChangeNotifier implements TravelDetailsProvider {
  List<Expense> _fakeExpenses = [];
  double _fakeBudget = 100.0;

  @override
  List<Expense> get expenses => _fakeExpenses;

  @override
  double get budget => _fakeBudget;

  void setFakeExpenses(List<Expense> expenses) {
    _fakeExpenses = expenses;
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
  Future<void> loadExpenses(String travelDetailsId) async {
    notifyListeners();
  }

  @override
  Future<void> addTravelDetails(TravelDetails travelDetail) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTravelDetails(TravelDetails travelDetail) {
    throw UnimplementedError();
  }

  @override
  List<Destination> get destinations => throw UnimplementedError();

  @override
  Future<void> fetchDestinations() {
    throw UnimplementedError();
  }

  @override
  Future<void> fetchTravelDetails() {
    throw UnimplementedError();
  }

  @override
  Future<Attraction?> getAttractionDetails(int attractionId) {
    throw UnimplementedError();
  }

  @override
  Future<void> initializeDatabase() {
    throw UnimplementedError();
  }

  @override
  Future<void> setTravelDetailsId(String travelDetailsId) {
    throw UnimplementedError();
  }

  @override
  List<TravelDetails> get travelDetail => throw UnimplementedError();

  @override
  Future<void> updateTravelDetails(TravelDetails travelDetail) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateTravelDetailsByTravelDetails(TravelDetails updatedTravelDetails) {
    throw UnimplementedError();
  }
}

void main() {
  group('ExpenseTrackerPage UI Tests', () {
    late TravelDetails travelDetails;
    late FakeTravelDetailsProvider fakeProvider;

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
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: ChangeNotifierProvider<TravelDetailsProvider>.value(
          value: fakeProvider,
          child: ExpenseTrackerPage(travelDetails: travelDetails),
        ),
      );
    }

    testWidgets('Editing an Expense works correctly', (WidgetTester tester) async {
      fakeProvider.setFakeExpenses([
        Expense(
          id: 1,
          category: 'Gas',
          amount: 20.0,
          note: 'Car',
          travelDetailsId: travelDetails.name,
          date: DateTime.now(),
        )
      ]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(Duration(milliseconds: 500));
      expect(find.byType(ListView), findsOneWidget);

      final Finder editButton = find.byIcon(Icons.edit);
      await tester.ensureVisible(editButton);
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pump(Duration(milliseconds: 500));
      expect(find.byType(AlertDialog), findsOneWidget);

      final Finder amountField = find.widgetWithText(TextFormField, 'Amount');
      await tester.enterText(amountField, '50.0');
      await tester.pump(Duration(milliseconds: 500));
      final Finder saveButton = find.widgetWithText(ElevatedButton, 'Save');
      await tester.tap(saveButton);
      await tester.pump(Duration(milliseconds: 500));
      expect(fakeProvider.expenses.first.amount, 50.0);
    });
  });
}

