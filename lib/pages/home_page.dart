import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/pages/product_detail_page.dart';
import 'package:ecommerceapp/pages/product_list_page.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:ecommerceapp/widgets/search_comp.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (featuredProducts == null || featuredProducts.length == 0) {
      woocommerce.getProducts(featured: true, page: 1).then((value) {
        setState(() {
          featuredProducts = value;
        });
      });
    }

    if (yenilikler == null || yenilikler.length == 0) {
      woocommerce.getProducts().then((value) {
        if (value != null && value.length > 0) {
          setState(() {
            yenilikler = value;
          });
        }
      });
    }

    if (bannersHome == null || bannersHome.length == 0) {
      CustomApiService.getBanners().then((value) {
        if (value.data != null && value.data.length > 0) {
          setState(() {
            bannersHome = value.data;
          });
        }
      });
    }

    if (homeCats == null || homeCats.length == 0) {
      CustomApiService.getCatBanners().then((value) {
        if (value.data != null && value.data.length > 0) {
          setState(() {
            homeCats = value.data;
          });
        }
      });
    }
  }

  Widget renderBannersHome() {
    if (bannersHome.length > 0)
      return Column(
        children: bannersHome
            .map((banner) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductListPage(
                          title: banner.title,
                          catId: banner.catId,
                          tagId: banner.tagId,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(banner.imageUrl),
                    ),
                  ),
                ))
            .toList(),
      );
    return Container(
      height: MediaQuery.of(context).size.width / 2,
      child: Center(child: CircularProgressIndicator()),
    );
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: Text(''),
            title: Container(
              height: 40,
              padding: EdgeInsets.only(bottom: 5),
              child: Image(
                image: AssetImage('assets/images/head-logo.png'),
                fit: BoxFit.contain,
              ),
            ),
            centerTitle: true,
          ),
          SearchBox(),
          Divider(height: 10.0),
          renderHomeCatsTags(),
          Container(
            margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
            child: Text(
              "Öne Çıkanlar",
              style: TextStyle(
                color: colorDark,
                fontSize: Theme.of(context).textTheme.headline5.fontSize,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: featuredProducts
                  .map((f) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(f),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40.0,
                          margin: EdgeInsets.fromLTRB(10, 2, 5, 10),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Divider(),
          renderBannersHome(),
          Divider(),
          Container(
            margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
            child: Text(
              "Yenilikler",
              style: TextStyle(
                color: colorDark,
                fontSize: Theme.of(context).textTheme.headline5.fontSize,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          _widgets(yenilikler),
        ],
      ),
    );
  }

  Widget renderHomeCatsTags() {
    double itemWidth = 100.0;
    double itemHeight = 130.0;
    if (homeCats.length > 0)
      return Container(
        height: itemHeight,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: homeCats
              .map(
                (c) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductListPage(
                          title: c.title,
                          catId: c.catId,
                          tagId: c.tagId,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: itemHeight - 30.0,
                          width: itemWidth,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.black12,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(c.imageUrl),
                          ),
                        ),
                        Container(
                          width: itemWidth,
                          margin: EdgeInsets.only(top: 3.0),
                          alignment: Alignment.center,
                          child: Text(c.title, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    return Container(
      height: itemHeight,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
