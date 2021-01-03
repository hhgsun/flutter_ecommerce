import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/pages/account_page.dart';
import 'package:ecommerceapp/pages/cart_page.dart';
import 'package:ecommerceapp/pages/categories_page.dart';
import 'package:ecommerceapp/pages/favorites_page.dart';
import 'package:ecommerceapp/pages/home_page.dart';
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
  double tabIconSize = 30.0;
  double tabFontSize = 13.0;

  var _shapeHeader = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(10.0),
    ),
  );

  CustomTabPage tabViews(context, int index) => [
        CustomTabPage(
          head: AppBar(
            title: Container(
              height: 40,
              padding: EdgeInsets.only(bottom: 5),
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.contain,
              ),
            ),
            centerTitle: true,
            shape: _shapeHeader,
          ),
          body: HomePage(),
        ),
        CustomTabPage(
          head: AppBar(
            title: Text(getText("tab_cats")),
            centerTitle: true,
            shape: _shapeHeader,
          ),
          body: CategoriesPage(),
        ),
        CustomTabPage(
          head: AppBar(
            title: Text(getText("tab_favs")),
            centerTitle: true,
            shape: _shapeHeader,
          ),
          body: FavoritesPage(),
        ),
        CustomTabPage(
          head: AppBar(
            title: Text(getText("tab_cart")),
            centerTitle: true,
            shape: _shapeHeader,
          ),
          body: CartPage(),
        ),
        CustomTabPage(
          head: AppBar(
            title: Text(getText("tab_account")),
            centerTitle: true,
            shape: _shapeHeader,
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 1, color: Colors.black12)],
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: 2.0, right: 2.0),
          child: TabBar(
            labelPadding: EdgeInsets.all(1),
            indicatorPadding: EdgeInsets.all(0),
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: colorLightDart,
            indicator: BoxDecoration(
              gradient: LinearGradient(colors: [colorSecondary, colorPrimary]),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              color: colorSecondary,
            ),
            onTap: (int index) {
              setState(() {
                selectedPageIndex = index;
              });
            },
            tabs: [
              Tab(
                icon: Icon(Icons.home_filled, size: tabIconSize),
                iconMargin: EdgeInsets.only(bottom: 5),
                child: Text(
                  getText("tab_home"),
                  style: TextStyle(fontSize: tabFontSize),
                ),
              ),
              Tab(
                icon: Icon(Icons.category_rounded, size: tabIconSize),
                iconMargin: EdgeInsets.only(bottom: 5),
                child: Text(
                  getText("tab_cats"),
                  style: TextStyle(fontSize: tabFontSize),
                ),
              ),
              Tab(
                icon: Icon(Icons.star_rate_rounded, size: tabIconSize),
                iconMargin: EdgeInsets.only(bottom: 5),
                child: Text(
                  getText("tab_favs"),
                  style: TextStyle(fontSize: tabFontSize),
                ),
              ),
              Tab(
                icon: Stack(
                  children: [
                    Icon(Icons.shopping_basket_rounded, size: tabIconSize),
                    (cartItems != null && cartItems.length > 0)
                        ? Positioned(
                            right: 0,
                            bottom: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: 15.0,
                                height: 15.0,
                                alignment: Alignment.center,
                                color: colorPrimary,
                                child: Text(
                                  cartItems.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : Text(''),
                  ],
                ),
                iconMargin: EdgeInsets.only(bottom: 5),
                child: Text(
                  getText("tab_cart"),
                  style: TextStyle(fontSize: tabFontSize),
                ),
              ),
              Tab(
                icon: Icon(Icons.person, size: tabIconSize),
                iconMargin: EdgeInsets.only(bottom: 5),
                child: Text(
                  getText("tab_account"),
                  style: TextStyle(fontSize: tabFontSize),
                ),
              ),
            ],
          ),
        ),
        /* drawer: Drawer(
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
        ), */
      ),
    );
  }
}
