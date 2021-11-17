import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ExpenseModel extends Model {
  ExpenseModel() {
    setInitValues();
  }
  // convert this to a object approach.
  List<String> _categories = [];
  List<String> _users = [];
  List<Map<String, dynamic>> _expenses = [];
  // for now, only month is added, no year, so a particular month for several years will be considered same
  String _currentMonth = '1';

  // Future<SharedPreferences> mySharedPref = SharedPreferences.getInstance();

  List<Map<String, dynamic>> get getExpenses => _expenses;
  List<String> get getCategories => _categories;
  List<String> get getUsers => _users;
  String get getCurrentMonth => _currentMonth;

  void setUsers(List<String> userList) {
    _users = userList;
    upDateUserData(true, false, false, false);
    notifyListeners();
  }

  void setCategories(List<String> categoryList) {
    _categories = categoryList;
    upDateUserData(false, true, false, false);
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
    sortExpenses();
    upDateUserData(false, false, true, false);
    notifyListeners();
  }

  void deleteExpense(int index) {
    _expenses.removeAt(index);
    sortExpenses();
    upDateUserData(false, false, true, false);
    notifyListeners();
  }

  void editExpense(int index, Map<String, dynamic> updatedExpenseEntry) {
    _expenses[index] = updatedExpenseEntry;
    sortExpenses();

    upDateUserData(false, false, true, false);
    notifyListeners();
  }

  void setCurrentMonth(String cMonth) {
    _currentMonth = cMonth;
    upDateUserData(false, false, false, true);
    calculateShares();
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
      _currentMonth = prefs.getString('currentMonth') ?? '1';
      if (_users.length != 0 && _categories.length != 0) {
        _expenses =
            (json.decode(prefs.getString('expenses')) as Iterable).map((e) => Map<String, dynamic>.from(e))?.toList();
      } else {
        _expenses = [];
      }
      notifyListeners();
    });
  }

  void upDateUserData(bool u, bool c, bool e, bool d) async {
    SharedPreferences.getInstance().then((prefs) => {
          if (e) prefs.setString('expenses', json.encode(_expenses)),
          if (u) prefs.setStringList('users', _users),
          if (c) prefs.setStringList('categories', _categories),
          if (d) prefs.setString('currentMonth', _currentMonth)
        });
  }

  void newDataLoaded(List<String> uList, List<String> cList, List<Map<String, dynamic>> exList) {
    _users = uList;
    _categories = cList;
    _expenses = exList;
    upDateUserData(true, true, true, false);
    notifyListeners();
  }

  Map<String, Map<String, double>> calculateShares() {
    Map<String, Map<String, double>> tmpStats = {
      "Total Spends": {for (var v in _users) v: 0},
      "Total Owe": {for (var v in _users) v: 0},
      "Net Owe": {for (var v in _users) v: 0}
    };

    for (Map entry in _expenses) {
      // get the current month
      String month = int.parse(entry['date'].split('-')[1]).toString();

      if (_currentMonth != '13' && _currentMonth != month) {
        continue;
      }
      double amount = double.parse(entry["amount"]);
      tmpStats["Total Spends"][entry["person"]] += amount;
      for (MapEntry val in entry["shareBy"].entries) {
        tmpStats["Total Owe"][val.key] += double.parse(val.value);
        tmpStats["Net Owe"][val.key] += double.parse(val.value);
      }
    }

    for (String u in _users) {
      tmpStats["Net Owe"][u] = tmpStats["Total Owe"][u] - tmpStats["Total Spends"][u];
    }

    return tmpStats;
  }

  Map<String, double> calculateCategoryShare() {
    Map<String, double> cShare = {for (var v in _categories) v: 0};
    for (Map entry in _expenses) {
      String month = int.parse(entry['date'].split('-')[1]).toString();

      if (_currentMonth != '13' && _currentMonth != month) {
        continue;
      }
      cShare[entry['category']] += double.parse(entry['amount']);
    }

    Map pieData = <String, double>{};
    for (String en in _categories) {
      pieData[en + " ₹ ${cShare[en]}"] = cShare[en];
    }
    return pieData;
  }

  void sortExpenses() {
    _expenses
        .sort((a, b) => DateFormat("dd-MM-yyyy").parse(a['date']).compareTo(DateFormat("dd-MM-yyyy").parse(b['date'])));
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
        "date": "02-02-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-02-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-02-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-02-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-01-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-01-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
      {
        "date": "02-01-2021",
        "person": "John",
        "item": "Rent",
        "category": "Bills",
        "amount": "66",
        "shareBy": {"Sam": "22", "Will": "22", "John": "22"}
      },
    ];
  }
}
