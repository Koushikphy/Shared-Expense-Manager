import 'package:scoped_model/scoped_model.dart';
import "package:budget_tracker_ui/json/daily_json.dart";

class ExpenseModel extends Model {
  List _categories = categories;
  List _users = users;
  List _expenses = expenses;

  void addExpense(Map<String, dynamic> newExpenseEntry) {
    expenses.add(newExpenseEntry);
    notifyListeners();
  }

  void deleteExpense(int index) {
    expenses.removeAt(index);
    notifyListeners();
  }

  void editExpense(int index, Map<String, dynamic> updatedExpenseEntry) {
    expenses[index] = updatedExpenseEntry;
    notifyListeners();
  }
}
