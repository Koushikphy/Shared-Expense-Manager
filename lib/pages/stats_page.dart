import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_expenses/theme/colors.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';

class StatsPage extends StatefulWidget {
  final ExpenseModel model;
  final Function callback;

  StatsPage({Key key, @required this.model, this.callback}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
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
        children: <Widget>[
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
                  colors: myColors[1],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
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
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          (widget.model.getUsers.length == 0 ||
                  widget.model.getCategories.length == 0)
              ? Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "No users added",
                      style: TextStyle(fontSize: 21),
                    ),
                    TextButton(
                        onPressed: () {
                          widget.callback(2);
                        },
                        child: Text("Go to settings"))
                  ],
                )
              : Column(
                  children: [
                    makeStatCrad("Total Spends", Colors.pink,
                        MaterialCommunityIcons.shopping),
                    makeStatCrad("Total Owe", Colors.green,
                        MaterialIcons.account_balance),
                    makeStatCrad(
                        "Net Owe", Colors.purple, MaterialIcons.payment),
                  ],
                )
        ],
      ),
    );
  }

  Padding makeStatCrad(String cardType, MaterialColor color, IconData icon) {
    var size = MediaQuery.of(context).size;
    List<String> _users = widget.model.getUsers;
    widget.model.calculateShares();

    Map<String, double> thisStats = widget.model.getexpenseStats[cardType];
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
                    children: <Widget>[
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
                              fontWeight: FontWeight.w500,
                            ),
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
                  _users.length,
                  (index) {
                    return Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: (size.width - 40) * .6,
                              child: Text(
                                _users[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              width: (size.width - 40) * .35,
                              child: Text(
                                thisStats[_users[index]].toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Divider(
                            thickness: index == _users.length - 1 ? 0.01 : 0.9,
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
