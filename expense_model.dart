// made by Hamza Mahdi

// my_expense_tracker/lib/data/models/expense_model.dart

class ExpenseModel {
  final int? id;
  final double amount;
  final String category;
  final String date;
  final String? note;

  ExpenseModel({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  // تحويل الكائن إلى Map (للتخزين في Sqflite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date,
      'note': note,
    };
  }
// made by Hamza Mahdi
  // إنشاء كائن ExpenseModel من Map (عند القراءة من Sqflite)
  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      date: map['date'],
      note: map['note'],
    );
  }
}
