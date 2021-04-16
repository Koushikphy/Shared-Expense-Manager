import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_expenses/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';

class ProfilePage extends StatefulWidget {
  final ExpenseModel model;
  ProfilePage({Key key, @required this.model}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController userControler = TextEditingController();
  TextEditingController categoryControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userControler.text = widget.model.getUsers.join(',');
    categoryControler.text = widget.model.getCategories.join(',');
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: grey.withOpacity(0.05),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                56, //56 height of the bottom navigation bar
            child: getBody(),
          ),
        ));
  }

  Widget getBody() {
    // var size = MediaQuery.of(context).size;
    return Column(
      // mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.start,
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
                colors: myColors[2],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, 2.0],
                tileMode: TileMode.clamp),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Text(
                //   "Preferences",
                //   style: TextStyle(
                //       fontSize: 21,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white),
                // ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          child: Column(
            children: [
              Image.asset(
                "assets/images/budgeting.png",
                height: 100,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                "Shared Expense Manager",
                style: TextStyle(
                  fontSize: 25, color: myColors[2][0],
                  // fontWeight: FontWeight.bold,

                  //
                ),
              ),
              Text(
                "v 0.1.0",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,

                  //
                ),
              ),
              SizedBox(height: 13),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              InkWell(
                onTap: showUserDialog,
                child: Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 10),
                    Text(
                      "Users",
                      style: TextStyle(
                        fontSize: 21,
                        // fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                indent: 30,
                thickness: 1.0,
                height: 15,
                // color: color.shade50,
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: showCategoryDialog,
                child: Row(
                  children: [
                    Icon(Icons.category_outlined),
                    SizedBox(width: 10),
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 21,
                        // fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                indent: 30,
                thickness: 1.0,
                height: 15,
                // color: color.shade50,
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: showResetDialog,
                child: Row(
                  children: [
                    Icon(FlutterIcons.restore_mco),
                    SizedBox(width: 10),
                    Text(
                      "Reset Data",
                      style: TextStyle(
                        fontSize: 21,
                        // fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                indent: 30,
                thickness: 1.0,
                height: 15,
                // color: color.shade50,
              ),
              SizedBox(
                height: 21,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 35,
                    tooltip: "Download the data",
                    icon: Icon(FlutterIcons.download_faw5s),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 35,
                    tooltip: "Upload the data",
                    icon: Icon(FlutterIcons.upload_faw5s),
                    onPressed: () {},
                  )
                ],
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
        Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Copyright \u00a9',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " 2021, "),
                  TextSpan(
                    text: 'Koushik Naskar',
                    style: TextStyle(color: Colors.blueAccent.shade700),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => print('click'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 13,
            )
          ],
        ),
      ],
    );
  }

  void showUserDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Expense Entries'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Enter user list'),
                TextFormField(
                  controller: userControler,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                widget.model.setUsers(userControler.text.toString().split(','));
                Navigator.of(context).pop();
                print(widget.model.getUsers);
              },
            ),
            TextButton(
              child: Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showCategoryDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Expense Entries'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Enter category list'),
                TextFormField(
                  controller: categoryControler,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                widget.model.setCategories(
                    categoryControler.text.toString().split(','));
                Navigator.of(context).pop();
                print(widget.model.getUsers);
              },
            ),
            TextButton(
              child: Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showResetDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Expense Entries'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to clear all expense entries?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                widget.model.resetAll();

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
