import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ilk açılan sayfa"),
      ),
      body: Center(
        child: Text("İlk Açılan sayfa slider tanıtım olabilir ve giriş yap, kayıt ol, normal devam et butonları olur"),
      ),
    );
  }
}