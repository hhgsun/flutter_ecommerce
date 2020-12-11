import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/pages/account_page.dart';
import 'package:ecommerceapp/pages/cart_page.dart';
import 'package:ecommerceapp/pages/categories_page.dart';
import 'package:ecommerceapp/pages/favorites_page.dart';
import 'package:ecommerceapp/pages/home_page.dart';
import 'package:ecommerceapp/pages/login_page.dart';
import 'package:ecommerceapp/pages/splashscreen_page.dart';
import 'package:ecommerceapp/tabs_layout.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ECommerce());
}

class ECommerce extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TabsContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum STATS_AUTH { login, logout, wait }

class TabsContainer extends StatefulWidget {
  @override
  _TabsContainerState createState() => _TabsContainerState();
}

class _TabsContainerState extends State<TabsContainer> {
  STATS_AUTH _statsAuth = STATS_AUTH.wait;

  @override
  void initState() {
    super.initState();
    setState(() {
      _statsAuth = STATS_AUTH.wait;
    });
    woocommerce.isCustomerLoggedIn().then((value) {
      setState(() {
        if (value) {
          woocommerce.fetchLoggedInUserId().then((id) {
            print("OTURUM AÇIK, USER ID: " + id.toString());
          });
          _statsAuth = STATS_AUTH.login;
        } else {
          _statsAuth = STATS_AUTH.logout;
        }
      });
    });
  }

  Widget _renderBody(context) {
    if (_statsAuth == STATS_AUTH.login) {
      return TabLayout();
    }
    if (_statsAuth == STATS_AUTH.logout) {
      return LoginPage();
    }
    return SplashScreenPage();
  }

  @override
  Widget build(BuildContext context) {
    return this._renderBody(context);
  }
}
