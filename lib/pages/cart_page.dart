import 'package:ecommerceapp/models/cocart_item.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CoCartItem> itemList;

  void getCart() {
    CustomApiService.getCart().then((value) {
      setState(() {
        itemList = value.data;
      });
    });
  }

  @override
  void initState() {
    this.getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: itemList != null
                ? itemList.map((p) {
                    return ListTile(
                      title: Text(p.productName),
                      subtitle:
                          Text(p.quantity.toString() + ' x ' + p.productPrice),
                      trailing: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          CustomApiService.deleteCart(p.key).then((value) {
                            print(value.data);
                            this.getCart();
                          });
                        },
                      ),
                    );
                  }).toList()
                : [],
          ),
          MaterialButton(
            child: Text("GET NONCE"),
            onPressed: () {
              CustomApiService.createNonce().then((value) {
                print(value.data);
              });
            },
          ),
          MaterialButton(
            child: Text("SEPETİM GÖSTER"),
            onPressed: () {
              this.getCart();
            },
          ),
          Divider(height: 50),
          MaterialButton(
            child: Text("ekle sepet"),
            onPressed: () {
              CustomApiService.addCart("16", "2").then((value) {
                setState(() {
                  itemList = value.data;
                });
              });
            },
          ),
          Divider(height: 50),
          MaterialButton(
              child: Text("sil sepetten"),
              onPressed: () {
                CustomApiService.deleteCart("1f0e3dad99908345f7439f8ffabdffc4");
              }),
          Divider(height: 50),
          MaterialButton(
            child: Text("OrderPayload Create Test"),
            onPressed: () async {
              CustomApiService.getCart().then((value) {
                print(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
