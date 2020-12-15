import 'package:ecommerceapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/models/products.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WooProduct> _oneCikanlar = [];
  List<WooProduct> _yenilikler = [];

  @override
  void initState() {
    super.initState();
    woocommerce.getProducts(featured: true).then((value) {
      setState(() {
        this._oneCikanlar = value;
      });
    });

    woocommerce.getProducts().then((value) {
      setState(() {
        this._yenilikler = value;
      });
    });
  }

  Column _widgets(List<WooProduct> list) => Column(
        children: list.length > 0
            ? list
                .map((e) => ListTile(
                      title: Text(e.name),
                      leading: e.images.length > 0 ? Image(
                        image: NetworkImage(e.images[0].src),
                      ) : Text("NO IMG"),
                    ))
                .toList()
            : [Text("BOŞ")],
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Öne Çıkanlar", style: TextStyle(fontWeight: FontWeight.bold)),
          _widgets(_oneCikanlar),
          Text("Yenilikler", style: TextStyle(fontWeight: FontWeight.bold)),
          _widgets(_yenilikler),
        ],
      ),
    );
  }
}
