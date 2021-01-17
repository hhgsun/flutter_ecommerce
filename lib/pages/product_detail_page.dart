import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/widgets/image_gallery_comp.dart';
import 'package:ecommerceapp/widgets/addtocart_comp.dart';
import 'package:ecommerceapp/widgets/favorite_comp.dart';
import 'package:ecommerceapp/widgets/review_item_comp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart';

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

  _onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share(_product.name + ' ' + _product.permalink);
  }

  Widget renderImages() {
    List<Widget> listimages = new List<Widget>();
    if (_product.images.length > 0) {
      for (var i = 0; i < _product.images.length; i++) {
        listimages.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageGalleryComp(
                  _product.images,
                  currentPageIndex: i,
                ),
              ),
            );
          },
          child: Container(
            padding: i == 0
                ? EdgeInsets.fromLTRB(15.0, 1.0, 1.0, 1.0)
                : EdgeInsets.all(1.0),
            child: Image.network(_product.images[i].src),
          ),
        ));
      }

      return Container(
        color: _product.images.length > 1
            ? colorLightDart.withOpacity(0.3)
            : colorLightDart.withOpacity(0.08),
        height: MediaQuery.of(context).size.width - 30.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: listimages,
        ),
      );
    }
    return Center(child: Text('Ürüne ait görsel bulunmamaktadır'));
  }

  Widget renderAttributes() {
    if (_product.attributes != null && _product.attributes.length > 0) {
      return Column(
        children: _product.attributes
            .map((attr) => ListTile(
                  title: Text(attr.name),
                  subtitle: Row(
                    children:
                        attr.options.map((op) => Text(op + ', ')).toList(),
                  ),
                ))
            .toList(),
      );
    }
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Paylaş',
            icon: Icon(Icons.share, color: colorPrimary),
            onPressed: () => _onShareWithEmptyOrigin(context),
          ),
          FavoriteComp(_product),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            renderImages(),
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _product.name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_product.averageRating),
                      SizedBox(width: 5.0),
                      renderRating(context, _product.averageRating,
                          iconSize: 20.0),
                      SizedBox(width: 5.0),
                      Text('${_product.ratingCount} inceleme',
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _product.price != _product.regularPrice
                          ? Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Text(
                                _product.regularPrice + ' ₺',
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.black54,
                                    fontSize: 18),
                              ),
                            )
                          : Text(''),
                      Text(
                        _product.price + ' ₺',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _product.stockStatus == 'instock'
                ? AddToCartComp(_product) // add to cart
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mood_bad_sharp, color: colorPrimary),
                      SizedBox(width: 5.0),
                      Text('Stokta yok', style: TextStyle(color: colorPrimary))
                    ],
                  ),
            Divider(),
            renderAttributes(),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                removeAllHtmlTags(_product.description),
                style: TextStyle(fontSize: 16, height: 1.3),
              ),
            ),
            Divider(),
            ReviewItemComp(_product),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
