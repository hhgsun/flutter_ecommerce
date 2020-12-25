import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/order.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<WooOrder> orders = new List<WooOrder>();

  void getOrders() {
    woocommerce.getOrders(customer: loggedInCustomer.id).then((value) {
      setState(() {
        orders = value;
      });
    });
  }

  @override
  void initState() {
    this.getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FlatButton(
            onPressed: () {
              this.getOrders();
            },
            child: Text('YENİLE'),
          ),
          Text("Siparişlerim"),
          Column(
            children: orders.map((o) {
              return Column(
                children: [
                  Text(o.id.toString() + ' Siparişler:'),
                  Column(
                    children: o.lineItems
                        .map((p) => ListTile(
                              title: Text(p.name),
                            ))
                        .toList(),
                  ),
                  Text('TOPLAM: ' + o.total),
                  Divider(),
                ],
              );
            }).toList(),
          ),
          Text("Bilgiler"),
          Center(
            child: Text(loggedInCustomer != null
                ? loggedInCustomer.toJson().toString()
                : 'No Login User'),
          ),
        ],
      ),
    );
  }
}
