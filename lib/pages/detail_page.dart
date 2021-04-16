import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_expenses/theme/colors.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';

class DetailLog extends StatelessWidget {
  final int index;
  final ExpenseModel model;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DetailLog({Key key, @required this.index, @required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<String> categories = model.getCategories;
    List<String> users = model.getUsers;
    Map<String, String> data = {...model.getExpenses[index]};
    // print(data);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // print(data);
              if (formKey.currentState.validate()) {
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
                  validator: (value) =>
                      value.isEmpty ? "Required filed *" : null,
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
                  validator: (value) =>
                      value.isEmpty ? "Required filed *" : null,
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
                  initialValue:
                      DateFormat("dd-MM-yyyy").parse(data['date']).toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Date',
                  onChanged: (val) {
                    data["date"] = DateFormat('dd-MM-yyyy').format(
                      DateFormat('yyyy-MM-dd').parse(val),
                    );
                    // print(val);
                  },
                  validator: (value) =>
                      value.isEmpty ? "Required filed *" : null,
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
                  validator: (value) =>
                      value.isEmpty ? "Required filed *" : null,

                  // onSaved: (val) => print(val),
                ),
                SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.people_outline,
                      color: Colors.black.withOpacity(.6),
                    ),
                    Container(
                      width: size.width * .82,
                      child: MultiSelectFormField(
                        autovalidate: false,
                        chipBackGroundColor: Colors.deepPurple.shade200,
                        chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                        dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        checkBoxActiveColor: Colors.blue,
                        checkBoxCheckColor: Colors.white,
                        dialogShapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        title: Text(
                          "Shared Between",
                          style: TextStyle(fontSize: 13),
                        ),
                        dataSource: users
                            .map((e) => {
                                  "value": e,
                                  "display": e,
                                })
                            .toList(),
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        initialValue: data['shareBy'] == "All"
                            ? users
                            : data['shareBy'].split(','),
                        cancelButtonLabel: 'CANCEL',
                        hintWidget: Text('Among whom the money is shared?'),
                        onSaved: (val) {
                          data["shareBy"] = val.toString();
                          // print(data);
                        },
                        validator: (value) =>
                            (value ?? "").isEmpty ? "Required field *" : null,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
