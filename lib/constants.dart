import 'package:ecommerceapp/languages.dart';
import 'package:ecommerceapp/models/cocart_item.dart';
import 'package:ecommerceapp/models/customer.dart';
import 'package:ecommerceapp/models/order.dart';
import 'package:ecommerceapp/models/product_category.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/services/woocommerce.dart';
import 'package:flutter/material.dart';

////////////////////////////////////////////////
// CUSTOM SETTINGS ---- ////////////////////////
const String appName = "ECommerce App";
// woocommerce and wordpress
WooCommerce woocommerce = WooCommerce(
  baseUrl: "https://canliozelders.com",
  consumerKey: "ck_23c920eb0baee6301506cf2d1210f15d8bf4a0d9",
  consumerSecret: "cs_4f83916c422e9088de8f11468cac7a95749e2981",
  isDebug: true,
);
// colors
const Color colorPrimary = Colors.red;
const Color colorSecondary = Colors.redAccent;
const Color colorDark = Colors.black87;
const Color colorLightDart = Colors.black54;
const Color colorwhite = Colors.white;
const Color colorFocus = Colors.indigoAccent;
// ---- CUSTOM SETTINGS ////////////////////////
////////////////////////////////////////////////

// SERVICE CUSTOM
// const String lostPassUrlForWebView = "/hesabim/lost-password/";
const String customApiNamespace = "/wp-json/hhgsun/v1";
const URL_STORE_API_PATH = '/wp-json/wc/store/';
const URL_JWT_BASE = '/wp-json/jwt-auth/v1';
const URL_JWT_TOKEN = '$URL_JWT_BASE/token';
const DEFAULT_WC_API_PATH = "/wp-json/wc/v3/";
const URL_WP_BASE = '/wp-json/wp/v2';
const URL_USER_ME = '$URL_WP_BASE/users/me';
const URL_REGISTER_ENDPOINT = '$URL_WP_BASE/users/register';
//

// GENERATE WP USERNAME
String generateUsernameByEmail(String email) {
  String prefix = "";
  String endfix = "_" +
      DateTime.now().day.toString() +
      DateTime.now().month.toString() +
      DateTime.now().year.toString() +
      '_' +
      DateTime.now().hour.toString() +
      DateTime.now().minute.toString();
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

// ORDER STATUS
String getOrderStatusDisplayName(String status) {
  if (status == 'pending')
    return 'ÖDEME BEKLENİYOR';
  else if (status == 'processing')
    return 'İŞLENİYOR';
  else if (status == 'on-hold')
    return 'BEKLEMEDE';
  else if (status == 'completed')
    return 'TAMAMLANDI';
  else if (status == 'cancelled')
    return 'İPTAL EDİLDİ';
  else if (status == 'refunded')
    return 'İADE EDİLDİ';
  else if (status == 'failed')
    return 'BAŞARISIZ';
  else if (status == 'trash') return 'SİLİNMİŞ SİPARİŞ';
  return 'ÖDEME BEKLENİYOR';
}

// in app
WooCustomer loggedInCustomer;
List<WooProductCategory> categories = new List<WooProductCategory>();
List<WooProduct> featuredProducts = new List<WooProduct>();
List<WooProduct> yenilikler = new List<WooProduct>();

List<WooProduct> favoriteProducts = new List<WooProduct>();
bool isRefreshCart = true;
List<CoCartItem> cartItems = List<CoCartItem>();
bool isRefreshOrders = true;
List<WooOrder> orders = new List<WooOrder>();


