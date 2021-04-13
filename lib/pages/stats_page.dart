// import 'package:budget_tracker_ui/json/day_month.dart';
// import 'package:budget_tracker_ui/json/daily_json.dart';
import 'package:budget_tracker_ui/theme/colors.dart';
// import 'package:budget_tracker_ui/widget/chart.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:budget_tracker_ui/scoped_model/expenseScope.dart';

class StatsPage extends StatefulWidget {
  final ExpenseModel model;
  StatsPage({Key key, @required this.model}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int activeDay = 3;

  bool showAvg = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Stats",
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange.shade800),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          makeStatCrad(
              "Total Spends", Colors.pink, MaterialCommunityIcons.shopping),
          makeStatCrad(
              "Total Owe", Colors.green, MaterialIcons.account_balance),
          makeStatCrad("Net Owe", Colors.purple, MaterialIcons.payment),
        ],
      ),
    );
  }

  Padding makeStatCrad(String cardType, MaterialColor color, IconData icon) {
    var size = MediaQuery.of(context).size;
    List users = widget.model.getUsers;
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 5.0,
        child: Container(
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.01),
                  spreadRadius: 10,
                  blurRadius: 3,
                  // changes position of shadow
                ),
              ]),
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 10, left: 5, right: 5),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(icon),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            cardType,
                            style: TextStyle(
                                fontSize: 25,
                                color: color.shade800,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Divider(
                        thickness: 3.0,
                        height: 15,
                        color: color.shade50,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    children: List.generate(
                  users.length,
                  (index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: (size.width - 40) * .6,
                              child: Text(
                                users[index],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              width: (size.width - 40) * .35,
                              child: Text(
                                widget.model.getexpenseStats[cardType][index]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: black,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Divider(
                            thickness: index == users.length - 1 ? 0.01 : 0.9,
                            indent: 5,
                            endIndent: 5,
                          ),
                        ),
                      ],
                    );
                  },
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
