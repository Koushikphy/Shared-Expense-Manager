import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:select_form_field/select_form_field.dart';
// import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_expenses/theme/colors.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';
import 'package:shared_expenses/pages/share_page.dart';

class DetailLog extends StatefulWidget {
  final int index;
  final ExpenseModel model;

  DetailLog({Key key, @required this.index, @required this.model}) : super(key: key);

  @override
  _DetailLogState createState() => _DetailLogState();
}

class _DetailLogState extends State<DetailLog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<double> aList;
  bool showError = false;
  ExpenseModel model;
  int index;
  List<String> categories;
  List<String> users;
  Map<String, String> data;

  @override
  void initState() {
    super.initState();
    aList = widget.model.getExpenses[widget.index]["shareBy"].split(',').map((e) => double.parse(e)).toList();
    model = widget.model;
    index = widget.index;
    categories = model.getCategories;
    users = model.getUsers;
    data = {...widget.model.getExpenses[index]};
  }

  @override
  Widget build(BuildContext context) {
    // instead of the data use this with the texediting controler.
    // var size = MediaQuery.of(context).size;
    // print(data);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (formKey.currentState.validate() && sharedProperly()) {
                // print("check this");
                // print(data);
                model.editExpense(index, data);
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.save),
            color: Colors.white,
            tooltip: "Save",
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              model.deleteExpense(index);
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
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: data["item"],
                  decoration: const InputDecoration(
                    icon: Icon(Icons.shopping_cart_outlined),
                    hintText: 'Where did you spent the money?',
                    labelText: 'Item',
                  ),
                  onSaved: (String value) {},
                  onChanged: (val) {
                    data["item"] = val;
                    // print(data);
                  },
                  validator: (value) => value.isEmpty ? "Required filed *" : null,
                ),
                SizedBox(height: 15),
                SelectFormField(
                  type: SelectFormFieldType.dropdown, // or can be dialog
                  initialValue: data['person'],
                  icon: Icon(Icons.person_outline),
                  labelText: 'Spent By',
                  items: users
                      .map((e) => {
                            "value": e,
                            "label": e,
                          })
                      .toList(),
                  onChanged: (val) {
                    data["person"] = val;
                  },
                  validator: (value) => value.isEmpty ? "Required filed *" : null,
                  // onSaved: (val) => print(val),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  initialValue: data['amount'],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.account_balance_wallet_outlined),
                    hintText: 'How much money is spent?',
                    labelText: "Amount",
                  ),
                  onChanged: (val) {
                    data["amount"] = val;
                    // print(data);
                  },
                  onSaved: (String value) {},
                  validator: (val) {
                    if (val.isEmpty) return "Required field *";
                    if (double.tryParse(val) == null) {
                      return "Enter a valid number ";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateFormat("dd-MM-yyyy").parse(data['date']).toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Date',
                  onChanged: (val) {
                    data["date"] = DateFormat('dd-MM-yyyy').format(
                      DateFormat('yyyy-MM-dd').parse(val),
                    );
                  },
                  validator: (value) => value.isEmpty ? "Required filed *" : null,
                ),
                SizedBox(height: 15),
                SelectFormField(
                  type: SelectFormFieldType.dropdown, // or can be dialog
                  initialValue: data['category'],
                  icon: Icon(Icons.category),
                  hintText: 'Category of the spend',
                  labelText: 'Category',
                  items: categories
                      .map((e) => {
                            "value": e,
                            "label": e,
                          })
                      .toList(),
                  onChanged: (val) {
                    data["category"] = val;
                  },
                  validator: (value) => value.isEmpty ? "Required filed *" : null,
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    var val = double.parse(data['amount']);
                    if (val != null)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SharePage(
                            value: val,
                            users: widget.model.getUsers,
                            initValue: val == aList.fold(0, (a, b) => a + b) ? aList : aList.map((e) => 0.0).toList(),
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
    setState(() {
      aList = val;
      data['shareBy'] = aList.map((e) => e.toString()).join(',');
      print("from teh callback ${aList.map((e) => e.toString()).join(',')}");
      print(data);
    });
  }

  sharedProperly() {
    double summed = aList.fold(0, (a, b) => a + b);
    var val = double.parse(data['amount']);
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
