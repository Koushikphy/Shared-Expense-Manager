import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';
// import 'package:shared_expenses/pages/share_page.dart';
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
  TextEditingController _itemEditor = TextEditingController();
  TextEditingController _personEditor = TextEditingController();
  TextEditingController _amountEditor = TextEditingController();
  TextEditingController _dateEditor = TextEditingController(text: DateTime.now().toString());
  TextEditingController _categoryEditor = TextEditingController();
  List<TextEditingController> _shareControler;

  Map<String, String> shareList;
  ExpenseModel model;
  bool showError = false;
  List<bool> _checkList;
  List<String> _users;

  bool editRecord;

  @override
  void dispose() {
    super.dispose();
    _itemEditor.dispose();
    _personEditor.dispose();
    _amountEditor.dispose();
    _dateEditor.dispose();
    _categoryEditor.dispose();
    _shareControler.forEach((element) {
      element.dispose();
    });
  }

  @override
  void initState() {
    model = ScopedModel.of(widget.context);
    super.initState();
    editRecord = widget.index != -999;
    _users = model.getUsers;

    if (editRecord) {
      Map<String, dynamic> data = {...model.getExpenses[widget.index]};
      _itemEditor.text = data['item'];
      _personEditor.text = data['person'];
      _amountEditor.text = data['amount'];
      _dateEditor.text = DateFormat("dd-MM-yyyy").parse(data['date']).toString();
      _categoryEditor.text = data['category'];
      shareList = Map<String, String>.from(model.getExpenses[widget.index]["shareBy"]);

      // fill users if not present
      if (_users.length != shareList.length) {
        for (String u in model.getUsers) {
          if (!shareList.containsKey(u)) {
            shareList[u] = "0.00";
          }
        }
      }
    } else {
      shareList = {for (var u in model.getUsers) u: "0.00"};
    }
    _checkList = _users.map((e) => double.parse(shareList[e]) != 0).toList();
    _shareControler = _users.map((e) => TextEditingController(text: shareList[e])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        actions: <Widget>[
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
                        autovalidateMode: AutovalidateMode.disabled,
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
                        autovalidateMode: AutovalidateMode.disabled,
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
                        autovalidate: false,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: List.generate(
                            _users.length,
                            (index) {
                              return Row(
                                children: [
                                  Checkbox(
                                      value: _checkList[index],
                                      onChanged: (v) {
                                        _checkList[index] = v;
                                        updateSharingDetails();
                                      }),
                                  Container(
                                    width: (MediaQuery.of(context).size.width - 100) * .4,
                                    child: Text(
                                      _users[index],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Text("₹ ", style: TextStyle(fontSize: 14)),
                                  Container(
                                    width: (MediaQuery.of(context).size.width - 100) * .4,
                                    child: TextField(
                                      enabled: _checkList[index],
                                      controller: _shareControler[index],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(border: InputBorder.none),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
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
                        ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: clearForm,
              child: Text(
                "Save & Add anoter",
                style: TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
            ),
            TextButton(
              onPressed: () {
                bool saved = saveRecord();
                if (saved) {
                  widget.callback(0); //move to log page
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Save",
                style: TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveRecord() {
    if (formKey.currentState.validate() && sharedProperly()) {
      Map<String, dynamic> data = {
        "date": DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(_dateEditor.text)),
        "person": _personEditor.text,
        "item": _itemEditor.text,
        "category": _categoryEditor.text,
        "amount": _amountEditor.text,
        "shareBy": shareList
      };
      editRecord ? model.editExpense(widget.index, data) : model.addExpense(data);
      return true;
    }
  }

  clearForm() {
    bool saved = saveRecord();
    if (!saved) return;
    formKey.currentState.reset();
    _itemEditor.clear();
    _amountEditor.clear();
    // keep the person selector, category selector and date as it is while clearing the form
    // _personEditor?.clear();
    // _categoryEditor.clear();
    // _dateEditor.text = DateTime.now().toString();
    shareList = {for (var u in model.getUsers) u: "0.00"};
    _checkList = _users.map((_) => false).toList();
    for (TextEditingController e in _shareControler) {
      e.text = "0.00";
    }
    _shareControler = _users.map((e) => TextEditingController(text: shareList[e])).toList();
    editRecord = false;
    setState(() {});
    print(shareList);
  }

  sharedProperly() {
    double summed = 0;
    for (String v in shareList.values) {
      summed += double.parse(v);
    }

    double val = double.parse(_amountEditor.text);
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

  updateSharingDetails() {
    double value = double.parse(_amountEditor.text);
    double amount = value / _checkList.where((element) => element == true).length;
    amount = double.parse(amount.toStringAsFixed(2));

    List<double> iAmount = _checkList.map((e) => e ? amount : 0.0).toList();
    double diff = value;
    for (double e in iAmount) {
      diff -= e;
    }

    if (diff != 0) {
      for (int i = 0; i < _users.length; i++) {
        if (_checkList[i]) {
          iAmount[i] += diff;
          break;
        }
      }
    }
    for (int i = 0; i < _users.length; i++) {
      _shareControler[i].text = iAmount[i].toStringAsFixed(2);
      shareList[_users[i]] = iAmount[i].toStringAsFixed(2);
    }
    setState(() {});
  }
}
