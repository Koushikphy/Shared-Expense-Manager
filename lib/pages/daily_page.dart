import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_expenses/theme/colors.dart';
// import "package:shared_expenses/pages/detail_page.dart";
import 'package:shared_expenses/scoped_model/expenseScope.dart';
import 'package:shared_expenses/pages/newentry_page.dart';

class DailyPage extends StatelessWidget {
  final ExpenseModel model1;
  final Function callback;
  const DailyPage({Key key, @required this.model1, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    var size = MediaQuery.of(context).size;

    ExpenseModel model = ScopedModel.of(context);

    List<Map<String, String>> _expenses = model.getExpenses;
    // print(model.expenses);
    //
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
              ),
            ],
            gradient: LinearGradient(
                colors: myColors[0],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, 2.0],
                tileMode: TileMode.clamp),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Expense Log",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                model.getExpenses.length == 0
                    ? Column(
                        children: [
                          Text(
                            "No expense entries found",
                            style: TextStyle(fontSize: 21),
                          ),
                          TextButton(
                              onPressed: () {
                                callback(3);
                              },
                              child: Text("Add new entries"))
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 15, right: 0),
                        child: Column(
                          children: List.generate(
                            _expenses.length,
                            (i) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // builder: (context) => DetailLog(index: i, model: model),
                                      builder: (context) => NewEntryLog(
                                        callback: callback,
                                        context: context,
                                        index: i,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          // color: Colors.amber,
                                          width: size.width * 0.7,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _expenses[i]['item'],
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    _expenses[i]['person'],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 15,
                                                      //color: Colors.green
                                                    ),
                                                  ),
                                                  SizedBox(width: 15),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.25,
                                          // color: Colors.red,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  "₹ ${_expenses[i]['amount']}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  _expenses[i]['date'],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: black.withOpacity(0.5),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 8, right: 10),
                                      child: Divider(
                                        indent: 0,
                                        thickness: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
