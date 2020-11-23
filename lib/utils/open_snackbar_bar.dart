import 'package:flutter/material.dart';

void openSnackBar(context, text) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration: Duration(seconds: 1),
  ));
}