import 'package:budget_tracker_ui/json/daily_json.dart';
// import 'package:budget_tracker_ui/json/day_month.dart';
import 'package:budget_tracker_ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int pressedIndex = 0;
  bool pressed = true;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Daily Expense Log",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange.shade800),
                  ),
                  Icon(AntDesign.search1)
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
                  children: List.generate(expenses.length, (i) {
                return ExpansionTile(
                  // key: GlobalKey(),
                  onExpansionChanged: (value) => setState(() {
                    pressedIndex = value ? i : 999;
                  }),
                  maintainState: pressedIndex == i,
                  tilePadding: EdgeInsets.only(left: 0),
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            // color: Colors.red,
                            width: size.width * 0.2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  expenses[i]['person'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    //color: Colors.green
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // color: Colors.amber,
                            width: size.width * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(expenses[i]['item'],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: black,
                                        fontWeight: FontWeight.w500),
                                    overflow: pressedIndex == i
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis),
                                SizedBox(height: 5),
                                Text(
                                  expenses[i]['date'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: black.withOpacity(0.5),
                                      fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: size.width * 0.15,
                            // color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  expenses[i]['amount'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.green),
                                ),
                              ],
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
                  children: [
                    Text(
                      "Shared between ",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.lightGreen.shade900,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Text(
                      expenses[i]["shareBy"],
                      style: TextStyle(
                          fontSize: 12, color: Colors.lightGreen.shade800),
                    ),
                    SizedBox(
                      height: 13,
                    )
                  ],
                  trailing: Text(""),
                );
              }))),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
