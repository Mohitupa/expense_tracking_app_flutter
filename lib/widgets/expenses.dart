import 'package:expense_tracking_app/chart/chart.dart';
import 'package:expense_tracking_app/widgets/expense_list/expense_list.dart';
import 'package:expense_tracking_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracking_app/model/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expenses> {
  final List<Expense> _registerExpenses = [
    Expense(
      title: "Work",
      amount: 11.1,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: "Movie",
      amount: 22.2,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: "Food",
      amount: 33.3,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: "Travel",
      amount: 44.4,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registerExpenses.indexOf(expense);
    setState(() {
      _registerExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("expense Deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registerExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text("No Expense Found. Start adding Some."),
    );

    if (_registerExpenses.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _registerExpenses,
        onRemovedExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expanse Tracker"),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600
          ? Column(children: [
              Chart(expenses: _registerExpenses),
              Expanded(
                child: mainContent,
              )
            ])
          : Row(children: [
              Expanded(
                child: Chart(expenses: _registerExpenses),
              ),
              Expanded(
                child: mainContent,
              )
            ]),
    );
  }
}
