import 'package:ecommerceapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/models/products.dart';

class ProductListPage extends StatefulWidget {
  ProductListPage({Key key, this.title, this.catId}) : super(key: key);

  final String title;
  final String catId;

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<WooProduct> productList = [];
  bool isLoad = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoad = false;
    });
    woocommerce.getProducts(category: widget.catId).then((value) {
      setState(() {
        isLoad = true;
        this.productList = value;
      });
    });
  }

  Widget renderBody(context) {
    if (!this.isLoad) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (this.productList.length > 0) {
      return SingleChildScrollView(
        child: Column(
          children: this
              .productList
              .map((p) => ListTile(
                    title: Text(p.name),
                    subtitle: Text(p.price),
                  ))
              .toList(),
        ),
      );
    } else {
      return Center(
        child: Text("Ürün bulunmamaktadır."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: renderBody(context),
    );
  }
}
