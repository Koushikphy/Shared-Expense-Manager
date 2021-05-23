import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';
import 'package:shared_expenses/pages/share_page.dart';
import 'package:shared_expenses/theme/colors.dart';
import 'package:scoped_model/scoped_model.dart';

class NewEntryLog extends StatefulWidget {
  final Function callback;
  final BuildContext context;
  final int index;
  NewEntryLog({Key key, this.callback, this.context, this.index = -999}) : super(key: key);
  @override
  _NewEntryLogState createState() => _NewEntryLogState();
}

class _NewEntryLogState extends State<NewEntryLog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, String> aList;
  TextEditingController _itemEditor = TextEditingController();
  TextEditingController _personEditor = TextEditingController();
  TextEditingController _amountEditor = TextEditingController();
  TextEditingController _dateEditor = TextEditingController(text: DateTime.now().toString());
  TextEditingController _categoryEditor = TextEditingController();
  ExpenseModel model;
  bool showError = false;

  bool editRecord;

  @override
  void dispose() {
    super.dispose();
    _itemEditor.dispose();
    _personEditor.dispose();
    _amountEditor.dispose();
    _dateEditor.dispose();
    _categoryEditor.dispose();
  }

  @override
  void initState() {
    model = ScopedModel.of(widget.context);
    super.initState();
    editRecord = widget.index != -999;
    if (editRecord) {
      Map<String, dynamic> data = {...model.getExpenses[widget.index]};
      _itemEditor.text = data['item'];
      _personEditor.text = data['person'];
      _amountEditor.text = data['amount'];
      _dateEditor.text = DateFormat("dd-MM-yyyy").parse(data['date']).toString();
      _categoryEditor.text = data['category'];
      aList = model.getExpenses[widget.index]["shareBy"]; //.split(',').map((e) => double.parse(e)).toList();
      // fill users if not present
      if (model.getUsers.length != aList.length) {
        for (String u in model.getUsers) {
          if (!aList.containsKey(u)) {
            aList[u] = "0.00";
          }
        }
      }
    } else {
      aList = {for (var u in model.getUsers) u: "0.00"};
    }
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (formKey.currentState.validate() && sharedProperly()) {
                Map<String, dynamic> data = {
                  "date": DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(_dateEditor.text)),
                  "person": _personEditor.text,
                  "item": _itemEditor.text,
                  "category": _categoryEditor.text,
                  "amount": _amountEditor.text,
                  "shareBy": aList //.map((e) => e.toString()).join(',')
                };
                editRecord ? model.editExpense(widget.index, data) : model.addExpense(data);
                widget.callback(0); //move to log page
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.save),
            color: Colors.white,
            tooltip: "Save ",
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              if (editRecord) model.deleteExpense(widget.index);
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete),
            color: Colors.white,
            tooltip: "Delete",
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: SingleChildScrollView(
        // key: ValueKey<int>(count1),
        child: (model.getUsers.length == 0 || model.getCategories.length == 0)
            ? Container(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "No user and categories added",
                      style: TextStyle(fontSize: 21),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                        onPressed: () {
                          widget.callback(2);
                          Navigator.pop(context);
                        },
                        child: Text("Go to settings"))
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.shopping_cart_outlined),
                          hintText: 'Where did you spent the money?',
                          labelText: 'Item',
                        ),
                        controller: _itemEditor,
                        validator: (value) => value.isEmpty ? "Required filed *" : null,
                      ),
                      SizedBox(height: 15),
                      SelectFormField(
                        icon: Icon(Icons.person_outline),
                        labelText: 'Spent By',
                        controller: _personEditor,
                        items: model.getUsers
                            .map((e) => {
                                  "value": e,
                                  "label": e,
                                })
                            .toList(),
                        validator: (value) => value.isEmpty ? "Required filed *" : null,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        controller: _amountEditor,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.account_balance_wallet_outlined),
                          hintText: 'How much money is spent?',
                          labelText: "Amount",
                        ),
                        validator: (val) {
                          if (val.isEmpty) return "Required filed *";
                          if (double.tryParse(val) == null) {
                            return "Entre a valid number ";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      DateTimePicker(
                          controller: _dateEditor,
                          type: DateTimePickerType.date,
                          dateMask: 'd MMM, yyyy',
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Date',
                          validator: (value) => value.isEmpty ? "Required field *" : null),
                      SizedBox(height: 15),
                      SelectFormField(
                        // key: ValueKey<int>(count2),
                        type: SelectFormFieldType.dropdown, // or can be dialog
                        controller: _categoryEditor,
                        icon: Icon(Icons.category),
                        hintText: 'Category of the spend',
                        labelText: 'Category',
                        items: model.getCategories
                            .map((e) => {
                                  "value": e,
                                  "label": e,
                                })
                            .toList(),

                        validator: (value) => value.isEmpty ? "Required field *" : null,
                      ),
                      SizedBox(height: 15),
                      SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          double val = double.parse(_amountEditor.text);
                          if (val != null) {
                            double summed = 0.0;
                            for (String v in aList.values) {
                              summed += double.parse(v);
                            }
                            if (summed != val) aList = {for (var u in model.getUsers) u: "0.00"};

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SharePage(
                                  value: val,
                                  users: model.getUsers,
                                  initValue: aList,
                                  callback: getTheValue,
                                ),
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  color: Colors.black.withOpacity(.6),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Shared Between",
                                        style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(.7)),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: aList.entries
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.only(right: 15, bottom: 5),
                                          child: Text(
                                            e.key,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: aList.entries
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.only(left: 15, bottom: 5),
                                            child: Text(e.value, style: TextStyle(fontSize: 15)),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, top: 8),
                              child: Divider(
                                indent: 2,
                                color: Colors.black,
                              ),
                            ),
                            if (showError)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "* Amount should be shared properly.",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  getTheValue(Map<String, String> val) {
    setState(() {
      aList = val;
    });
  }

  sharedProperly() {
    double summed = 0;
    for (String v in aList.values) {
      summed += double.parse(v);
    }
    // aList.fold(0, (a, b) => a + b);
    var val = double.parse(_amountEditor.text);
    if (val == null) return false;
    if (summed == val) {
      showError = false;
      return true;
    } else {
      setState(() {
        showError = true;
      });
      return false;
    }
  }
}
