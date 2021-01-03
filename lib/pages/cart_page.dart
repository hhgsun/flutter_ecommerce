import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/cocart_item.dart';
import 'package:ecommerceapp/models/order.dart';
import 'package:ecommerceapp/models/order_payload.dart';
import 'package:ecommerceapp/pages/login_page.dart';
import 'package:ecommerceapp/pages/payment_page.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:ecommerceapp/utils/form_helper.dart';
import 'package:ecommerceapp/utils/loading_dialog.dart';
import 'package:ecommerceapp/widgets/order_item_comp.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CoCartTotals _totals;

  bool isLoadCart = true;

  IconData statusIcon = Icons.shopping_cart_outlined;
  String statusMessage = "Sepet Henüz Boş";

  void getCart() {
    setState(() {
      isLoadCart = false;
    });
    if (isRefreshCart) {
      CustomApiService.getCart().then((value) {
        this.getTotals();
        setState(() {
          cartItems = value.data;
          isLoadCart = true;
          isRefreshCart = false;
        });
      });
    } else {
      this.getTotals();
      setState(() {
        isLoadCart = true;
      });
    }
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
    if (!isLoadCart) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (cartItems == null) {
        List<WooOrder> lastOrders = new List<WooOrder>();
        orders.forEach((element) {
          if (element.status == 'pending') {
            lastOrders.add(element);
          }
        });
        return Container(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(statusIcon, size: 50, color: colorLightDart),
              SizedBox(height: 25),
              Text(statusMessage, textAlign: TextAlign.center),
              (lastOrders != null && lastOrders.length > 0)
                  ? Column(
                      children: [
                        Divider(height: 50),
                        Container(
                          padding: EdgeInsets.only(left: 20.0),
                          alignment: Alignment.centerLeft,
                          child: Text('İşlem Bekleyen Son Siparişiniz',
                              style: TextStyle(color: colorLightDart)),
                        ),
                        OrderItemComp(order: lastOrders.first)
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        );
      }
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Column(
            children: (cartItems != null && cartItems.length > 0)
                ? cartItems.map((p) {
                    return ListTile(
                      leading: Image.network(p.productImage),
                      title: Text(p.productName),
                      subtitle:
                          Text(p.quantity.toString() + ' x ' + p.productPrice),
                      trailing: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          CustomApiService.deleteCart(p.key).then((res) {
                            this.getCart();
                            this.getTotals();
                            setState(() {
                              cartItems = res.data;
                            });
                          });
                        },
                      ),
                    );
                  }).toList()
                : [],
          ),
          (_totals != null && _totals.total.isNotEmpty)
              ? ListTile(
                  title: Text("TOPLAM"),
                  subtitle: Text(_totals.total),
                )
              : CircularProgressIndicator(),
          Divider(height: 50),
          (cartItems.length > 0 && _totals != null)
              ? FormHelper.button("Sepeti Onayla", this.sepetiOnayla)
              : FormHelper.button("...", () {}),
          Divider(height: 50),
        ],
      ),
    );
  }

  void sepetiOnayla() {
    loadingOpen(context);
    List<LineItem> lineItems = new List<LineItem>();
    cartItems.forEach((i) {
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
    woocommerce.createOrder(wooOrderPayload).then((order) {
      loadingHide(context);
      if (order != null) {
        CustomApiService.clearCart().then((value) {
          this.getCart();
          setState(() {
            this.statusIcon = Icons.info;
            this.statusMessage =
                "Verdiğiniz siparişi Hesabım sekmesinde Siparişlerim bölümünde görebilirsiniz.";
          });
        });
        isRefreshOrders = true;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentPage(
              order,
              isNewPayment: true,
            ),
          ),
        );
      }
    });
  }
}
