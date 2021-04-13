// import 'package:budget_tracker_ui/json/create_budget_json.dart';
import 'package:budget_tracker_ui/json/daily_json.dart';
import 'package:budget_tracker_ui/theme/colors.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class DetailLog extends StatelessWidget {
  final int index;

  DetailLog({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var data = expenses[index];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        actions: [
          IconButton(
            onPressed: () {
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
            onPressed: () {},
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
                onChanged: (val) {
                  data["item"] = val;
                  // print(data);
                },
              ),
              SizedBox(height: 15),
              SelectFormField(
                type: SelectFormFieldType.dropdown, // or can be dialog
                initialValue: expenses[index]['person'],
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
                  // print(data);
                },
                // onSaved: (val) => print(val),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                initialValue: expenses[index]['amount'],
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
                  if (double.tryParse(val) == null) {
                    return "Entere a valid number ";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              DateTimePicker(
                type: DateTimePickerType.date,
                dateMask: 'd MMM, yyyy',
                initialValue: DateFormat("dd-MM-yyyy")
                    .parse(expenses[index]['date'])
                    .toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                onChanged: (val) {
                  data["date"] = val;
                  // print(data);
                },
              ),
              SizedBox(height: 15),

              SelectFormField(
                type: SelectFormFieldType.dropdown, // or can be dialog
                initialValue: expenses[index]['category'],
                icon: Icon(Icons.person_outline),
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
                  // print(data);
                },
                // onSaved: (val) => print(val),
              ),

              // TextFormField(
              //   autovalidateMode: AutovalidateMode.always,
              //   initialValue: expenses[index]['category'],
              //   decoration: const InputDecoration(
              //     icon: Icon(Icons.category_outlined),
              //     hintText: 'Category of the spend',
              //     labelText: "Category",
              //   ),
              //   onSaved: (String value) {},
              //   onChanged: (val) {
              //     data["category"] = val;
              //     // print(data);
              //   },
              // ),
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
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
                      initialValue: expenses[index]['shareBy'] == "All"
                          ? users
                          : [expenses[index]['shareBy']],
                      cancelButtonLabel: 'CANCEL',
                      hintWidget: Text('Among whom the money is shared?'),
                      onSaved: (val) {
                        // print(val);
                        data["shareBy"] = val.toString();
                        // print(data);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
