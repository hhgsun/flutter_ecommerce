import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/pages/product_list_page.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    if (categories.length == 0) {
      woocommerce.getProductCategories().then((res) {
        print("res cats: " + res.length.toString());
        setState(() {
          categories = res;
        });
      });
    }
    super.initState();
  }

  Widget renderBody() {
    if (categories.length > 0) {
      return Column(
          children: categories
              .map((c) => InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductListPage(
                            title: c.name,
                            catId: c.id.toString(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.width / 2,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                      child: Text(
                        c.name,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.headline5.fontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(
                                offset: Offset(0.5, 1.0),
                                blurRadius: 3.0,
                                color: Colors.black,
                              ),
                            ]),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5.0),
                        image: c.image != null
                            ? DecorationImage(
                                image: NetworkImage(c.image.src),
                                fit: BoxFit.cover)
                            : null,
                      ),
                    ),
                  ))
              .toList());
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: Text(''),
            leadingWidth: 0,
            title: Text(
              getText("tab_cats"),
              style: TextStyle(
                color: colorDark,
                fontSize: Theme.of(context).textTheme.headline5.fontSize,
              ),
            ),
          ),
          renderBody(),
        ],
      ),
    );
  }
}
