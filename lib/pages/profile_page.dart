import 'package:shared_expenses/theme/colors.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // TextEditingController _email =TextEditingController(text: "abbie_wilson@gmail.com");
  // TextEditingController dateOfBirth = TextEditingController(text: "04-19-1992");
  // TextEditingController password = TextEditingController(text: "123456");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade400,
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    // var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Center(
            child: Text(
      "Coming Soon",
      style: TextStyle(fontSize: 21),
    )));
  }
}
