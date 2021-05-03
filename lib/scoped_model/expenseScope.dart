import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ExpenseModel extends Model {
  ExpenseModel() {
    setInitValues();
  }

  List<String> _categories = [];

  List<String> _users = [];

  Map<String, Map<String, double>> _expenseStats = {};

  List<Map<String, String>> _expenses = [];

  // Future<SharedPreferences> mySharedPref = SharedPreferences.getInstance();
  List<Map<String, String>> get getExpenses => _expenses;
  List<String> get getCategories => _categories;
  List<String> get getUsers => _users;
  Map<String, Map<String, double>> get getexpenseStats => _expenseStats;

  void setUsers(List<String> userList) {
    _users = userList;
    upDateUserData(true, false, false);
    notifyListeners();
  }

  void setCategories(List<String> categoryList) {
    _categories = categoryList;
    upDateUserData(false, true, false);
    notifyListeners();
  }

  void resetAll() {
    _categories = [];
    _users = [];
    _expenses = [];
    notifyListeners();
  }

  void addExpense(Map<String, String> newExpenseEntry) {
    _expenses.insert(0, newExpenseEntry);
    upDateUserData(false, false, true);
    notifyListeners();
  }

  void deleteExpense(int index) {
    _expenses.removeAt(index);
    upDateUserData(false, false, true);
    notifyListeners();
  }

  void editExpense(int index, Map<String, dynamic> updatedExpenseEntry) {
    _expenses[index] = updatedExpenseEntry;
    upDateUserData(false, false, true);
    notifyListeners();
  }

  void setInitValues() {
    if (kDebugMode) {
      // in case of debug mode use test data.
      testData();
      return;
    }
    SharedPreferences.getInstance().then((prefs) {
      _users = prefs.getStringList('users') ?? [];
      _categories = prefs.getStringList('categories') ?? [];
      if (_users.length != 0 && _categories.length != 0) {
        _expenses =
            (json.decode(prefs.getString('expenses')) as Iterable).map((e) => Map<String, String>.from(e))?.toList();
      } else {
        _expenses = [];
      }
      notifyListeners();
    });
  }

  void upDateUserData(bool u, bool c, bool e) async {
    SharedPreferences.getInstance().then((prefs) => {
          if (e) prefs.setString('expenses', json.encode(_expenses)),
          if (u) prefs.setStringList('users', _users),
          if (c) prefs.setStringList('categories', _categories)
        });
  }

  void newDataLoaded(List<String> uList, List<String> cList, List<Map<String, String>> exList) {
    _users = uList;
    _categories = cList;
    _expenses = exList;
    upDateUserData(true, true, true);
    notifyListeners();
  }

  void calculateShares() {
    Map<String, Map<String, double>> tmpStats = {
      "Total Spends": {for (var v in _users) v: 0},
      "Total Owe": {for (var v in _users) v: 0},
      "Net Owe": {for (var v in _users) v: 0}
    };

    _expenses.forEach(
      (entry) {
        double amount = double.parse(entry["amount"]);
        List shareBy = entry["shareBy"].split(',').map((e) => double.parse(e)).toList();
        tmpStats["Total Spends"][entry["person"]] += amount;

        for (int i = 0; i < _users.length; i++) {
          tmpStats["Total Owe"][_users[i]] += shareBy[i];
          tmpStats["Net Owe"][_users[i]] += shareBy[i];
        }

        tmpStats["Net Owe"][entry["person"]] -= amount;
      },
    );
    _expenseStats = tmpStats;
  }

  testData() {
    // used for debug
    _categories = ["Bills", "Food", "Misc"];
    _users = ["John", "Sam", "Will"];

    _expenseStats = {
      "Total Spends": {"John": 0, "Sam": 0, "Will": 0},
      "Total Owe": {"John": 0, "Sam": 0, "Will": 0},
      "Net Owe": {"John": 0, "Sam": 0, "Will": 0}
    };

    _expenses = [
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
