import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:select_form_field/select_form_field.dart';
// import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';
import 'package:shared_expenses/pages/share_page.dart';
import 'package:shared_expenses/theme/colors.dart';

class NewEntryLog extends StatefulWidget {
  final ExpenseModel model;
  final Function callback;
  NewEntryLog({Key key, @required this.model, this.callback}) : super(key: key);

  @override
  _NewEntryLogState createState() => _NewEntryLogState();
}

class _NewEntryLogState extends State<NewEntryLog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<double> aList;
  TextEditingController _itemEditor = TextEditingController();
  TextEditingController _personEditor = TextEditingController();
  TextEditingController _amountEditor = TextEditingController();
  TextEditingController _dateEditor = TextEditingController(text: DateTime.now().toString());
  TextEditingController _categoryEditor = TextEditingController();
  String _shareEditor;
  double _oldVal = 0.0;
  bool showError = false;

  @override
  void initState() {
    super.initState();
    aList = List.filled(widget.model.users.length, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // print(aList.length);
    // print(model.getExpenses);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // formKey.currentState.validate();
              if (formKey.currentState.validate() && sharedProperly())
                widget.model.addExpense({
                  "date": DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(_dateEditor.text)),
                  "person": _personEditor.text,
                  "item": _itemEditor.text,
                  "category": _categoryEditor.text,
                  "amount": _amountEditor.text,
                  "shareBy": _shareEditor
                });
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
              formKey.currentState.reset();
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
        child: (widget.model.getUsers.length == 0 || widget.model.getCategories.length == 0)
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
                        // initialValue: data["item"],
                        decoration: const InputDecoration(
                          icon: Icon(Icons.shopping_cart_outlined),
                          hintText: 'Where did you spent the money?',
                          labelText: 'Item',
                        ),
                        // onSaved: (String value) {},
                        // onChanged: (val) {
                        //   data["item"] = val;
                        // },
                        controller: _itemEditor,
                        validator: (value) => value.isEmpty ? "Required filed *" : null,
                      ),
                      SizedBox(height: 15),
                      SelectFormField(
                        type: SelectFormFieldType.dropdown, // or can be dialog
                        // initialValue: data['person'],
                        icon: Icon(Icons.person_outline),
                        labelText: 'Spent By',
                        controller: _personEditor,
                        items: widget.model.getUsers
                            .map((e) => {
                                  "value": e,
                                  "label": e,
                                })
                            .toList(),
                        // onChanged: (val) {
                        //   data["person"] = val;
                        //   // print(data);
                        // },
                        validator: (value) => value.isEmpty ? "Required filed *" : null,
                        // onSaved: (val) => print(val),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // initialValue: data['amount'],
                        keyboardType: TextInputType.number,
                        controller: _amountEditor,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.account_balance_wallet_outlined),
                          hintText: 'How much money is spent?',
                          labelText: "Amount",
                        ),

                        onChanged: (val) {
                          print(_oldVal);
                          print(double.parse(val));
                          print(_oldVal != double.parse(val));
                          if (_oldVal != double.parse(val))
                            setState(() {
                              _oldVal = double.parse(val); // jsut don't reset the values;
                              aList = List.filled(widget.model.users.length, 0.0);
                            });
                          // print(data);
                        },
                        // onSaved: (String value) {},
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
                          // initialValue: data['date'],
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Date',
                          // onChanged: (val) {
                          //   data["date"] = DateFormat('dd-MM-yyyy').format(
                          //     DateFormat('yyyy-MM-dd').parse(val),
                          //   );
                          //   print(data["date"]);
                          //   print("from chnage");
                          // },
                          // onFieldSubmitted: (value) {
                          //   data["date"] = DateFormat('dd-MM-yyyy').format(
                          //     DateFormat('yyyy-MM-dd').parse(value),
                          //   );
                          //   print(data["date"]);
                          //   print("from submit");
                          // },
                          validator: (value) => value.isEmpty ? "Required field *" : null),
                      SizedBox(height: 15),
                      SelectFormField(
                        type: SelectFormFieldType.dropdown, // or can be dialog
                        // initialValue: data['category'],
                        controller: _categoryEditor,
                        icon: Icon(Icons.category),
                        hintText: 'Category of the spend',
                        labelText: 'Category',
                        items: widget.model.getCategories
                            .map((e) => {
                                  "value": e,
                                  "label": e,
                                })
                            .toList(),
                        // onChanged: (val) {
                        //   data["category"] = val;
                        //   // print(data);
                        // },
                        // onSaved: (newValue) {
                        //   _shareEditor = newValue;
                        // },
                        validator: (value) => value.isEmpty ? "Required field *" : null,
                      ),
                      SizedBox(height: 15),
                      SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          var val = double.parse(_amountEditor.text);
                          if (val != null)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SharePage(
                                  value: val,
                                  users: widget.model.getUsers,
                                  initValue: aList,
                                  callback: getTheValue,
                                ),
                              ),
                            );
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
                                    children: List.generate(
                                      aList.length,
                                      (index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 10, bottom: 5),
                                          child: Text(
                                            widget.model.getUsers[index],
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Column(
                                    children: List.generate(
                                      aList.length,
                                      (index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                                          child: Text(aList[index].toStringAsFixed(2), style: TextStyle(fontSize: 15)),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, top: 8),
                              child: Divider(
                                // thickness: 2,
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

  getTheValue(val) {
    // print("from the new entry page");
    // print(val);
    // print(val.runtimeType);
    setState(() {
      aList = val;
    });
  }

  sharedProperly() {
    double summed = aList.fold(0, (a, b) => a + b);
    var val = double.parse(_amountEditor.text);
    if (val == null) return false;
    if (summed == val) {
      return true;
    } else {
      setState(() {
        showError = true;
      });
      return false;
    }
  }
}
