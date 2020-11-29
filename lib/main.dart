import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/pages/account_page.dart';
import 'package:ecommerceapp/pages/cart_page.dart';
import 'package:ecommerceapp/pages/categories_page.dart';
import 'package:ecommerceapp/pages/favorites_page.dart';
import 'package:ecommerceapp/pages/home_page.dart';
import 'package:ecommerceapp/pages/login_page.dart';
import 'package:ecommerceapp/pages/splashscreen_page.dart';
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

class CustomTabPage {
  AppBar head;
  Widget body;
  CustomTabPage({this.head, this.body});
}

enum STATS_AUTH { login, logout, wait }

class TabsContainer extends StatefulWidget {
  @override
  _TabsContainerState createState() => _TabsContainerState();
}

class _TabsContainerState extends State<TabsContainer> {
  int selectedPageIndex = 0;

  List<CustomTabPage> pages = [
    CustomTabPage(
      head: AppBar(
        title: Text(getText("tab_home")),
        centerTitle: true,
      ),
      body: HomePage(),
    ),
    CustomTabPage(
      head: AppBar(
        title: Text(getText("tab_cats")),
      ),
      body: CategoriesPage(),
    ),
    CustomTabPage(
      head: AppBar(
        title: Text(getText("tab_favs")),
      ),
      body: FavoritesPage(),
    ),
    CustomTabPage(
      head: AppBar(
        title: Text(getText("tab_cart")),
      ),
      body: CartPage(),
    ),
    CustomTabPage(
      head: AppBar(
        title: Text(getText("tab_account")),
      ),
      body: AccountPage(),
    ),
  ];

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
          _statsAuth = STATS_AUTH.login;
        } else {
          _statsAuth = STATS_AUTH.logout;
        }
      });
    });
  }

  Widget _renderBody(context) {
    if (_statsAuth == STATS_AUTH.login) {
      DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: pages[selectedPageIndex].head,
          body: pages[selectedPageIndex].body,
          bottomNavigationBar: Material(
            color: Colors.grey[100],
            child: TabBar(
              labelPadding: EdgeInsets.all(1),
              indicatorPadding: EdgeInsets.all(0),
              unselectedLabelColor: Colors.redAccent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.orangeAccent]),
                /* borderRadius: BorderRadius.circular(10), */
                color: Colors.redAccent,
              ),
              onTap: (int index) {
                setState(() {
                  selectedPageIndex = index;
                });
              },
              tabs: [
                Tab(
                    icon: Icon(Icons.home_filled),
                    iconMargin: EdgeInsets.only(bottom: 5),
                    child: Text(getText("tab_home"))),
                Tab(
                    icon: Icon(Icons.category_rounded),
                    iconMargin: EdgeInsets.only(bottom: 5),
                    child: Text(getText("tab_cats"))),
                Tab(
                    icon: Icon(Icons.star_rate_rounded),
                    iconMargin: EdgeInsets.only(bottom: 5),
                    child: Text(getText("tab_favs"))),
                Tab(
                    icon: Icon(Icons.shopping_basket_rounded),
                    iconMargin: EdgeInsets.only(bottom: 5),
                    child: Text(getText("tab_cart"))),
                Tab(
                    icon: Icon(Icons.person),
                    iconMargin: EdgeInsets.only(bottom: 5),
                    child: Text(getText("tab_account"))),
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: Text("data"),
                ),
                ListTile(
                  title: Text("data"),
                )
              ],
            ),
          ),
        ),
      );
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
