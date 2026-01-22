// made by Hamza Mahdi

// my_expense_tracker/lib/data/database/db_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/expense_model.dart';

class DBHelper {
  // Singleton pattern
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  // Getter آمن لقاعدة البيانات
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // تهيئة قاعدة البيانات
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expenses.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // إنشاء الجداول
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        note TEXT
      )
    ''');
  }

  // ================= CRUD OPERATIONS =================

  // إضافة مصروف
  Future<int> insertExpense(ExpenseModel expense) async {
    final db = await database;
    return await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // made by Hamza Mahdi
  // جلب المصروفات خلال الأيام المحددة
Future<List<ExpenseModel>> _getExpensesByDays(int days) async {
  final db = await database;

  final DateTime now = DateTime.now();
  final DateTime startDate = now.subtract(Duration(days: days));

  final String formattedDate =
      "${startDate.year.toString().padLeft(4, '0')}-"
      "${startDate.month.toString().padLeft(2, '0')}-"
      "${startDate.day.toString().padLeft(2, '0')}";

  final result = await db.query(
    'expenses',
    where: 'date >= ?',
    whereArgs: [formattedDate],
    orderBy: 'date DESC',
  );

  return result.map((e) => ExpenseModel.fromMap(e)).toList();
}

  // جلب جميع المصروفات
  Future<List<ExpenseModel>> getAllExpenses() async {
    final db = await database;
    final result = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );

    return result.map((e) => ExpenseModel.fromMap(e)).toList();
  }

  // جلب مصروفات اليوم
Future<List<ExpenseModel>> getTodayExpenses() async {
  return await _getExpensesByDays(0);
}

  // جلب مصروفات آخر 7 أيام
Future<List<ExpenseModel>> getLast7DaysExpenses() async {
  return await _getExpensesByDays(7);
}

  // جلب مصروفات آخر 30 يوم
Future<List<ExpenseModel>> getLast30DaysExpenses() async {
  return await _getExpensesByDays(30);
}


  // جلب المجموع الكلي للمصروفات خلال الأيام المحددة
Future<double> _getTotalByDays(int days) async {
  final db = await database;

  final DateTime now = DateTime.now();
  final DateTime startDate = now.subtract(Duration(days: days));

  final String formattedDate =
      "${startDate.year.toString().padLeft(4, '0')}-"
      "${startDate.month.toString().padLeft(2, '0')}-"
      "${startDate.day.toString().padLeft(2, '0')}";

  final result = await db.rawQuery(
    '''
    SELECT SUM(amount) as total
    FROM expenses
    WHERE date >= ?
    ''',
    [formattedDate],
  );

  final total = result.first['total'];
  return total == null ? 0.0 : total as double;
}

  // جلب المجموع الكلي لمصروفات اليوم
Future<double> getTodayTotal() async {
  return await _getTotalByDays(0);
}

  // جلب المجموع الكلي لمصروفات آخر 7 أيام
Future<double> getLast7DaysTotal() async {
  return await _getTotalByDays(7);
}

  // جلب المجموع الكلي لمصروفات آخر 30 يوم
Future<double> getLast30DaysTotal() async {
  return await _getTotalByDays(30);
}


  // تحديث مصروف
  Future<int> updateExpense(ExpenseModel expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // حذف مصروف
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // حذف جميع المصروفات
  Future<void> deleteAllExpenses() async {
    final db = await database;
    await db.delete('expenses');
  }
}
