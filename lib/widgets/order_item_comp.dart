import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/order.dart';
import 'package:ecommerceapp/pages/payment_page.dart';
import 'package:flutter/material.dart';

class OrderItemComp extends StatelessWidget {
  final WooOrder order;

  const OrderItemComp({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentPage(order),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getOrderStatusDisplayName(order.status),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: order.status == 'pending'
                          ? colorFocus
                          : colorLightDart,
                    ),
                  ),
                  Text(
                    DateTime.parse(order.dateCreated).day.toString() +
                        '.' +
                        DateTime.parse(order.dateCreated).month.toString() +
                        '.' +
                        DateTime.parse(order.dateCreated).year.toString(),
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sipariş No: ' + order.id.toString(),
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  Text(order.total + ' TL '),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.lineItems
                    .map((p) => Row(
                          children: [
                            Icon(
                              Icons.navigate_next_rounded,
                              color: Colors.grey,
                            ),
                            Text(p.name)
                          ],
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
