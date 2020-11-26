// SETTINGS
import 'package:ecommerceapp/languages.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/woocommerce.dart';

const String appName = "ECommerce App";

// WORDPRESS AND WOOCOMMERCE
WooCommerce woocommerce = WooCommerce(
  baseUrl: "https://canliozelders.com",
  consumerKey: "ck_d4f5a2fccc633d525b268a0c6ba73fa805dea1d5",
  consumerSecret: "cs_e3fe59f51fd0f1a389e143bfc85d37662856018a",
  // isDebug: true,
);

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
