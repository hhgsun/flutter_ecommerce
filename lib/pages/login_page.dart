import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GİRİŞ YAP VE KAYIT OL"),
      ),
      body: Center(
        child: Text("Giriş ve Kayıt"),
      ),
    );
  }
}