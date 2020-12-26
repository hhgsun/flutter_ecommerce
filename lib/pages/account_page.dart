import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/customer.dart';
import 'package:ecommerceapp/models/order.dart';
import 'package:ecommerceapp/pages/login_page.dart';
import 'package:ecommerceapp/utils/form_helper.dart';
import 'package:ecommerceapp/utils/open_snackbar_bar.dart';
import 'package:ecommerceapp/utils/show_dialog_custom.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<WooOrder> orders = new List<WooOrder>();

  WooCustomer currUser;

  void getOrders() {
    woocommerce.getOrders(customer: loggedInCustomer.id).then((value) {
      setState(() {
        orders = value;
      });
    });
  }

  @override
  void initState() {
    if (loggedInCustomer != null) {
      currUser = WooCustomer.fromJson(loggedInCustomer.toJson());
    }
    /* if (loggedInCustomer != null) {
      this.getOrders();
    } */
    print(DateTime.now().toIso8601String());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loggedInCustomer != null && currUser != null)
      return DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListTile(
                title: Text(currUser.firstName + ' ' + currUser.lastName),
                subtitle: Text(currUser.email),
                trailing: IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      showDialogCustom(context,
                          title: 'Çıkış Yap',
                          subTitle: 'Çıkış yapmak üzeresiniz.',
                          buttons: [
                            FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('İptal')),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  woocommerce.logUserOut();
                                  loggedInCustomer = new WooCustomer();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: Text('Çıkış Yap'))
                          ]);
                    }),
              ),
            ),
            Container(
              height: 50,
              child: AppBar(
                backgroundColor: Colors.white,
                bottom: TabBar(
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'Siparişlerim',
                    ),
                    Tab(
                      text: 'Bilgilerim',
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
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
                          child: Text(currUser != null
                              ? currUser.toJson().toString()
                              : 'No Login User'),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        FormHelper.label('Adınız'),
                        FormHelper.input(context, currUser.firstName, (val) {
                          setState(() {
                            currUser.firstName = val;
                          });
                        }),
                        FormHelper.label('Soyadınız'),
                        FormHelper.input(context, currUser.lastName, (val) {
                          setState(() {
                            currUser.lastName = val;
                          });
                        }),
                        FormHelper.label('E-Mail Adresiniz'),
                        FormHelper.input(context, currUser.email, (val) {
                          setState(() {
                            currUser.email = val;
                          });
                        }, inputType: TextInputType.emailAddress),
                        SizedBox(height: 20),
                        FormHelper.button('Kaydet', () {
                          if (currUser.email.isEmpty ||
                              currUser.firstName.isEmpty ||
                              currUser.lastName.isEmpty) {
                            showDialogCustom(
                              context,
                              subTitle:
                                  'Lütfen bilgilerinizi eksiksiz giriniz.',
                            );
                          } else {
                            woocommerce
                                .updateCustomer(id: loggedInCustomer.id, data: {
                              'first_name': currUser.firstName,
                              'last_name': currUser.lastName,
                              'email': currUser.email,
                            }).then((value) {
                              setState(() {
                                loggedInCustomer = value;
                              });
                              openSnackBar(context, "Bilgileriniz Güncellendi");
                            });
                          }
                        }),
                        Divider(height: 30),
                        ListTile(
                          title: Text('Fatura Adresiniz'),
                          subtitle: Text(
                              loggedInCustomer.billing.address1.isNotEmpty
                                  ? loggedInCustomer.billing.address1
                                  : 'Henüz Girilmemiş'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Gönderim Adresiniz'),
                          subtitle: Text(
                              loggedInCustomer.shipping.address1.isNotEmpty
                                  ? loggedInCustomer.shipping.address1
                                  : 'Henüz Girilmemiş'),
                          onTap: () {},
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    else
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
}
