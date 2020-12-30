import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/pages/login_page.dart';
import 'package:ecommerceapp/pages/product_detail_page.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:ecommerceapp/utils/form_helper.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<WooProduct> favList = [];

  @override
  void initState() {
    favoriteProducts.forEach((id) {
      woocommerce.getProductById(id: int.parse(id)).then((product) {
        setState(() {
          favList.add(product);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loggedInCustomer != null
        ? Column(
            children: favList
                .map((p) => ListTile(
                      title: Text(p.name),
                      leading: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            CustomApiService.deleteFavs(p.id.toString()).then(
                              (value) {
                                int index = this.favList.indexOf(p);
                                setState(() {
                                  this.favList.remove(index);
                                });
                              },
                            );
                          }),
                      trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_sharp),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(p),
                              ),
                            );
                          }),
                    ))
                .toList(),
          )
        : Center(
            child: FormHelper.button("Giriş Yap", () {
              Navigator.of(context).pop(
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    title: 'Giriş Yap',
                  ),
                ),
              );
            }),
          );
  }
}
