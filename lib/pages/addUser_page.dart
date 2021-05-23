import 'package:flutter/material.dart';
import 'package:shared_expenses/theme/colors.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';
import 'package:shared_expenses/pages/newentry_page.dart';
import 'package:animations/animations.dart';
import 'package:scoped_model/scoped_model.dart';

class AddUserCat extends StatefulWidget {
  final BuildContext context;
  final int type;
  // type 0 means userlist and type 1 means category
  AddUserCat({Key key, this.context, this.type}) : super(key: key);

  @override
  _AddUserCatState createState() => _AddUserCatState();
}

class _AddUserCatState extends State<AddUserCat> {
  ExpenseModel model;
  List<String> _userList;
  bool isUser;
  TextEditingController userControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUser = widget.type == 0;
    model = ScopedModel.of(widget.context);
    _userList = isUser ? model.getUsers : model.getCategories;
  }

  @override
  void dispose() {
    super.dispose();
    userControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUser ? "User" : "Categories"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              isUser ? model.setUsers(_userList) : model.setCategories(_userList);
              Navigator.pop(context);
            },
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showUserDialog,
        child: Icon(Icons.add),
      ),
      body: Container(
        child: ListView(
          children: _userList
              .map(
                (e) => ListTile(
                  leading: isUser ? Icon(Icons.person_outline) : Icon(Icons.category_outlined),
                  // leading: Icon(Icons.person_outline),
                  title: Text(e),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void showUserDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter new ${isUser ? "user" : "category"}:'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
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
                Navigator.of(context).pop();
                setState(() {
                  _userList.add(userControler.text);
                });
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
