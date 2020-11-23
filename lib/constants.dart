// SETTINGS
import 'package:ecommerceapp/services/languages.dart';
import 'package:flutter/material.dart';

const String appName = "ECommerce App";

// COLORS
const Color colorPrimary = Color.fromRGBO(63, 54, 164, 1);
const Color colorSecondary = Color.fromRGBO(65, 224, 235, 1);
const Color colorDark = Colors.black87;
const Color colorwhite = Colors.white;

// GLOBAL VARs
String wcKey = "";

// LANGUAGEs CTRL
int selectedLang = 0;
String getText(String key) {
  if (languages.containsKey(key)) {
    if (languages[key][selectedLang] != null) {
      return languages[key][selectedLang];
    }
  }
  return '***';
}