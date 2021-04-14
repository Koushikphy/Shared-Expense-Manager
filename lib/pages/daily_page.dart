import 'package:flutter/material.dart';
import 'package:shared_expenses/theme/colors.dart';
import "package:shared_expenses/pages/detail_page.dart";
import 'package:shared_expenses/scoped_model/expenseScope.dart';

class DailyPage extends StatefulWidget {
  final ExpenseModel model;
  DailyPage({Key key, @required this.model}) : super(key: key);

  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int activeDay = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    List expenses = widget.model.getExpenses;
    // print(widget.model.expense);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: white, boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50, right: 20, left: 20, bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Daily Expense Log",
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange.shade800),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 0),
            child: Column(
              children: List.generate(
                widget.model.getExpenses.length,
                (i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailLog(index: i, model: widget.model)),
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
                                children: [
                                  Text(expenses[i]['item'],
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: black,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        expenses[i]['person'],
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
                                  children: [
                                    Text(
                                      expenses[i]['amount'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          color: Colors.green),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      expenses[i]['date'],
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: black.withOpacity(0.5),
                                          fontWeight: FontWeight.w400),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 65, top: 8),
                          child: Divider(
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
    );
  }
}
