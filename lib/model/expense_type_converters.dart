import 'dart:convert';
import 'package:floor/floor.dart';
import 'expense.dart';

class ExpenseListConverter extends TypeConverter<List<Expense>, String> {
  @override
  List<Expense> decode(String databaseValue) {
    List<dynamic> jsonList = json.decode(databaseValue);
    return jsonList.map((e) => Expense.fromJson(e)).toList();
  }

  @override
  String encode(List<Expense> value) {
    return json.encode(value.map((e) => e.toJson()).toList());
  }
}
