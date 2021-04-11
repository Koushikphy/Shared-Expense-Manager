import 'package:budget_tracker_ui/json/daily_json.dart';
// import 'package:budget_tracker_ui/json/day_month.dart';
import 'package:budget_tracker_ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DetailLog extends StatelessWidget {
  final int index;
  DetailLog({Key key, @required this.index}) : super(key: key);

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade400,
        actions: [
          TextButton(
              onPressed: () {},
              child: Icon(
                Icons.delete,
                color: Colors.white,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                initialValue: expenses[index]["item"],
                decoration: const InputDecoration(
                  icon: Icon(Icons.shopping_cart_outlined),
                  hintText: 'Where did you spent the money?',
                  labelText: 'Item',
                ),
                onSaved: (String value) {},
              ),
              SizedBox(height: 15),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                initialValue: expenses[index]['person'],
                decoration: const InputDecoration(
                  icon: Icon(Icons.person_outline),
                  hintText: 'Who spent the money?',
                  labelText: "Spent By",
                ),
                onSaved: (String value) {},
              ),
              SizedBox(height: 15),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                initialValue: expenses[index]['amount'],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  hintText: 'How much money is spent?',
                  labelText: "Amount",
                ),
                onSaved: (String value) {},
              ),
              SizedBox(height: 15),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                initialValue: expenses[index]['date'],
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  icon: Icon(Icons.date_range),
                  hintText: 'When was the money spent?',
                  labelText: "Date",
                ),
                onSaved: (String value) {},
              ),
              SizedBox(height: 15),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                initialValue: expenses[index]['category'],
                decoration: const InputDecoration(
                  icon: Icon(Icons.date_range),
                  hintText: 'Category of the spend',
                  labelText: "Category",
                ),
                onSaved: (String value) {},
              ),
              SizedBox(height: 15),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                initialValue: expenses[index]['shareBy'],
                decoration: const InputDecoration(
                  icon: Icon(Icons.people_outline),
                  hintText: 'Among whom the money is shared?',
                  labelText: "Shared By",
                ),
                onSaved: (String value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
