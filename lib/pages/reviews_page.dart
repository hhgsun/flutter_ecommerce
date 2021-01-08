import 'package:ecommerceapp/models/product_review.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/widgets/review_item_comp.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatefulWidget {
  final WooProduct product;
  final List<WooProductReview> reviews;

  const ReviewsPage(this.reviews, this.product, {Key key}) : super(key: key);
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  List<WooProductReview> reviews;
  WooProduct product;
  @override
  void initState() {
    reviews = widget.reviews;
    product = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ürün Değerlendirmeleri"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0),
            ListTile(
              leading: product.images.length > 0
                  ? Image.network(product.images.first.src)
                  : Text(''),
              title: Text(product.name),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Divider(),
            ReviewItemComp(widget.product, reviews: reviews)
          ],
        ),
      ),
    );
  }
}
