import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:ecommerceapp/models/cart.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  WooCart cart = new WooCart();

  void getCart() {
    CustomApiService.getCart().then((res) {
      print(res.data);
      if (res.data != null) {
        if (res.data.length > 0) {
          //
        }
      }
    });
  }

  @override
  void initState() {
    this.getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Column(
            children: cart.items != null
                ? cart.items.map((e) {
                    print(e.name + " " + e.quantity.toString());
                    return Text(e.name);
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
              CustomApiService.addCart("22", "2");
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
              woocommerce.getMyCart().then((value) {
                print(value);
              });

              

              /* WooOrderPayload p =
                  new WooOrderPayload(customerId: 9, setPaid: true);
              p.customerNote = "Deneme HHGsun";
              //p.currency = "50.00";
              p.status = "pending";
              List<LineItems> list = new List<LineItems>();
              list.add(new LineItems(
                productId: 12,
                quantity: 3,
              ));
              p.lineItems = list;
              woocommerce.createOrder(p).then((value) {
                print(value);
              }); */
            },
          ),
        ],
      ),
    );
  }
}
