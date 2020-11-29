import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/pages/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/models/product_category.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

List<WooProductCategory> cats = [];

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    if (cats.length == 0) {
      woocommerce.getProductCategories().then((res) {
        print("res cats: " + res.length.toString());
        setState(() {
          cats = res;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cats.length > 0) {
      return SingleChildScrollView(
        child: Column(
          children: cats
              .map((cat) => ListTile(
                    leading: cat.image?.src != null
                        ? Image(image: NetworkImage(cat.image?.src))
                        : Text("YOK"),
                    title: Text(cat.name),
                    trailing: Text(cat.count.toString()),
                    onTap: () {
                      /* showDialogCustom(context,
                          title: cat.name, subTitle: cat.menuOrder.toString()); */
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductListPage(
                            title: cat.name,
                            catId: cat.id.toString(),
                          ),
                        ),
                      );
                    },
                  ))
              .toList(),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
