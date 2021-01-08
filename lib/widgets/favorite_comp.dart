import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:flutter/material.dart';

class FavoriteComp extends StatefulWidget {
  final WooProduct product;
  const FavoriteComp(this.product, {Key key}) : super(key: key);
  @override
  _FavoriteCompState createState() => _FavoriteCompState();
}

class _FavoriteCompState extends State<FavoriteComp> {
  WooProduct product;
  bool isFav = false;
  bool isLoad = false;

  @override
  void initState() {
    product = widget.product;
    setState(() {
      isFav = CustomApiService.isFav(product.id);
      isLoad = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoad == false) {
      return IconButton(
        icon: Icon(Icons.favorite_border),
        onPressed: null,
      );
    }
    return isFav
        ? IconButton(
            color: colorPrimary,
            tooltip: 'Favorilerimden Kaldır',
            icon: Icon(Icons.favorite),
            onPressed: () {
              setState(() {
                isLoad = false;
              });
              CustomApiService.deleteFavs(this.product).then((value) {
                if (value.success)
                  setState(() {
                    isFav = false;
                    isLoad = true;
                  });
              });
            })
        : IconButton(
            color: colorPrimary,
            tooltip: 'Favorilerime Ekle',
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              setState(() {
                isLoad = false;
              });
              CustomApiService.addFavs(this.product).then((value) {
                if (value.success)
                  setState(() {
                    isFav = true;
                    isLoad = true;
                  });
              });
            },
          );
  }
}
