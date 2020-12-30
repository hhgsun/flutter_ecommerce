import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/cocart_item.dart';
import 'package:ecommerceapp/models/order_payload.dart';
import 'package:ecommerceapp/pages/login_page.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:ecommerceapp/utils/form_helper.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CoCartItem> _itemList;
  CoCartTotals _totals;
  int lastOrderId;

  bool loading = true;

  void getCart() {
    setState(() {
      loading = true;
    });
    CustomApiService.getCart().then((value) {
      setState(() {
        _itemList = value.data;
      });
      this.getTotals();
      print(value.message);
      setState(() {
        loading = false;
      });
    });
  }

  void getTotals() {
    CustomApiService.totalsCart().then((value) {
      setState(() {
        _totals = value.data;
      });
    });
  }

  @override
  void initState() {
    if (loggedInCustomer != null) {
      this.getCart();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loggedInCustomer == null) {
      return Center(
        child: FormHelper.button("Giriş Yap", () {
          Navigator.of(context).pop(
            MaterialPageRoute(
              builder: (context) => LoginPage(
                title: 'Giriş Yap',
              ),
            ),
          );
        }),
      );
    }
    if (loading) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (_itemList == null) {
        return Center(
          child: Text("Sepet Henüz Boş"),
        );
      }
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Column(
            children: (_itemList != null && _itemList.length > 0)
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
            subtitle: Text((_totals != null && _totals.total.isNotEmpty)
                ? _totals.total
                : ''),
          ),
          Divider(height: 50),
          FormHelper.button("Sepeti Onayla", () {
            List<LineItem> lineItems = new List<LineItem>();
            _itemList.forEach((i) {
              lineItems.add(new LineItem(
                productId: i.productId,
                quantity: i.quantity,
              ));
            });
            WooOrderPayload wooOrderPayload = new WooOrderPayload(
              lineItems: lineItems,
              customerId: loggedInCustomer.id,
              billing: WooOrderPayloadBilling.fromJson(
                loggedInCustomer.billing.toJson(),
              ),
              shipping: WooOrderPayloadShipping.fromJson(
                loggedInCustomer.shipping.toJson(),
              ),
            );
            woocommerce.createOrder(wooOrderPayload).then((value) {
              lastOrderId = value.id;
              print('lastOrderId: ' + lastOrderId.toString());
              if (lastOrderId != null) {
                CustomApiService.clearCart().then((value) {
                  this.getCart();
                });
              }
            });
          }),
          Divider(height: 50),
        ],
      ),
    );
  }
}
