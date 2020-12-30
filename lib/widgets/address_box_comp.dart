import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/pages/address_page.dart';
import 'package:flutter/material.dart';

class AddressBoxComp extends StatefulWidget {
  @override
  _AddressBoxCompState createState() => _AddressBoxCompState();
}

class _AddressBoxCompState extends State<AddressBoxComp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 30),
        ListTile(
          title: Text('Fatura Adresiniz'),
          subtitle: Text(loggedInCustomer.billing.address1.isEmpty
              ? 'Henüz Girilmemiş'
              : loggedInCustomer.billing.address1),
          trailing: Icon(Icons.business_center_outlined, size: 35.0),
          onTap: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => AddressPage(false),
                  ),
                )
                .then((value) => setState(() {}));
          },
        ),
        ListTile(
          title: Text('Gönderim Adresiniz'),
          subtitle: Text(loggedInCustomer.shipping.address1.isEmpty
              ? 'Henüz Girilmemiş'
              : loggedInCustomer.shipping.address1),
          trailing: Icon(Icons.local_shipping_outlined, size: 35.0),
          onTap: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => AddressPage(true),
                  ),
                )
                .then((value) => setState(() {}));
          },
        ),
      ],
    );
  }
}
