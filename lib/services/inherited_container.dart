import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/models/cart.dart';
import 'package:woocommerce/models/products.dart';

// base data
class BaseContainerState<T> extends State<BaseContainer> {

  // Cart 
  
  // https://github.com/co-cart/co-cart //bu wp için sepet rest api eklentisi

  WooCart cart = new WooCart();

  void addCart(WooProduct p){
    cart.items.forEach((element) {
      
    });
  }

  // Favorites

  List<String> favs = new List<String>();

  Future<bool> addFav(String productid) async {
    if (this.favs.contains(productid) == false)
      return CustomApiService.addFavs(productid).then((res) {
        if (res.success) {
          setState(() {
            this.favs.add(productid);
          });
        }
        return res.success;
      });
    return true;
  }

  Future<bool> deleteFav(String productid) async {
    //if (this.all.contains(productid))
    return CustomApiService.deleteFavs(productid).then((res) {
      if (res.success) {
        setState(() {
          this.favs.remove(productid.toString());
        });
      }
      return res.success;
    });
  }

  bool isFav(String productid) {
    return this.favs.contains(productid);
  }

  void fetchFromUserFavs() {
    dynamic favs = loggedInCustomer.metaData
        .where((m) => m.key == 'favorite_products')
        .first
        .value;
    setState(() {
      this.favs = List.from(favs).map((e) => e.toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class BaseContainer extends StatefulWidget {
  final Widget child;
  BaseContainer({@required this.child});

  static _InheritedStateContainer of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedStateContainer>();
  }

  @override
  BaseContainerState createState() => new BaseContainerState();
}

// inherited class
class _InheritedStateContainer<T> extends InheritedWidget {
  final BaseContainerState<T> data;

  _InheritedStateContainer({
    @required this.data,
    @required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
