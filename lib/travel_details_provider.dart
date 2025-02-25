import 'package:flutter/material.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import '../database/database.dart';
import '../database/expense_dao.dart';
import '../model/expense.dart';

class TravelDetailsProvider with ChangeNotifier {
  final List<TravelDetails> _travelDetail = [];
  List<Expense> _expenses = []; // Private expenses list
  late AppDatabase _database;
  late ExpenseDao _expenseDao;
  double _budget = 0.0;
  String _travelDetailsId = "DEFAULT_TRAVEL_ID"; // Initialize with a default value

  TravelDetailsProvider(String travelDetailsId) {
    _travelDetailsId = travelDetailsId;
    _initializeDatabase();
  }

  // Initialize database and load expenses for a travel detail
  Future<void> _initializeDatabase() async {
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _expenseDao = _database.expenseDao;
    await loadExpenses(); // Load initial expenses
  }

  // Method to update the travelDetailsId and load expenses
  Future<void> setTravelDetailsId(String travelDetailsId) async {
    _travelDetailsId = travelDetailsId;
    await loadExpenses();
    notifyListeners();
  }

  List<TravelDetails> get travelDetail => _travelDetail;
  List<Expense> get expenses => _expenses; // Getter for expenses
  double get budget => _budget; // Getter for budget

  Future<void> addTravelDetails(TravelDetails travelDetails) async {
    _travelDetail.add(travelDetails);
    notifyListeners();
  }

  Future<void> deleteTravelDetails(int index) async {
    _travelDetail.removeAt(index);
    notifyListeners();
  }

  Future<void> updateTravelDetails(int index, TravelDetails travelDetails) async {
    _travelDetail[index] = travelDetails;
    notifyListeners();
  }

  Future<void> updateTravelDetailsByTravelDetails(TravelDetails updatedTravelDetails) async {
    final index = _travelDetail.indexWhere((td) => td.name == updatedTravelDetails.name);
    if (index != -1) {
      _travelDetail[index] = updatedTravelDetails;
      notifyListeners();
    }
  }

  // Load expenses from the database
  Future<void> loadExpenses() async {
    _expenses = await _expenseDao.findExpensesByTravelDetailsId(_travelDetailsId);
    notifyListeners();
  }

  // Add an expense and save it to the database
  Future<void> addExpense(Expense expense) async {
    await _expenseDao.insertExpense(expense);
    _expenses.add(expense);
    _budget -= expense.amount; // Deduct expense amount from budget
    await loadExpenses(); // Reload expenses to keep the list up-to-date
    notifyListeners();
  }

  // Delete an expense and remove it from the database
  Future<void> deleteExpense(Expense expense) async {
    await _expenseDao.deleteExpense(expense);
    _expenses.remove(expense); // Remove from the local list as well
    await loadExpenses(); // Reload expenses to keep the list up-to-date
    notifyListeners();
  }

  // Update an expense in both the local list and the database
  Future<void> updateExpense(Expense expense) async {
    await _expenseDao.updateExpense(expense);
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense; // Update in the local list
      await loadExpenses(); // Reload expenses to keep the list up-to-date
      notifyListeners();
    }
  }

  // Method to update the budget value
  void updateBudget(double newBudget) {
    _budget = newBudget;
    notifyListeners();
  }
}
