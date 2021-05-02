import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ExpenseModel extends Model {
  ExpenseModel() {
    setInitValues();
  }

  List<String> categories = [];

  List<String> users = [];

  Map<String, Map<String, double>> expenseStats = {};

  List<Map<String, String>> expenses = [];

  Future<SharedPreferences> mySharedPref = SharedPreferences.getInstance();
  List<Map<String, String>> get getExpenses => expenses;
  List<String> get getCategories => categories;
  List<String> get getUsers => users;
  Map<String, Map<String, double>> get getexpenseStats => expenseStats;

  void setUsers(List<String> userList) {
    users = userList;
    upDateUserData(true, false, false);
    notifyListeners();
  }

  void setCategories(List<String> categoryList) {
    categories = categoryList;
    upDateUserData(false, true, false);
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
    upDateUserData(false, false, true);
    notifyListeners();
  }

  void deleteExpense(int index) {
    expenses.removeAt(index);
    upDateUserData(false, false, true);
    notifyListeners();
  }

  void editExpense(int index, Map<String, dynamic> updatedExpenseEntry) {
    expenses[index] = updatedExpenseEntry;
    upDateUserData(false, false, true);
    notifyListeners();
  }

  void setInitValues() {
    if (kDebugMode) {
      testData();
      return;
    }
    SharedPreferences.getInstance().then((prefs) {
      users = prefs.getStringList('users') ?? [];
      categories = prefs.getStringList('categories') ?? [];
      // print(users);
      // print(categories);
      if (users.length != 0 && categories.length != 0) {
        expenses =
            (json.decode(prefs.getString('expenses')) as Iterable).map((e) => Map<String, String>.from(e))?.toList();
      } else {
        expenses = [];
      }
      notifyListeners();
    });
  }

  void upDateUserData(bool u, bool c, bool e) async {
    SharedPreferences.getInstance().then((prefs) => {
          e ? prefs.setString('expenses', json.encode(expenses)) : null,
          u ? prefs.setStringList('users', users) : null,
          c ? prefs.setStringList('categories', categories) : null
        });
  }

  void newDataLoaded(List<String> _uList, List<String> _cList, List<Map<String, String>> _exList) {
    users = _uList;
    categories = _cList;
    expenses = _exList;
    upDateUserData(true, true, true);
    notifyListeners();
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
        List shareBy = entry["shareBy"].split(',').map((e) => double.parse(e)).toList();
        tmpStats["Total Spends"][entry["person"]] += amount;

        for (int i = 0; i < users.length; i++) {
          tmpStats["Total Owe"][users[i]] += shareBy[i];
          tmpStats["Net Owe"][users[i]] += shareBy[i];
        }

        tmpStats["Net Owe"][entry["person"]] -= amount;
      },
    );

    expenseStats = tmpStats;
  }

  testData() {
    categories = ["Bills", "Food", "Misc"];

    users = ["John", "Sam", "Will"];

    expenseStats = {
      "Total Spends": {"John": 0, "Sam": 0, "Will": 0},
      "Total Owe": {"John": 0, "Sam": 0, "Will": 0},
      "Net Owe": {"John": 0, "Sam": 0, "Will": 0}
    };

    expenses = [
      {
        "date": "01-03-2021",
        "person": "Sam",
        "item": "Groceries",
        "category": "Food",
        "amount": "300",
        "shareBy": "100,100,100"
      },
      {
        "date": "01-03-2021",
        "person": "Will",
        "item": "Water",
        "category": "Food",
        "amount": "210",
        "shareBy": "210,0,0"
      },
      {
        "date": "02-03-2021",
        "person": "Will",
        "item": "Misc",
        "category": "Food",
        "amount": "200",
        "shareBy": "0,200,0"
      },
      {
        "date": "02-03-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": "22,22,22"
      },
    ];
  }
}
