import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:flutter/material.dart';

class FavoriteComp extends StatefulWidget {
  final int productId;
  const FavoriteComp(this.productId, {Key key}) : super(key: key);
  @override
  _FavoriteCompState createState() => _FavoriteCompState();
}

class _FavoriteCompState extends State<FavoriteComp> {
  int productId;
  bool isFav = false;
  bool isLoad = false;

  @override
  void initState() {
    productId = widget.productId;
    setState(() {
      isFav = CustomApiService.isFav(productId.toString());
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
            icon: Icon(Icons.favorite),
            onPressed: () {
              setState(() {
                isLoad = false;
              });
              CustomApiService.deleteFavs(this.productId.toString())
                  .then((value) {
                if (value.success)
                  setState(() {
                    isFav = false;
                    isLoad = true;
                  });
              });
            })
        : IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              setState(() {
                isLoad = false;
              });
              CustomApiService.addFavs(this.productId.toString()).then((value) {
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
