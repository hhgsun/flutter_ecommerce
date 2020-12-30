import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:ecommerceapp/utils/show_dialog_custom.dart';
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
          FavoriteComp(_product.id),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(_product.images.first.src),
            Text("Satışta: " + _product.onSale.toString()),
            Divider(),
            MaterialButton(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(10.0),
                color: Colors.redAccent,
                alignment: Alignment.center,
                child: Text(
                  "Sepete Ekle",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                CustomApiService.addCart(_product.id.toString(), "1")
                    .then((value) {
                  if (value.success) {
                    showDialogCustom(context, subTitle: "Ürün Sepete Eklendi");
                  } else {
                    showDialogCustom(context, subTitle: value.message);
                  }
                });
              },
            ),
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
