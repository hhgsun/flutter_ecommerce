import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/pages/account_page.dart';
import 'package:ecommerceapp/pages/cart_page.dart';
import 'package:ecommerceapp/pages/categories_page.dart';
import 'package:ecommerceapp/pages/favorites_page.dart';
import 'package:ecommerceapp/pages/home_page.dart';
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

  getProducts() {
    woocommerce.getProducts().then((value) {
      print(value.toString());
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
              gradient:
                  LinearGradient(colors: [Colors.redAccent, Colors.orangeAccent]),
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
                child: Text(getText("tab_home"))
              ),
              Tab(
                icon: Icon(Icons.category_rounded),
                iconMargin: EdgeInsets.only(bottom: 5),
                child: Text(getText("tab_cats"))
              ),
              Tab(
                icon: Icon(Icons.star_rate_rounded),
                iconMargin: EdgeInsets.only(bottom: 5),
                child: Text(getText("tab_favs"))
              ),
              Tab(
                icon: Icon(Icons.shopping_basket_rounded),
                iconMargin: EdgeInsets.only(bottom: 5),
                child: Text(getText("tab_cart"))
              ),
              Tab(
                icon: Icon(Icons.person),
                iconMargin: EdgeInsets.only(bottom: 5),
                child: Text(getText("tab_account"))
              ),
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

///////// sil
/* class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
} */
