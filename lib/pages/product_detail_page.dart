import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/widgets/addtocart_comp.dart';
import 'package:ecommerceapp/widgets/favorite_comp.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final WooProduct product;

  const ProductDetailPage(this.product, {Key key}) : super(key: key);
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  WooProduct _product;
  bool isFav = false;
  @override
  void initState() {
    _product = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.name),
        actions: [
          FavoriteComp(_product),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(_product.images.first.src),
            // Text("Satışta: " + _product.onSale.toString()),
            AddToCartComp(_product),// add to cart
            Divider(),
            ListTile(
              title: Text("Fiyat:"),
              subtitle: Text(_product.price),
            ),
            ListTile(
              title: Text("Reqular Fiyat:"),
              subtitle: Text(_product.regularPrice),
            ),
            ListTile(
              title: Text("Sale Fiyat:"),
              subtitle: Text(_product.salePrice),
            ),
            Text(_product.toString()),
          ],
        ),
      ),
    );
  }
}
