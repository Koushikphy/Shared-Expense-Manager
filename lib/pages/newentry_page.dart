import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';
import 'package:shared_expenses/theme/colors.dart';

class NewEntryLog extends StatelessWidget {
  final ExpenseModel model;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NewEntryLog({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var data = {
      "date": DateTime.now().toString(),
      "person": "",
      "item": "",
      "category": "",
      "amount": "",
      "shareBy": ""
    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState.validate()) model.addExpense(data);
              print(data);
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
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
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
                  items: model.getUsers
                      .map((e) => {
                            "value": e,
                            "label": e,
                          })
                      .toList(),
                  onChanged: (val) {
                    data["person"] = val;
                    // print(data);
                  },
                  validator: (value) =>
                      value.isEmpty ? "Required filed *" : null,
                  // onSaved: (val) => print(val),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    if (val.isEmpty) return "Required filed *";
                    if (double.tryParse(val) == null) {
                      return "Entre a valid number ";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                DateTimePicker(
                    type: DateTimePickerType.date,
                    dateMask: 'd MMM, yyyy',
                    initialValue: data['date'],
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'Date',
                    onChanged: (val) {
                      data["date"] = DateFormat('dd-MM-yyyy')
                          .format(DateFormat('yyyy-MM-dd').parse(val));
                      // print(data);
                    },
                    validator: (value) =>
                        value.isEmpty ? "Required field *" : null),
                SizedBox(height: 15),
                SelectFormField(
                  type: SelectFormFieldType.dropdown, // or can be dialog
                  initialValue: data['category'],
                  icon: Icon(Icons.person_outline),
                  hintText: 'Category of the spend',
                  labelText: 'Category',
                  items: model.getCategories
                      .map((e) => {
                            "value": e,
                            "label": e,
                          })
                      .toList(),
                  onChanged: (val) {
                    data["category"] = val;
                    // print(data);
                  },
                  validator: (value) =>
                      value.isEmpty ? "Required field *" : null,
                ),
                SizedBox(height: 15),
                Row(
                  children: [
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        title: Text(
                          "Shared Between",
                          style: TextStyle(fontSize: 13),
                        ),
                        dataSource: model.getUsers
                            .map((e) => {
                                  "value": e,
                                  "display": e,
                                })
                            .toList(),
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'CANCEL',
                        hintWidget: Text('Among whom the money is shared?'),
                        onSaved: (val) {
                          data["shareBy"] = val.join(',');
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
