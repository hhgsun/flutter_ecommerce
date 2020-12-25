import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/pages/product_detail_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WooProduct> _featuredProducts = [];
  List<WooProduct> _yenilikler = [];

  @override
  void initState() {
    super.initState();
    if (_featuredProducts == null || _featuredProducts.length == 0) {
      woocommerce.getProducts(featured: true).then((value) {
        setState(() {
          this._featuredProducts = value;
        });
      });
    }

    if (_yenilikler == null || _yenilikler.length == 0) {
      woocommerce.getProducts().then((value) {
        if (value != null && value.length > 0) {
          setState(() {
            this._yenilikler = value;
          });
        }
      });
    }
  }

  Column _widgets(List<WooProduct> list) => Column(
        children: list.length > 0
            ? list
                .map((p) => ListTile(
                      title: Text(p.name),
                      leading: p.images.length > 0
                          ? Image(
                              image: NetworkImage(p.images[0].src),
                            )
                          : Text("NO IMG"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(p),
                          ),
                        );
                      },
                    ))
                .toList()
            : [Text("BOŞ")],
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: Text(
                "Öne Çıkanlar",
                style: TextStyle(color: colorDark, fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _featuredProducts
                    .map((f) => Container(
                          width: MediaQuery.of(context).size.width - 40.0,
                          margin: EdgeInsets.fromLTRB(10, 10, 5, 10),
                          child: Stack(
                            overflow: Overflow.clip,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  f.images.first.src,
                                  fit: BoxFit.cover,
                                  width: double.maxFinite,
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                              Positioned(
                                left: 20,
                                bottom: 30,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100.0,
                                  child: Text(
                                    f.name,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .fontSize,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0.5, 1.0),
                                            blurRadius: 3.0,
                                            color: Colors.black,
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: colorLightDart,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Divider(),
            Text("Yenilikler", style: TextStyle(fontWeight: FontWeight.bold)),
            _widgets(_yenilikler),
          ],
        ),
      ),
    );
  }
}
