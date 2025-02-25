import 'package:floor/floor.dart';
import 'package:travel_planner_project/model/expense.dart';

@dao
abstract class ExpenseDao {
  @Query('SELECT * FROM Expense')
  Future<List<Expense>> findAllExpenses();

  @Query('SELECT * FROM Expense WHERE id = :id')
  Stream<Expense?> findExpenseById(int id);

  @Query('SELECT * FROM Expense WHERE travelDetailsId = :travelDetailsId')
  Future<List<Expense>> findExpensesByTravelDetailsId(String travelDetailsId);

  @insert
  Future<void> insertExpense(Expense expense);

  @update
  Future<void> updateExpense(Expense expense);

  @delete
  Future<void> deleteExpense(Expense expense);
}
