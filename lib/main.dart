import 'package:budget_tracker_ui/pages/root_app.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker_ui/scoped_model/expenseScope.dart';
import 'package:scoped_model/scoped_model.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: RootApp(),
//   ));
// }

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ExpenseModel myExpenseModel = ExpenseModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpenseModel>(
        model: myExpenseModel,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: RootApp(),
        ));
  }
}
