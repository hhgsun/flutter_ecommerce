import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/cocart_item.dart';
import 'package:ecommerceapp/models/order_payload.dart';
import 'package:ecommerceapp/models/payment_gateway.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CoCartItem> _itemList;
  CoCartTotals _totals;
  int lastOrderId;

  void getCart() {
    CustomApiService.getCart().then((value) {
      setState(() {
        _itemList = value.data;
      });
      this.getTotals();
    });
  }

  void getTotals() {
    CustomApiService.totalsCart().then((value) {
      print(value.data);
      setState(() {
        _totals = value.data;
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
            children: _itemList != null
                ? _itemList.map((p) {
                    return ListTile(
                      leading: Image.network(p.productImage),
                      title: Text(p.productName),
                      subtitle:
                          Text(p.quantity.toString() + ' x ' + p.productPrice),
                      trailing: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          CustomApiService.deleteCart(p.key).then((value) {
                            print(value.data);
                            this.getCart();
                            this.getTotals();
                          });
                        },
                      ),
                    );
                  }).toList()
                : [],
          ),
          ListTile(
            title: Text("TOPLAM"),
            subtitle: Text(_totals != null ? _totals.total : ''),
          ),
          Divider(),
          MaterialButton(
            child: Text("GET NONCE"),
            onPressed: () {
              CustomApiService.createNonce().then((value) {
                print(value.data);
              });
            },
          ),
          Divider(height: 50),
          MaterialButton(
            child: Text("OrderPayload Create Test"),
            onPressed: () async {
              List<LineItem> lineItems = new List<LineItem>();
              _itemList.forEach((i) {
                lineItems.add(new LineItem(
                  productId: i.productId,
                  quantity: i.quantity,
                ));
              });
              WooOrderPayload wooOrderPayload = new WooOrderPayload(
                lineItems: lineItems,
              );
              woocommerce.createOrder(wooOrderPayload).then((value) {
                lastOrderId = value.id;
                print(value.toString());
              });
            },
          ),
          Divider(height: 50),
          MaterialButton(
            child: Text("Onayla"),
            onPressed: () async {
              WooPaymentGateway paymentGateway = new WooPaymentGateway(
                order: this.lastOrderId,
              );
              woocommerce.updatePaymentGateway(paymentGateway).then((value) {
                print(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
