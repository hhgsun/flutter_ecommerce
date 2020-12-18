import 'package:ecommerceapp/languages.dart';
import 'package:ecommerceapp/models/customer.dart';
import 'package:ecommerceapp/models/product_category.dart';
import 'package:ecommerceapp/services/woocommerce.dart';
import 'package:flutter/material.dart';

////////////////////////////////////////////////
// CUSTOM SETTINGS ---- ////////////////////////

const String appName = "ECommerce App";

// woocommerce and wordpress
WooCommerce woocommerce = WooCommerce(
  baseUrl: "https://canliozelders.com",
  consumerKey: "ck_d4f5a2fccc633d525b268a0c6ba73fa805dea1d5",
  consumerSecret: "cs_e3fe59f51fd0f1a389e143bfc85d37662856018a",
  isDebug: true,
);
// colors
const Color colorPrimary = Color.fromRGBO(63, 54, 164, 1);
const Color colorSecondary = Color.fromRGBO(65, 224, 235, 1);
const Color colorDark = Colors.black87;
const Color colorwhite = Colors.white;

// ---- CUSTOM SETTINGS ////////////////////////
////////////////////////////////////////////////

// GENERATE WP USERNAME
String generateUsernameByEmail(String email) {
  String prefix = "u_";
  String endfix = "_" +
      DateTime.now().day.toString() +
      DateTime.now().month.toString() +
      DateTime.now().year.toString();
  String ret = "";
  if (email.split('@').length > 0) {
    ret = email.split('@').first;
  } else {
    ret = email;
  }
  ret = ret.toLowerCase().trim();
  return prefix + ret + endfix;
}

// LANGUAGES CTRL
int selectedLang = 0;
String getText(String key) {
  if (languages.containsKey(key)) {
    if (languages[key][selectedLang] != null) {
      return languages[key][selectedLang];
    }
  }
  return '***';
}

// CURRENT USER
WooCustomer loggedInCustomer;
List<WooProductCategory> categories = [];


// CUSTOM
// const String lostPassUrlForWebView = "/hesabim/lost-password/";
const String customApiNamespace = "/wp-json/hhgsun/v1";

//
const String URL_STORE_API_PATH = '/wp-json/wc/store/';
const URL_JWT_BASE = '/wp-json/jwt-auth/v1';
const URL_JWT_TOKEN = '$URL_JWT_BASE/token';
const DEFAULT_WC_API_PATH = "/wp-json/wc/v3/";
const URL_WP_BASE = '/wp-json/wp/v2';
const URL_USER_ME = '$URL_WP_BASE/users/me';
const URL_REGISTER_ENDPOINT = '$URL_WP_BASE/users/register';