import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/utils/show_dialog_custom.dart';
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
                    onTap: () {
                      showDialogCustom(context,
                          title: cat.name, subTitle: cat.menuOrder.toString());
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
