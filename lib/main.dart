import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/services/inherited_container.dart';
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
      home: BaseContainer(
        child: TabsContainer(),
      ),
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
      print("IS LOGGED IN: " + value.toString());
      if (value) {
        woocommerce.fetchLoggedInUserId().then((userid) {
          print("LOGGED IN USER ID: " + userid.toString());
          woocommerce.getCustomerById(id: userid).then((customer) {
            loggedInCustomer = customer;
            BaseContainer.of(context).data.fetchFromUserFavs();
            setState(() {
              _statsAuth = STATS_AUTH.login;
            });
          });
        });
      } else {
        setState(() {
          _statsAuth = STATS_AUTH.logout;
        });
      }
    });
  }

  Widget _renderBody(context) {
    if (_statsAuth == STATS_AUTH.login) {
      return TabsLayout();
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
