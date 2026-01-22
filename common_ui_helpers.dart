// made by Hamza Mahdi

// my_expense_tracker/lib/ui/helpers/common_ui_helpers.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/expense_model.dart';
import '../../logic/providers/expense_provider.dart';
import '../screens/add_expense_screen.dart';

class CommonUIHelpers {
   const CommonUIHelpers._(); // يمنع إنشاء كائن

  static void showExpenseOptionsDialog(BuildContext context, ExpenseModel expense) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Expense Options'),
        content: const Text('What would you like to do?'),
        actions: [
          // Cancel
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),

          // Edit
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddExpenseScreen(
                    expense: expense, // 👈 Edit mode
                  ),
                ),
              );
            },
            child: const Text('Edit'),
          ),

           // Delete
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context
                  .read<ExpenseProvider>()
                  .deleteExpense(expense.id!);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

  // ===== Privacy Policy Dialog =====
static  void showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const Text(
            'This application stores all data locally on your device.\n'
            'No personal data is shared with external services.\n'
            'Your privacy is our priority.\n\n'
            'made by Hamza Mahdi.',
          ),
          actions: [// made by Hamza Mahdi
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
