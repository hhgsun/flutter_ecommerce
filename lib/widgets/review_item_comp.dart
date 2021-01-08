import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/product_review.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/pages/reviews_page.dart';
import 'package:flutter/material.dart';

class ReviewItemComp extends StatefulWidget {
  final WooProduct product;
  final List<WooProductReview> reviews;
  const ReviewItemComp(this.product, {Key key, this.reviews}) : super(key: key);
  @override
  _ReviewItemCompState createState() => _ReviewItemCompState();
}

class _ReviewItemCompState extends State<ReviewItemComp> {
  List<WooProductReview> reviews = new List<WooProductReview>();
  bool isLoadReviews = false;
  bool onlyFirstItem = false;

  @override
  void initState() {
    setState(() {
      isLoadReviews = false;
    });
    if (widget.reviews != null) {
      setState(() {
        this.reviews = widget.reviews;
        isLoadReviews = true;
      });
    } else {
      setState(() {
        this.onlyFirstItem = true;
      });
      this.loadReviews();
    }
    super.initState();
  }

  void loadReviews() {
    woocommerce.getProductReviews(product: [widget.product.id]).then((value) {
      if (value.length > 0) {
        setState(() {
          reviews = value;
        });
      }
      setState(() {
        isLoadReviews = true;
      });
    }).catchError((onError) {
      setState(() {
        isLoadReviews = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadReviews) {
      if (reviews.length > 0) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              onlyFirstItem
                  ? Column(
                      children: [
                        this.renderDetailPageReviewHeader(),
                        this.renderItem(reviews.first),
                      ],
                    )
                  : Column(
                      children: reviews
                          .map((r) => this.renderItem(r, iconSize: 15))
                          .toList(),
                    ),
            ],
          ),
        );
      }
      return Container(
        height: 130.0,
        child: Center(
          child: Text('Henüz hiç inceleme yapılmamış'),
        ),
      );
    }
    return Container(
      height: 130.0,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget renderItem(WooProductReview rev, {double iconSize = 12}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              rev.reviewer,
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(width: 5.0),
            renderRating(context, rev.rating.toString(), iconSize: iconSize),
          ],
        ),
        Text(removeAllHtmlTags(rev.review)),
        Divider(),
      ],
    );
  }

  Widget renderDetailPageReviewHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Ürün Değerlendirmeleri',
            style: TextStyle(fontSize: 15, color: Colors.black54)),
        FlatButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReviewsPage(this.reviews, widget.product),
              ),
            );
          },
          child: Row(
            children: [
              Text('Tümünü Gör'),
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
