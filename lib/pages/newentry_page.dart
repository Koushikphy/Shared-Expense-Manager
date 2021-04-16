import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';
import 'package:shared_expenses/theme/colors.dart';

class NewEntryLog extends StatelessWidget {
  final ExpenseModel model;
  final Function callback;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NewEntryLog({Key key, @required this.model, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    TextEditingController _itemEditor = TextEditingController();
    TextEditingController _personEditor = TextEditingController();
    TextEditingController _amountEditor = TextEditingController();
    TextEditingController _dateEditor =
        TextEditingController(text: DateTime.now().toString());
    TextEditingController _categoryEditor = TextEditingController();
    String _shareEditor;
    // print(model.getExpenses);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // formKey.currentState.validate();
              if (formKey.currentState.validate())
                model.addExpense({
                  "date": DateFormat('dd-MM-yyyy')
                      .format(DateFormat('yyyy-MM-dd').parse(_dateEditor.text)),
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
                          callback(2);
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
                        validator: (value) =>
                            value.isEmpty ? "Required filed *" : null,
                      ),
                      SizedBox(height: 15),
                      SelectFormField(
                        type: SelectFormFieldType.dropdown, // or can be dialog
                        // initialValue: data['person'],
                        icon: Icon(Icons.person_outline),
                        labelText: 'Spent By',
                        controller: _personEditor,
                        items: model.getUsers
                            .map((e) => {
                                  "value": e,
                                  "label": e,
                                })
                            .toList(),
                        // onChanged: (val) {
                        //   data["person"] = val;
                        //   // print(data);
                        // },
                        validator: (value) =>
                            value.isEmpty ? "Required filed *" : null,
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
                        // onChanged: (val) {
                        //   data["amount"] = val;
                        //   // print(data);
                        // },
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
                          validator: (value) =>
                              value.isEmpty ? "Required field *" : null),
                      SizedBox(height: 15),
                      SelectFormField(
                        type: SelectFormFieldType.dropdown, // or can be dialog
                        // initialValue: data['category'],
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
                        // onChanged: (val) {
                        //   data["category"] = val;
                        //   // print(data);
                        // },
                        // onSaved: (newValue) {
                        //   _shareEditor = newValue;
                        // },
                        validator: (value) =>
                            value.isEmpty ? "Required field *" : null,
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
                              // lea
                              autovalidate: false,
                              chipBackGroundColor: Colors.deepPurple.shade200,
                              chipLabelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              dialogTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              checkBoxActiveColor: Colors.blue,
                              checkBoxCheckColor: Colors.white,
                              dialogShapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
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
                              hintWidget:
                                  Text('Among whom the money is shared?'),
                              onSaved: (val) {
                                _shareEditor = val.join(',');
                              },
                              validator: (value) => (value ?? "").isEmpty
                                  ? "Required field *"
                                  : null,
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
