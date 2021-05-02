import 'package:flutter/material.dart';
import 'package:shared_expenses/theme/colors.dart';
// import 'package:shared_expenses/scoped_model/expenseScope.dart';

class SharePage extends StatefulWidget {
  final double value;
  final List<String> users;
  final Function callback;
  final List<double> initValue;
  SharePage({Key key, @required this.value, @required this.users, @required this.initValue, @required this.callback})
      : super(key: key);

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  List<bool> _checkList;
  List<double> _initAmount;
  List<TextEditingController> _controler;
  // TextEditingController _cCheck;
  bool showError = false;
  // bool _fieldModifiedManually = false;

  @override
  void initState() {
    super.initState();
    _initAmount = widget.initValue; //.map((e) => double.parse(e)).toList();
    _checkList = _initAmount.map((e) => e != 0).toList(); //  List.filled(widget.users.length, false);
    _controler = List.generate(widget.users.length, (i) => TextEditingController(text: _initAmount[i].toString()));
  }

  @override
  Widget build(BuildContext context) {
    String value = widget.value.toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        actions: [
          IconButton(
            onPressed: () {
              if (isSumEqual()) {
                // widget.callback(_controler.map((e) => e.text));
                widget.callback(_controler.map((e) => double.parse(e.text)).toList());
                Navigator.pop(context);
              } else {
                setState(() {
                  showError = true;
                });
              }
            },
            icon: Icon(Icons.save),
            color: Colors.white,
            tooltip: "Save",
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                "How ₹$value is shared?",
                style: TextStyle(fontSize: 21),
              ),
            ),
            Column(
              children: List.generate(
                widget.users.length,
                (index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width - 20) * .2,
                        child: Checkbox(
                          value: _checkList[index],
                          onChanged: (bool val) {
                            _checkList[index] = val;

                            // handle situation where the money can be shared properly, like dividing 10 among 3 people
                            // in that case we will just add the remainning value to a random user;
                            // add to first user for now;
                            // fix this problem, how to record this kind of values
                            double amount =
                                round2(widget.value / _checkList.where((element) => element == true).length);
                            for (int i = 0; i < widget.users.length; i++) _initAmount[i] = _checkList[i] ? amount : 0.0;

                            double diff = widget.value - _initAmount.fold(0, (a, b) => a + b);
                            if (diff != 0)
                              for (int i = 0; i < widget.users.length; i++) {
                                if (_checkList[i]) {
                                  _initAmount[i] += diff;
                                  break;
                                }
                              }
                            for (int i = 0; i < widget.users.length; i++)
                              _controler[i].text = _initAmount[i].toStringAsFixed(2);
                            // print('here==>');
                            // print(widget.value == _initAmount.fold(0, (a, b) => a + b));
                            // _controler[i].text = _initAmount[i].toStringAsFixed(2);
                            // print('diff value 1 : $diff');
                            // _initAmount[2] += diff;
                            // _controler[2].text = _initAmount[2].toStringAsFixed(2);
                            // print('diff value 2 : $diff');
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        child: Text(widget.users[index], style: TextStyle(fontSize: 18)),
                        width: (MediaQuery.of(context).size.width - 20) * .4,
                      ),
                      Text("₹ ", style: TextStyle(fontSize: 16)),
                      Container(
                        width: (MediaQuery.of(context).size.width - 20) * .35,
                        child: TextField(
                          enabled: _checkList[index],
                          controller: _controler[index],
                          // decoration: InputDecoration(labelText: "Share amount"),
                          keyboardType: TextInputType.number,
                          // onChanged: (value) {
                          //   _fieldModifiedManually = true;
                          // },
                          // onSubmitted: (value) {
                          //   setState(
                          //     () {
                          //       _initAmount[index] = double.parse(value);
                          //     },
                          //   );
                          // },
                          decoration: InputDecoration(border: InputBorder.none),
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
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
      ),
    );
  }

  double round2(double val) {
    return double.parse(val.toStringAsFixed(2));
  }

  bool isSumEqual() {
    // if (!_fieldModifiedManually) return true;
    double val = 0.0;
    _controler.forEach((element) {
      val += double.parse(element.text);
    });
    return val == widget.value;
  }
}
