import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/order.dart';
import 'package:ecommerceapp/models/payment_gateway.dart';
import 'package:ecommerceapp/utils/form_helper.dart';
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
  List<WooPaymentGateway> listGetways;
  String currentGatewayId = 'cod';
  String statusText = 'BEKLEMEDE';

  @override
  void initState() {
    this.order = widget.order;
    woocommerce.getPaymentGateways().then((value) {
      setState(() {
        this.listGetways = value;
      });
    });
    switch (this.order.status) {
      case 'pending':
        this.statusText = 'ÖDEME BEKLENİYOR';
        break;
      case 'processing':
        this.statusText = 'İŞLENİYOR';
        break;
      case 'on-hold':
        this.statusText = 'BEKLEMEDE';
        break;
      case 'completed':
        this.statusText = 'TAMAMLANDI';
        break;
      case 'cancelled':
        this.statusText = 'İPTAL EDİLDİ';
        break;
      case 'refunded':
        this.statusText = 'İADE EDİLDİ';
        break;
      case 'failed':
        this.statusText = 'BAŞARISIZ';
        break;
      case 'trash':
        this.statusText = 'SİLİNMİŞ SİPARİŞ';
        break;
      default:
    }
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
              child: Text(this.statusText),
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
                    woocommerce.updateOrder(id: order.id,).then((value) {

                    });
                    print('object');
                  })
                : SizedBox(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
