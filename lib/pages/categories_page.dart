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

  @override
  Widget build(BuildContext context) {
    if (categories.length > 0) {
      return GridView.count(
        crossAxisCount: 2,
        children: categories
            .map(
              (c) => InkWell(
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
                  margin: EdgeInsets.all(5.0),
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
                    image: c.image != null
                        ? DecorationImage(
                            image: NetworkImage(c.image.src),
                          )
                        : null,
                  ),
                ),
              ),
            )
            .toList(),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
