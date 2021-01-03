import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/order.dart';
import 'package:ecommerceapp/models/payment_gateway.dart';
import 'package:ecommerceapp/utils/form_helper.dart';
import 'package:ecommerceapp/utils/loading_dialog.dart';
import 'package:ecommerceapp/utils/show_dialog_custom.dart';
import 'package:ecommerceapp/widgets/address_box_comp.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final WooOrder order;
  final bool isNewPayment;
  const PaymentPage(this.order, {Key key, this.isNewPayment = false})
      : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  WooOrder order;
  List<WooPaymentGateway> listGetways;
  String currentGatewayId = 'cod';

  @override
  void initState() {
    if (widget.isNewPayment) {
      showDialogCustom(context,
          subTitle: 'Sepetiniz onaylandı, Ödeme Yapabilirsiniz',
          buttons: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Devam Et'),
            ),
          ]);
    }
    this.order = widget.order;
    woocommerce.getPaymentGateways().then((value) {
      setState(() {
        this.listGetways = value;
      });
    });

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AddressBoxComp(),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Text(getOrderStatusDisplayName(order.status)),
            ),
            Divider(),
            Column(
              children: order.lineItems
                  .map(
                    (p) => ListTile(
                      dense: true,
                      title: Text(p.name),
                      subtitle:
                          Text(p.quantity.toString() + ' x ' + p.total + ' TL'),
                    ),
                  )
                  .toList(),
            ),
            ListTile(
              title: Text('Toplam: ' + order.total + ' TL'),
            ),
            Divider(),
            this.listGetways != null
                ? Column(
                    children: this
                        .listGetways
                        .map(
                          (g) => g.enabled
                              ? RadioListTile(
                                  title: Text(g.title),
                                  subtitle: Text(g.description),
                                  value: g.id,
                                  groupValue: this.currentGatewayId,
                                  onChanged: (val) {
                                    setState(() {
                                      this.currentGatewayId = val;
                                    });
                                  },
                                )
                              : Text(''),
                        )
                        .toList())
                : CircularProgressIndicator(),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: FormHelper.label(
                  'Ek Bilgi - Siparişinizle ilgili notlar (isteğe bağlı)'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: FormHelper.input(context, '', (txt) {
                order.customerNote = txt;
              }, lineCount: 2, prefixIcon: Icon(Icons.note_sharp)),
            ),
            Divider(),
            this.listGetways != null
                ? FormHelper.button("ÖDEME YAP", () {
                    if (loggedInCustomer.billing.address1.isEmpty ||
                        loggedInCustomer.shipping.address1.isEmpty) {
                      showDialogCustom(context,
                          subTitle: 'Lütfen Adres Bilgilerinizi Giriniz');
                      return;
                    }
                    this.sendUpdateData();
                  })
                : SizedBox(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void sendUpdateData() {
    WooPaymentGateway currGateway =
        listGetways.where((element) => element.id == currentGatewayId).first;
    Map upOrderArgs = {
      'id': order.id,
      'status': 'processing',
      'payment_method': currGateway.id,
      'payment_method_title': currGateway.methodTitle,
      'shipping': loggedInCustomer.shipping.toJson(),
      'billing': loggedInCustomer.billing.toJson(),
    };
    if (order.customerNote != null) {
      upOrderArgs['customer_note'] = order.customerNote;
    }
    loadingOpen(context);
    woocommerce.updateOrder(id: order.id, orderMap: upOrderArgs).then((value) {
      loadingHide(context);
      woocommerce.getOrders(customer: loggedInCustomer.id).then((value) {
        setState(() {
          orders = value;
        });
      });
      showDialogCustom(
        context,
        subTitle: "Siparişiniz başarıyla alındı",
        successIcon: true,
      ).then((value) {
        Navigator.of(context).pop();
      });
    });
  }
}
