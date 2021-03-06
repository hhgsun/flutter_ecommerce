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
  bool isMoreBtn = true;
  bool isMoreLoading = false;
  int _page = 1;

  void loadProducts({int page = 1, String order, String orderBy}) {
    if (!isMoreLoading) {
      setState(() {
        isLoad = false;
      });
    }
    if (widget.catId.isNotEmpty && widget.catId != "") {
      woocommerce
          .getProducts(
        category: widget.catId,
        perPage: perPage,
        page: page,
        order: order,
        orderBy: orderBy,
      )
          .then((value) {
        setState(() {
          value.forEach((element) {
            this.productList.add(element);
          });
          if (value.length < perPage) {
            this.isMoreBtn = false;
          }
          if (!isMoreLoading) {
            this.isLoad = true;
          } else {
            this.isMoreLoading = false;
          }
        });
      });
    } else if (widget.tagId.isNotEmpty && widget.tagId != "") {
      woocommerce
          .getProducts(
        tag: widget.tagId,
        perPage: perPage,
        page: page,
        order: order,
        orderBy: orderBy,
      )
          .then((value) {
        setState(() {
          value.forEach((element) {
            this.productList.add(element);
          });
          if (value.length < perPage) {
            this.isMoreBtn = false;
          }
          if (!isMoreLoading) {
            this.isLoad = true;
          } else {
            this.isMoreLoading = false;
          }
        });
      });
    } else {
      setState(() {
        isLoad = true;
      });
    }
  }

  @override
  void initState() {
    this.loadProducts();
    super.initState();
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
          children: [
            ProductGridviewComp(this.productList),
            this.isMoreBtn
                ? !this.isMoreLoading
                    ? FlatButton(
                        height: 50.0,
                        onPressed: () {
                          setState(() {
                            this.isMoreLoading = true;
                          });
                          this._page = this._page + 1;
                          this.loadProducts(page: this._page);
                        },
                        child: Text('Daha Fazla'),
                      )
                    : Container(
                        height: 50.0,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                : this._page > 1
                    ? Container(
                        height: 50.0,
                        child: Text('Liste Sonu'),
                      )
                    : SizedBox(height: 50.0),
          ],
        ),
      );
    } else {
      return Center(
        child: Text("Ürün bulunmamaktadır."),
      );
    }
  }

  Widget renderFilterButton() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        hint: Icon(Icons.filter_alt_sharp),
        items: [
          DropdownMenuItem(
            child: Text('Önce en düşük fiyat'),
            value: 1,
          ),
          DropdownMenuItem(
            child: Text('Önce en yüksek fiyat'),
            value: 2,
          ),
          DropdownMenuItem(
            child: Text('En yeniler'),
            value: 3,
          ),
          DropdownMenuItem(
            child: Text('En eskiler'),
            value: 4,
          ),
        ],
        onChanged: (val) {
          print(val);
        },
      ),
    );
  }

  List<Map<String, String>> filterList = [
    {'order': 'desc', 'orderby': 'date', 'title': "En yeniler"},
    {'order': 'asc', 'orderby': 'date', 'title': "En eskiler"},
    {'order': 'desc', 'orderby': 'price', 'title': "Önce en yüksek fiyat"},
    {'order': 'asc', 'orderby': 'price', 'title': "Önce en düşük fiyat"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title != null ? widget.title : ''),
        actions: [
          PopupMenuButton(
            tooltip: 'Sıralama',
            icon: Icon(Icons.filter_alt_sharp),
            onSelected: (val) {
              setState(() {
                this._page = 1;
                this.productList = new List<WooProduct>();
              });
              this.loadProducts(order: val['order'], orderBy: val['orderby']);
            },
            itemBuilder: (BuildContext context) {
              return filterList.map((Map filter) {
                return PopupMenuItem<Map>(
                  value: filter,
                  child: Text(filter['title']),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: renderBody(context),
    );
  }
}
