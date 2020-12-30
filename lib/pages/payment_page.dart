import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/order.dart';
import 'package:ecommerceapp/utils/show_dialog_custom.dart';
import 'package:ecommerceapp/widgets/address_box_comp.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final WooOrder order;
  const PaymentPage(this.order, {Key key}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  WooOrder order;

  @override
  void initState() {
    this.order = widget.order;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ödeme Sayfası'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(order.status),
            Text(order.total),
            AddressBoxComp(),
            FlatButton(
              color: colorPrimary,
              onPressed: () {
                showDialogCustom(context,
                    subTitle: 'Henüz ödeme üzerinde çalışmalar sürüyor.');
              },
              child: Text('ÖDEME YAP', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
