import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/widgets/product_gridview_comp.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  ProductListPage({Key key, this.title, this.catId, this.tagId})
      : super(key: key);

  final String title;
  final String catId;
  final String tagId;

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<WooProduct> productList = new List<WooProduct>();
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoad = false;
    });
    if (widget.catId.isNotEmpty && widget.catId != "") {
      woocommerce.getProducts(category: widget.catId).then((value) {
        setState(() {
          isLoad = true;
          this.productList = value;
        });
      });
    } else if (widget.tagId.isNotEmpty && widget.tagId != "") {
      woocommerce.getProducts(tag: widget.tagId).then((value) {
        setState(() {
          isLoad = true;
          this.productList = value;
        });
      });
    } else {
      setState(() {
        isLoad = true;
      });
    }
  }

  Widget renderBody(context) {
    if (!this.isLoad) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (this.productList.length > 0) {
      return ProductGridviewComp(this.productList);
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
        title: Text(widget.title != null ? widget.title : ''),
      ),
      body: renderBody(context),
    );
  }
}
