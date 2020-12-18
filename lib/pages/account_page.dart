import 'package:ecommerceapp/constants.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(loggedInCustomer != null
          ? loggedInCustomer.toJson().toString()
          : 'No Login User'),
    );
  }
}
