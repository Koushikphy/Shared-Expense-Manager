import 'package:scoped_model/scoped_model.dart';

// import "package:budget_tracker_ui/json/daily_json.dart";
List categories = ["Bills", "Food", "Misc"];

List users = ["Koushik", "Satyam", "Joy"];

Map<String, List> expenseStats = {
  "Total Spends": [12, 30, 44], // in order of user list
  "Total Owe": [11, 50, 74],
  "Net Owe": [10, 55, 99]
};

List expenses = [
  {
    "date": "01-03-2021",
    "person": "Satyam",
    "item": "Groceries",
    "category": "Food",
    "amount": "290",
    "shareBy": "All"
  },
  {
    "date": "01-03-2021",
    "person": "Joy",
    "item": "Milk",
    "category": "Food",
    "amount": "220",
    "shareBy": "Koushik"
  },
  {
    "date": "02-03-2021",
    "person": "Joy",
    "item": "Misc",
    "category": "Food",
    "amount": "200",
    "shareBy": "Satyam"
  },
  {
    "date": "02-03-2021",
    "person": "Koushik",
    "item": "Rent",
    "category": "Bills",
    "amount": "64",
    "shareBy": "All"
  },
  {
    "date": "02-03-2021",
    "person": "Koushik",
    "item": "Gas",
    "category": "Food",
    "amount": "64",
    "shareBy": "All"
  },
  {
    "date": "02-03-2021",
    "person": "Koushik",
    "item": "Water",
    "category": "Food",
    "amount": "64",
    "shareBy": "All"
  },
  {
    "date": "02-03-2021",
    "person": "Koushik",
    "item": "Vegetables",
    "category": "Food",
    "amount": "64",
    "shareBy": "All"
  },
  {
    "date": "02-03-2021",
    "person": "Koushik",
    "item": "Misc",
    "category": "Food",
    "amount": "64",
    "shareBy": "All"
  },
];

class ExpenseModel extends Model {

  List get getExpenses => expenses;
  List get getCategories => categories;
  List get getUsers => users;
  Map<String, List> get getexpenseStats => expenseStats;

  void addExpense(Map<String, dynamic> newExpenseEntry) {
    expenses.insert(0, newExpenseEntry);
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
