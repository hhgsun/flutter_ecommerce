import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
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
                      trailing: IconButton(
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
                    ))
                .toList(),
          )
        : Text("no login user");
  }
}
