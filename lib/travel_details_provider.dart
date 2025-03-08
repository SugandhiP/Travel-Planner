import 'dart:math';

import 'package:flutter/material.dart';
import 'package:travel_planner_project/database/attraction_dao.dart';
import '../database/database.dart';
import '../database/expense_dao.dart';
import '../model/destination.dart';
import '../model/expense.dart';
import '../model/travel_details.dart';
import 'database/destination_dao.dart';
import 'database/travel_details_dao.dart';
import 'main.dart';

class TravelDetailsProvider with ChangeNotifier {
  late AppDatabase _database;
  late ExpenseDao _expenseDao;
  late DestinationDao _destinationDao;
  late AttractionDao _attractionDao;
  late TravelDetailsDao _travelDetailsDao;

  List<Destination> _destinations = [];
  List<TravelDetails> _travelDetail = [];
  List<Expense> _expenses = []; // Private expenses list

  double _budget = 0.0;
  String _travelDetailsId = "DEFAULT_TRAVEL_ID";

  TravelDetailsProvider(String travelDetailsId) {
    _travelDetailsId = travelDetailsId;
    initializeDatabase();
  }

  //TravelDetailsProvider(_database);

  // Initialize database and load initial data
  Future<void> initializeDatabase() async {
    _database = await $FloorAppDatabase.databaseBuilder('app_database1.db').build();
    _expenseDao = _database.expenseDao;
    _destinationDao = _database.destinationDao;
    _attractionDao = _database.attractionDao;
    _travelDetailsDao = _database.travelDetailsDao;
    await fetchTravelDetails();
    await fetchDestinations();
    //await loadExpenses(); // Load initial expenses
  }

  List<Destination> get destinations => _destinations;
  List<TravelDetails> get travelDetail => _travelDetail;
  List<Expense> get expenses => _expenses; // Getter for expenses
  double get budget => _budget; // Getter for budget

  Future<void> fetchTravelDetails() async {
    _travelDetail = await _database.travelDetailsDao.getAllTravelDetails();
    print("Fetched Travel Details: $_travelDetail");
    notifyListeners(); // Triggers UI update
  }

  // Future<void> toggleFavorite(TravelDetails travelDetail) async {
  //   // final updatedTravelDetail = travelDetail.copyWith(isFavorite: !travelDetail.isFavorite);
  //   // await _database.travelDetailsDao.updateTravelDetail(updatedTravelDetail);
  //   // await fetchTravelDetails(); // Fetch new data and update UI
  //   _
  // }

  // Future<void> deleteItinerary(int id) async {
  //   await database.travelDetailsDao.deleteTravelDetail(id);
  //   await fetchTravelDetails(); // Refresh list after deletion
  // }

  // Initialize database and load expenses for a travel detail
  // Future<void> _initializeDatabase() async {
  //   _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //   _expenseDao = _database.expenseDao;
  //   await loadExpenses(); // Load initial expenses
  // }

  // Fetch destinations from database
  Future<void> fetchDestinations() async {
    _destinations = await _database.destinationDao.getAllDestinations();
    notifyListeners();
  }


  // Set a new travelDetailsId and load associated expenses
  Future<void> setTravelDetailsId(String travelDetailsId) async {
    _travelDetailsId = travelDetailsId;
    //await loadExpenses();
    notifyListeners();
  }

  // Add, update, and delete travel details
  Future<void> addTravelDetails(TravelDetails travelDetail) async {
    await _database.travelDetailsDao.insertTravelDetail(travelDetail);
    fetchTravelDetails();
  }

  Future<void> deleteTravelDetails(TravelDetails travelDetail) async {
    await _database.travelDetailsDao.deleteTravelDetail(travelDetail.name);
    fetchTravelDetails();
  }

  // Future<void> deleteTravelDetails(int index) async {
  //   _travelDetail.removeAt(index);
  //   notifyListeners();
  // }
  Future<void> updateTravelDetails(TravelDetails travelDetail) async {
    await _database.travelDetailsDao.updateTravelDetail(travelDetail);
    fetchTravelDetails(); // Refresh the list after updating the database
  }

  // Future<void> updateTravelDetails(int index, TravelDetails travelDetails) async {
  //   _travelDetail[index] = travelDetails;
  //   notifyListeners();
  // }

  Future<void> updateTravelDetailsByTravelDetails(TravelDetails updatedTravelDetails) async {
    final index = _travelDetail.indexWhere((td) => td.name == updatedTravelDetails.name);
    if (index != -1) {
      _travelDetail[index] = updatedTravelDetails;
      notifyListeners();
    }
  }

  // Method to load expenses from the database
  Future<void> loadExpenses(String travelDetailsId) async {
    _expenses = await _expenseDao.findExpensesByTravelDetailsId(travelDetailsId);
    notifyListeners();
  }

  // Method to add an expense to the database
  Future<void> addExpense(Expense expense) async {
    await _expenseDao.insertExpense(expense);
    await loadExpenses(expense.travelDetailsId); // Reload expenses from DB
  }

  // Method to delete an expense from the database
  Future<void> deleteExpense(Expense expense) async {
    await _expenseDao.deleteExpense(expense);
    await loadExpenses(expense.travelDetailsId); // Reload expenses from DB
  }

  // Method to update an expense
  Future<void> updateExpense(Expense expense) async {
    await _expenseDao.updateExpense(expense);
    await loadExpenses(expense.travelDetailsId); // Reload expenses from DB
  }


  // Method to update the budget value
  void updateBudget(double newBudget) {
    _budget = newBudget;
    notifyListeners();
  }
}
