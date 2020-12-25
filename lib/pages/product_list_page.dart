import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/pages/product_detail_page.dart';
import 'package:flutter/material.dart';

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

  Widget buildRating(BuildContext context, double rating) {
    return Row(
      children: new List.generate(
        5,
        (index) {
          Icon icon;
          if (index >= rating) {
            icon = new Icon(
              Icons.star_border,
              color: colorPrimary,
              size: 15,
            );
          } else if (index > rating - 1 && index < rating) {
            icon = new Icon(
              Icons.star_half,
              color: colorPrimary,
              size: 15,
            );
          } else {
            icon = new Icon(
              Icons.star,
              color: colorPrimary,
              size: 15,
            );
          }
          return icon;
        },
      ),
    );
  }

  Widget renderBody(context) {
    var mediaQueryData = MediaQuery.of(context);
    final double widthScreen = mediaQueryData.size.width;
    final double heightScreen = mediaQueryData.size.height;

    if (!this.isLoad) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (this.productList.length > 0) {
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 7.0,
        mainAxisSpacing: 7.0,
        padding: EdgeInsets.all(5.0),
        childAspectRatio: widthScreen / (heightScreen - 200), //0.8,
        children: List.generate(
            this.productList.length,
            (index) => InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(this.productList[index]),
                      ),
                    );
                  },
                  child: Wrap(
                    children: [
                      Container(
                        height: 200.0,
                        width: double.maxFinite,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: this.productList[index].images.length > 0
                              ? Image.network(
                                  this.productList[index].images.first.src,
                                  fit: BoxFit.cover,
                                )
                              : Text(''),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Text(
                          this.productList[index].name,
                          style: Theme.of(context).textTheme.subtitle1,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          this.buildRating(
                            context,
                            double.parse(this.productList[index].averageRating),
                          ),
                          Row(
                            children: [
                              this.productList[index].regularPrice != null
                                  ? Text(
                                      this.productList[index].regularPrice +
                                          ' TL',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  : Text(''),
                              Text(
                                ' '+this.productList[index].price + ' TL ',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )),
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
