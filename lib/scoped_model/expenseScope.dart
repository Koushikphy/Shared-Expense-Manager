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

  // Map<String, Map<String, double>> _expenseStats = {};

  List<Map<String, dynamic>> _expenses = [];

  // Future<SharedPreferences> mySharedPref = SharedPreferences.getInstance();
  List<Map<String, dynamic>> get getExpenses => _expenses;
  List<String> get getCategories => _categories;
  List<String> get getUsers => _users;
  // Map<String, Map<String, double>> get getexpenseStats => _expenseStats;

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

  void addExpense(Map<String, dynamic> newExpenseEntry) {
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
    if (!kReleaseMode) {
      // in case of debug mode use test data.
      testData();
      return;
    }
    SharedPreferences.getInstance().then((prefs) {
      _users = prefs.getStringList('users') ?? [];
      _categories = prefs.getStringList('categories') ?? [];
      if (_users.length != 0 && _categories.length != 0) {
        _expenses =
            (json.decode(prefs.getString('expenses')) as Iterable).map((e) => Map<String, dynamic>.from(e))?.toList();
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

  void newDataLoaded(List<String> uList, List<String> cList, List<Map<String, dynamic>> exList) {
    _users = uList;
    _categories = cList;
    _expenses = exList;
    upDateUserData(true, true, true);
    notifyListeners();
  }

  Map<String, Map<String, double>> calculateShares() {
    Map<String, Map<String, double>> tmpStats = {
      "Total Spends": {for (var v in _users) v: 0},
      "Total Owe": {for (var v in _users) v: 0},
      "Net Owe": {for (var v in _users) v: 0}
    };

    _expenses.forEach(
      (entry) {
        double amount = double.parse(entry["amount"]);
        tmpStats["Total Spends"][entry["person"]] += amount;
        for (MapEntry val in entry["shareBy"].entries) {
          // do it with map.foreach
          tmpStats["Total Owe"][val.key] += double.parse(val.value);
          tmpStats["Net Owe"][val.key] += double.parse(val.value);
        }
      },
    );
    _users.forEach((u) {
      tmpStats["Net Owe"][u] = tmpStats["Total Owe"][u] - tmpStats["Total Spends"][u];
    });
    return tmpStats;
  }

  testData() {
    // used for debug
    _categories = ["Bills", "Food", "Misc"];
    _users = ["John", "Sam", "Will"];

    _expenses = [
      {
        "date": "01-03-2021",
        "person": "Sam",
        "item": "Groceries",
        "category": "Food",
        "amount": "300",
        "shareBy": {"Sam": "100", "Will": "100", "John": "100"}
      },
      {
        "date": "01-03-2021",
        "person": "Will",
        "item": "Water",
        "category": "Food",
        "amount": "210",
        "shareBy": {"Sam": "210"}
      },
      {
        "date": "02-03-2021",
        "person": "Will",
        "item": "Misc",
        "category": "Food",
        "amount": "200",
        "shareBy": {"Will": "200"}
      },
      {
        "date": "02-03-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-03-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-03-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-03-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-03-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-03-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-03-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-03-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-03-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
    ];
  }
}
