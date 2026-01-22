// made by Hamza Mahdi

// my_expense_tracker/lib/ui/screens/expenses_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/common_ui_helpers.dart';


import '../../logic/providers/expense_provider.dart';


class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({super.key});

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  int _selectedFilterIndex = 0;

//   void _showExpenseOptions(BuildContext context, int expenseId) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Expense Options'),
//         content: const Text('What would you like to do?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           ),
//                     // Edit
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => AddExpenseScreen(
//                     expense: expense, // 👈 Edit mode
//                   ),
//                 ),
//               );
//             },
//             child: const Text('Edit'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await context
//                   .read<ExpenseProvider>()
//                   .deleteExpense(expenseId);
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.red,
//             ),
//             child: const Text('Delete'),
//           ),
//         ],
//       );
//     },
//   );
//  }


  @override
  void initState() {
    super.initState();

    // تحميل مصروفات اليوم افتراضيًا
    Future.microtask(() {
      context.read<ExpenseProvider>().loadExpenses();
    });
  }

  void _onFilterSelected(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });

    final provider = context.read<ExpenseProvider>();

    switch (index) {
      case 0:
        provider.changeFilter(ExpenseFilter.today);
        break;
      case 1:
        provider.changeFilter(ExpenseFilter.last7Days);
        break;
      case 2:
        provider.changeFilter(ExpenseFilter.last30Days);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
// made by Hamza Mahdi
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Filters =====
                Row(
                  children: [
                    _buildFilterButton('Today', 0),
                    _buildFilterButton('Last 7 Days', 1),
                    _buildFilterButton('Last 30 Days', 2),
                  ],
                ),

                const SizedBox(height: 20),

                // ===== Total Amount =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    provider.totalAmount.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ===== Expenses List =====
                Expanded(
                  child: provider.expenses.isEmpty
                      ? const Center(
                          child: Text(
                            'No expenses found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: provider.expenses.length,
                          itemBuilder: (context, index) {
                            final expense = provider.expenses[index];

                            return Card(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(expense.category),
                                subtitle: expense.note != null && expense.note!.isNotEmpty
                                    ? Text(expense.note!)
                                    : null,
                                trailing: Text(
                                  expense.amount.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onLongPress: () {
                                  CommonUIHelpers.showExpenseOptionsDialog(context, expense);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===== Filter Button =====
  Widget _buildFilterButton(String title, int index) {
    final isSelected = _selectedFilterIndex == index;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? Colors.blueAccent : Colors.grey.shade300,
            foregroundColor:
                isSelected ? Colors.white : Colors.black,
          ),
          onPressed: () => _onFilterSelected(index),
          child: Text(title),
        ),
      ),
    );
  }
}
