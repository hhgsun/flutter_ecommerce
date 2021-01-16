import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/pages/product_detail_page.dart';
import 'package:flutter/material.dart';

class ProductGridviewComp extends StatelessWidget {
  final List<WooProduct> productList;

  const ProductGridviewComp(this.productList, {Key key}) : super(key: key);

  List<Row> twoColumnWidgetGenerate(context) {
    List<Row> rows = new List<Row>();
    List<Widget> rowItems = new List<Widget>();
    for (var i = 0; i < this.productList.length; i++) {
      rowItems.add(this.renderItem(context, i));
      if (i % 2 != 0) {
        rows.add(new Row(
          children: rowItems,
        ));
        rowItems = new List<Widget>();
      }
    }
    return rows;
  }

  Widget renderItem(context, int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(this.productList[index]),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width / 2 - 20,
        height: 280.0,
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
                renderRating(context, this.productList[index].averageRating),
                Row(
                  children: [
                    this.productList[index].regularPrice != null
                        ? Text(
                            this.productList[index].regularPrice + ' TL',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough),
                          )
                        : Text(''),
                    Text(
                      ' ' + this.productList[index].price + ' TL ',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: this.twoColumnWidgetGenerate(context).toList(),
    );

    /* var mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 7.0,
      mainAxisSpacing: 7.0,
      padding: EdgeInsets.all(5.0),
      childAspectRatio: widthScreen / (heightScreen - 200), //0.8,
      children: List.generate(
        this.productList.length,
        (index) => this.renderItem(context, index),
      ),
    ); */
  }
}
