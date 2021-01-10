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
  List<WooProduct> favList = new List<WooProduct>();
  bool isLoad = false;

  void loadFavs() {
    setState(() {
      isLoad = false;
    });
    if (loggedInCustomer != null) {
      CustomApiService.loadFavProducts().then((value) {
        setState(() {
          favList = favoriteProducts;
          isLoad = true;
        });
      });
    } else {
      setState(() {
        isLoad = true;
      });
    }
  }

  @override
  void initState() {
    this.loadFavs();
    super.initState();
  }

  Widget renderBody() {
    if (!isLoad) {
      return Center(child: CircularProgressIndicator());
    }
    if (loggedInCustomer != null && favList.length == 0) {
      return Center(child: Text('Favori ürününüz bulunmamaktadır.'));
    }
    return loggedInCustomer != null
        ? Column(
            children: favList
                .map((p) => ListTile(
                      title: Text(p.name),
                      leading: p.images.length > 0
                          ? Image(
                              image: NetworkImage(p.images[0].src),
                            )
                          : Text(""),
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(p),
                          ),
                        )
                            .then((value) {
                          if (CustomApiService.isRefreshFavorites) {
                            this.loadFavs();
                          }
                        });
                      },
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: Text(''),
          leadingWidth: 0,
          title: Text(
            getText("tab_favs"),
            style: TextStyle(
              color: colorDark,
              fontSize: Theme.of(context).textTheme.headline5.fontSize,
            ),
          ),
        ),
        renderBody(),
      ],
    );
  }
}
