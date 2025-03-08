import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner_project/model/travel_details.dart';
import '../model/expense.dart';
import '../travel_details_provider.dart';

class ExpenseTrackerPage extends StatelessWidget {
  final TravelDetails travelDetails;

  const ExpenseTrackerPage({Key? key, required this.travelDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load expenses when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TravelDetailsProvider>(context, listen: false)
          .loadExpenses(travelDetails.name); // Fetch expenses from DB
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildBudgetSection(travelDetails, context),
            Expanded(child: _buildExpenseList(context)),
            _buildExpenseSummary(travelDetails, context),
            Expanded(child: _buildChart(context)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addExpense(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  Widget _buildBudgetSection(TravelDetails td, BuildContext context) {
    //final travelDetailsProvider = Provider.of<TravelDetailsProvider>(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Initial Budget: \$${travelDetails.initialBudget.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (travelDetails.initialBudget == 0.0)
              ElevatedButton(
                onPressed: () => _setBudget(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Set Initial Budget',
                    style: TextStyle(fontSize: 16)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseList(BuildContext context) {
    return Consumer<TravelDetailsProvider>(
      builder: (context, travelDetailsProvider, child) {
        return ListView.builder(
          itemCount: travelDetailsProvider.expenses.length,
          itemBuilder: (context, index) {
            final expense = travelDetailsProvider.expenses[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                leading: const Icon(Icons.monetization_on, color: Colors.green),
                title: Text(expense.category,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(expense.note),
                    Text(
                      DateFormat('yyyy-MM-dd – kk:mm').format(expense.date),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editExpense(context, expense), //Edit expense
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteExpense(context, expense),
                      ),
                    ]
                ),
              ),
            );
          },
        );
      },
    );
  }
  Future<void> _deleteExpense(BuildContext context, Expense expense) async {
    await Provider.of<TravelDetailsProvider>(context, listen: false).deleteExpense(expense);
  }

  Widget _buildExpenseSummary(TravelDetails travelDetail, BuildContext context) {
    final travelDetailsProvider = Provider.of<TravelDetailsProvider>(context);

    // Fetch the total expenses
    final total = travelDetailsProvider.expenses
        .fold(0.0, (sum, expense) => sum + expense.amount);

    // Fetch the current budget
    final budget = travelDetail.initialBudget;

    // Check if the total is over the budget
    final isOverBudget = total > budget;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Expenses: \$${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isOverBudget ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            if (isOverBudget)
              const Text(
                'You have exceeded your budget!',
                style: TextStyle(color: Colors.red, fontSize: 16),
              )
            else
              const Text(
                'Great job staying within budget!',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _getCategoryTotals(List<Expense> expenses) {
    Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals.update(
        expense.category,
            (existingValue) => existingValue + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return categoryTotals;
  }

  Widget _buildChart(BuildContext context) {
    final travelDetailsProvider = Provider.of<TravelDetailsProvider>(context);
    final categoryTotals = _getCategoryTotals(travelDetailsProvider.expenses);
    List<PieChartSectionData> chartData = categoryTotals.entries.map((entry) {
      return PieChartSectionData(
        color: _getColorForCategory(entry.key),
        value: entry.value,
        title: '\$${entry.value.toStringAsFixed(2)}',
        radius: 50,
        titleStyle:
        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: chartData,
        centerSpaceRadius: 40,
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Attraction Ticket':
        return Colors.blue;
      case 'Gas':
        return Colors.orange;
      case 'Dining':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _setBudget(BuildContext context) async {
    final result = await showDialog<double>(
      context: context,
      builder: (context) => const _BudgetDialog(),
    );

    if (result != null) {
      Provider.of<TravelDetailsProvider>(context, listen: false).updateBudget(result);
    }
  }

  void _addExpense(BuildContext context) async {
    final result = await showDialog<Expense>(
      context: context,
      builder: (context) => _ExpenseDialog(travelDetails: travelDetails,),
    );

    if (result != null) {
      final expense = Expense(
        category: result.category,
        amount: result.amount,
        note: result.note,
        travelDetailsId: travelDetails.name, // Set the travelDetailsId
        date: DateTime.now(),
      );
      Provider.of<TravelDetailsProvider>(context, listen: false).addExpense(expense);
    }
  }

  Future<void> _editExpense(BuildContext context, Expense expense) async {
    final result = await showDialog<Expense>(
      context: context,
      builder: (context) => _ExpenseDialog(expense: expense, travelDetails: travelDetails,),
    );

    if (result != null) {
      // Update the existing expense in the database
      final updatedExpense = Expense(
        id: expense.id, // Keep the original ID
        category: result.category,
        amount: result.amount,
        note: result.note,
        travelDetailsId: travelDetails.name,
        date: DateTime.now(),
      );

      Provider.of<TravelDetailsProvider>(context, listen: false).updateExpense(updatedExpense);
    }
  }
}

class _BudgetDialog extends StatelessWidget {
  const _BudgetDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    return AlertDialog(
      title: const Text('Set Initial Budget',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Budget Amount',
          prefixText: '\$',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_controller.text);
            if (amount != null) {
              Navigator.pop(context, amount);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
          child: const Text('Save', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

class _ExpenseDialog extends StatefulWidget {
  final Expense? expense;
  final TravelDetails travelDetails;

  const _ExpenseDialog({Key? key, this.expense, required this.travelDetails}) : super(key: key);


  @override
  __ExpenseDialogState createState() => __ExpenseDialogState();
}

class __ExpenseDialogState extends State<_ExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Other';
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _category = widget.expense!.category;
      _amountController.text = widget.expense!.amount.toString();
      _noteController.text = widget.expense!.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
      const Text('Add Expense', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _category,
              items: ['Attraction Ticket', 'Gas', 'Dining', 'Other']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => _category = value!),
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null ? 'Select a category' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final expense = Expense(
                category: _category,
                amount: double.parse(_amountController.text),
                note: _noteController.text,
                travelDetailsId: widget.travelDetails.name,
                date: DateTime.now(),
              );
              Navigator.pop(context, expense);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
          child: const Text('Save', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}