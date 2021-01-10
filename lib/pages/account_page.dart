import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/customer.dart';
import 'package:ecommerceapp/pages/login_page.dart';
import 'package:ecommerceapp/utils/form_helper.dart';
import 'package:ecommerceapp/utils/open_snackbar_bar.dart';
import 'package:ecommerceapp/utils/show_dialog_custom.dart';
import 'package:ecommerceapp/widgets/address_box_comp.dart';
import 'package:ecommerceapp/widgets/order_item_comp.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  WooCustomer currUser = new WooCustomer();
  bool isLoadOrders = true;

  void getOrders() {
    if (isRefreshOrders) {
      setState(() {
        isLoadOrders = false;
      });
      woocommerce.getOrders(customer: loggedInCustomer.id).then((value) {
        setState(() {
          orders = value;
          isRefreshOrders = false;
          isLoadOrders = true;
        });
      });
    }
  }

  @override
  void initState() {
    if (loggedInCustomer != null) {
      currUser = WooCustomer.fromJson(loggedInCustomer.toJson());
    }
    if (loggedInCustomer != null) {
      this.getOrders();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loggedInCustomer != null && currUser != null)
      return DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              leading: Text(''),
              leadingWidth: 0,
              title: Text(
                getText("tab_account"),
                style: TextStyle(
                  color: colorDark,
                  fontSize: Theme.of(context).textTheme.headline5.fontSize,
                ),
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.logout, color: colorLightDart),
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
                                  loggedInCustomer = null;
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: Text('Çıkış Yap'))
                          ]);
                    }),
              ],
            ),
            Container(
              child: ListTile(
                title: Text(currUser.firstName + ' ' + currUser.lastName),
                subtitle: Text(currUser.email),
              ),
            ),
            Container(
              height: 50,
              child: TabBar(
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
            Expanded(
              child: TabBarView(
                children: [
                  renderOrderList(),
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
                        AddressBoxComp(),
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

  Widget renderOrderList() {
    if (isLoadOrders) {
      if (orders.length == 0) {
        return Center(
          child: Text('Henüz siparişiniz bulunmamaktadır'),
        );
      }
      return SingleChildScrollView(
        child: Column(
          children: orders.map((o) {
            return OrderItemComp(order: o);
          }).toList(),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
