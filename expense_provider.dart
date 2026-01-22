// made by Hamza Mahdi

// my_expense_tracker/lib/logic/providers/expense_provider.dart

import 'package:flutter/material.dart';

import '../../data/database/db_helper.dart';
import '../../data/models/expense_model.dart';



enum ExpenseFilter {
  today,
  last7Days,
  last30Days,
}

class ExpenseProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper.instance;

  // ================= State =================

  List<ExpenseModel> _expenses = [];
  double _totalAmount = 0.0;
  bool _isLoading = false;

  ExpenseFilter _currentFilter = ExpenseFilter.today;

  // ================= Getters =================

  List<ExpenseModel> get expenses => _expenses;
  double get totalAmount => _totalAmount;
  bool get isLoading => _isLoading;
  ExpenseFilter get currentFilter => _currentFilter;

  // ================= Private Helpers =================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ================= Public Methods =================

  /// تغيير الفلترة (اليوم / 7 أيام / 30 يوم)
  Future<void> changeFilter(ExpenseFilter filter) async {
    _currentFilter = filter;
    await loadExpenses();
  }

  /// تحميل البيانات حسب الفلترة الحالية
  Future<void> loadExpenses() async {
    _setLoading(true);

    try {
      switch (_currentFilter) {
        case ExpenseFilter.today:
          _expenses = await _dbHelper.getTodayExpenses();
          _totalAmount = await _dbHelper.getTodayTotal();
          break;

        case ExpenseFilter.last7Days:
          _expenses = await _dbHelper.getLast7DaysExpenses();
          _totalAmount = await _dbHelper.getLast7DaysTotal();
          break;

        case ExpenseFilter.last30Days:
          _expenses = await _dbHelper.getLast30DaysExpenses();
          _totalAmount = await _dbHelper.getLast30DaysTotal();
          break;
      }
    } catch (e) {
      debugPrint('Error loading expenses: $e');
      _expenses = [];
      _totalAmount = 0.0;
    } finally {
      _setLoading(false);
    }
  }

  /// إضافة مصروف جديد
  Future<void> addExpense(ExpenseModel expense) async {
    _setLoading(true);

    try {
      await _dbHelper.insertExpense(expense);
      await loadExpenses();
    } catch (e) {
      debugPrint('Error adding expense: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// تحديث مصروف
  Future<void> updateExpense(ExpenseModel expense) async {
    _setLoading(true);

    try {
      await _dbHelper.updateExpense(expense);
      await loadExpenses();
    } catch (e) {
      debugPrint('Error updating expense: $e');
    } finally {
      _setLoading(false);
    }
  }
// made by Hamza Mahdi
  /// حذف مصروف
  Future<void> deleteExpense(int id) async {
    _setLoading(true);

    try {
      await _dbHelper.deleteExpense(id);
      await loadExpenses();
    } catch (e) {
      debugPrint('Error deleting expense: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAccount() async {
  _setLoading(true);

  try {
    // حذف جميع المصروفات
    await _dbHelper.deleteAllExpenses();

    // إعادة ضبط الحالة
    _expenses = [];
    _totalAmount = 0.0;
  } catch (e) {
    debugPrint('Error deleting account data: $e');
  } finally {
    _setLoading(false);
  }
}

}