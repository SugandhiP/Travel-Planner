import 'package:floor/floor.dart';
import '../model/type_converters.dart';

@Entity(tableName: 'Expense')
class Expense {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String category;
  final double amount;
  final String note;
  final String travelDetailsId;

  @TypeConverters([DateTimeConverter])
  final DateTime date;

  Expense({
    this.id,
    required this.category,
    required this.amount,
    required this.note,
    required this.date,
    required this.travelDetailsId,
  });

  @override
  String toString() {
    return 'Expense{id: $id, category: $category, amount: $amount, note: $note, travelDetailsId: $travelDetailsId, date: $date}';
  }

  // Add a factory constructor to convert from JSON (Map<String, dynamic>)
  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'] as int?,
    category: json['category'] as String,
    amount: (json['amount'] as num).toDouble(),
    note: json['note'] as String,
    travelDetailsId: json['travelDetailsId'] as String,
    date: DateTime.parse(json['date'] as String), // Ensure date is parsed correctly
  );

  // Add a method to convert to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'amount': amount,
    'note': note,
    'travelDetailsId': travelDetailsId,
    'date': date.toIso8601String(), // Store date as ISO string
  };
}
