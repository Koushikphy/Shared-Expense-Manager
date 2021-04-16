import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ExpenseModel extends Model {
  ExpenseModel() {
    setInitValues();
  }

  List<String> categories = []; // ["Bills", "Food", "Misc"];

  List<String> users = [];//["Koushik", "Satyam", "Joy"];

  Map<String, Map<String, double>> expenseStats = {
    // "Total Spends": {"Koushik": 0, "Satyam": 0, "Joy": 0},
    // "Total Owe": {"Koushik": 0, "Satyam": 0, "Joy": 0},
    // "Net Owe": {"Koushik": 0, "Satyam": 0, "Joy": 0}
  };

  List<Map<String, String>> expenses = [
    // {
    //   "date": "01-03-2021",
    //   "person": "Satyam",
    //   "item": "Groceries",
    //   "category": "Food",
    //   "amount": "29",
    //   "shareBy": "All"
    // },
    // {
    //   "date": "01-03-2021",
    //   "person": "Joy",
    //   "item": "Milk",
    //   "category": "Food",
    //   "amount": "220",
    //   "shareBy": "Koushik"
    // },
    // {
    //   "date": "02-03-2021",
    //   "person": "Joy",
    //   "item": "Misc",
    //   "category": "Food",
    //   "amount": "200",
    //   "shareBy": "Satyam"
    // },
    // {
    //   "date": "02-03-2021",
    //   "person": "Koushik",
    //   "item": "Rent",
    //   "category": "Bills",
    //   "amount": "64",
    //   "shareBy": "All"
    // },
    // {
    //   "date": "02-03-2021",
    //   "person": "Koushik",
    //   "item": "Gas",
    //   "category": "Food",
    //   "amount": "64",
    //   "shareBy": "All"
    // },
    // {
    //   "date": "02-03-2021",
    //   "person": "Koushik",
    //   "item": "Water",
    //   "category": "Food",
    //   "amount": "64",
    //   "shareBy": "All"
    // },
    // {
    //   "date": "02-03-2021",
    //   "person": "Koushik",
    //   "item": "Vegetables",
    //   "category": "Food",
    //   "amount": "64",
    //   "shareBy": "All"
    // },
    // {
    //   "date": "02-03-2021",
    //   "person": "Koushik",
    //   "item": "Misc",
    //   "category": "Food",
    //   "amount": "64",
    //   "shareBy": "All"
    // },
  ];

  Future<SharedPreferences> mySharedPref = SharedPreferences.getInstance();
  List<Map<String, String>> get getExpenses => expenses;
  List<String> get getCategories => categories;
  List<String> get getUsers => users;
  Map<String, Map<String, double>> get getexpenseStats => expenseStats;

  void setUsers(List<String> userList) {
    users = userList;
    notifyListeners();
  }

  void setCategories(List<String> categoryList) {
    categories = categoryList;
    notifyListeners();
  }

  void resetAll() {
    categories = [];
    users = [];
    expenses = [];
    notifyListeners();
  }

  void addExpense(Map<String, String> newExpenseEntry) {
    expenses.insert(0, newExpenseEntry);
    upDateUserData();
    notifyListeners();
  }

  void deleteExpense(int index) {
    expenses.removeAt(index);
    upDateUserData();
    notifyListeners();
  }

  void editExpense(int index, Map<String, dynamic> updatedExpenseEntry) {
    expenses[index] = updatedExpenseEntry;
    upDateUserData();
    notifyListeners();
  }

  void setInitValues() {
    SharedPreferences.getInstance().then((prefs) {
      // prefs.setString('expenses', json.encode(expenses));
      // prefs.setStringList('users', users);
      // prefs.setStringList('categories', categories);
      // print(prefs);
      users = prefs.getStringList('users') ?? [];
      categories = prefs.getStringList('categories') ?? [];
      print(users);
      print(categories);
      if (users.length != 0 && categories.length != 0) {
        expenses = (json.decode(prefs.getString('expenses')) as Iterable)
            .map((e) => Map<String, String>.from(e))
            ?.toList();
      } else {
        expenses = [];
      }
      notifyListeners();
    });
  }

  void upDateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('expenses', json.encode(expenses));
    await prefs.setStringList('users', users);
    await prefs.setStringList('categories', categories);
    print("yp");
  }

  void calculateShares() {
    Map<String, Map<String, double>> tmpStats = {
      "Total Spends": {for (var v in users) v: 0},
      "Total Owe": {for (var v in users) v: 0},
      "Net Owe": {for (var v in users) v: 0}
    };

    expenses.forEach(
      (entry) {
        double amount = double.parse(entry["amount"]);
        List shareBy = entry["shareBy"].split(',');
        shareBy = shareBy[0] == "All" ? users : shareBy;
        double shareAmount = amount / shareBy.length;
        tmpStats["Total Spends"][entry["person"]] += amount;

        shareBy.forEach(
          (per) {
            tmpStats["Total Owe"][per] += shareAmount;
            tmpStats["Net Owe"][per] += shareAmount;
          },
        );
        tmpStats["Net Owe"][entry["person"]] -= amount;
      },
    );

    expenseStats = tmpStats;
  }
}
