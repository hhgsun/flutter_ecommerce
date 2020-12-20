import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/customer.dart';
import 'package:ecommerceapp/pages/account_page.dart';
import 'package:ecommerceapp/pages/cart_page.dart';
import 'package:ecommerceapp/pages/categories_page.dart';
import 'package:ecommerceapp/pages/favorites_page.dart';
import 'package:ecommerceapp/pages/home_page.dart';
import 'package:ecommerceapp/pages/login_page.dart';
import 'package:flutter/material.dart';

class TabsLayout extends StatefulWidget {
  @override
  _TabsLayoutState createState() => _TabsLayoutState();
}

class CustomTabPage {
  AppBar head;
  Widget body;
  CustomTabPage({this.head, this.body});
}

class _TabsLayoutState extends State<TabsLayout> {
  int selectedPageIndex = 0;

  CustomTabPage tabViews(context, int index) => [
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
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    woocommerce.logUserOut();
                    loggedInCustomer = new WooCustomer();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }),
            ],
          ),
          body: AccountPage(),
        ),
      ][index];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: tabViews(context, selectedPageIndex).head,
        body: tabViews(context, selectedPageIndex).body,
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
}
