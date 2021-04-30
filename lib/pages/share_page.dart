import 'package:flutter/material.dart';
import 'package:shared_expenses/theme/colors.dart';
import 'package:shared_expenses/scoped_model/expenseScope.dart';

class SharePage extends StatefulWidget {
  final double value;
  final List<String> users;
  final Function callback;

  SharePage({Key key, @required this.value, @required this.users, @required this.callback}) : super(key: key);

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  List<bool> _checkList;
  List<double> _initAmount;
  List<TextEditingController> _controler;
  TextEditingController _cCheck;
  bool showError = false;

  @override
  void initState() {
    super.initState();
    _checkList = List.filled(widget.users.length, false);
    _initAmount = List.filled(widget.users.length, 0);
    _controler = List.generate(widget.users.length, (i) => TextEditingController(text: '0.00'));
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
                widget.callback([500.0, 500.0, 0.0]);
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
                            int _sUsers = _checkList.where((element) => element == true).length;
                            for (int i = 0; i < widget.users.length; i++) {
                              if (_checkList[i]) _initAmount[i] = widget.value / _sUsers;
                              _controler[i].text = _initAmount[i].toStringAsFixed(2);
                            }
                            print(_initAmount[0]);
                            print(_controler[0].text);
                            setState(
                              () {},
                            );
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

  bool isSumEqual() {
    double val = 0.0;
    _controler.forEach((element) {
      val += double.parse(element.text);
    });
    return val == widget.value;
  }
}
