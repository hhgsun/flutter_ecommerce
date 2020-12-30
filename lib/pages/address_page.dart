import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/customer.dart';
import 'package:ecommerceapp/utils/form_helper.dart';
import 'package:ecommerceapp/utils/loading_dialog.dart';
import 'package:ecommerceapp/utils/show_dialog_custom.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  final bool isShipping;
  const AddressPage(this.isShipping, {Key key}) : super(key: key);
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  Shipping shipping = new Shipping();
  Billing billing = new Billing();

  bool isShipping;

  @override
  void initState() {
    isShipping = widget.isShipping;
    if (isShipping) {
      shipping = Shipping.fromJson(loggedInCustomer.shipping.toJson());
    } else {
      billing = Billing.fromJson(loggedInCustomer.billing.toJson());
    }
    super.initState();
  }

  Future<WooCustomer> saveUserAddress() {
    if (isShipping) {
      return woocommerce.updateCustomer(id: loggedInCustomer.id, data: {
        'shipping': shipping.toJson(),
      });
    } else {
      return woocommerce.updateCustomer(id: loggedInCustomer.id, data: {
        'billing': billing.toJson(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isShipping ? 'Gönderim Adresiniz' : 'Fatura Adresiniz'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              FormHelper.label('Ad *'),
              FormHelper.input(
                  context, isShipping ? shipping.firstName : billing.firstName,
                  (val) {
                if (isShipping)
                  shipping.firstName = val;
                else
                  billing.firstName = val;
              }),
              FormHelper.label('Soyad *'),
              FormHelper.input(
                  context, isShipping ? shipping.lastName : billing.lastName,
                  (val) {
                if (isShipping)
                  shipping.lastName = val;
                else
                  billing.lastName = val;
              }),
              FormHelper.label('Firma'),
              FormHelper.input(
                  context, isShipping ? shipping.company : billing.company,
                  (val) {
                if (isShipping)
                  shipping.company = val;
                else
                  billing.company = val;
              }),
              /* FormHelper.label('Ülke *'),
              FormHelper.input(
                  context, isShipping ? shipping.country : billing.country,
                  (val) {
                if (isShipping)
                  shipping.country = val;
                else
                  billing.country = val;
              }), */
              FormHelper.label('Adres *'),
              FormHelper.input(
                  context, isShipping ? shipping.address1 : billing.address1,
                  (val) {
                if (isShipping)
                  shipping.address1 = val;
                else
                  billing.address1 = val;
              }),
              SizedBox(height: 5.0),
              FormHelper.input(
                  context, isShipping ? shipping.address2 : billing.address2,
                  (val) {
                if (isShipping)
                  shipping.address2 = val;
                else
                  billing.address2 = val;
              }),
              FormHelper.label('İlçe/Semt *'),
              FormHelper.input(
                  context, isShipping ? shipping.city : billing.city, (val) {
                if (isShipping)
                  shipping.city = val;
                else
                  billing.city = val;
              }),
              FormHelper.label('Şehir *'),
              FormHelper.input(
                  context, isShipping ? shipping.state : billing.state, (val) {
                if (isShipping)
                  shipping.state = val;
                else
                  billing.state = val;
              }),
              FormHelper.label('Posta Kodu *'),
              FormHelper.input(
                  context, isShipping ? shipping.postcode : billing.postcode,
                  (val) {
                if (isShipping)
                  shipping.postcode = val;
                else
                  billing.postcode = val;
              }),
              !isShipping
                  ? Column(
                      children: [
                        FormHelper.label('E-Posta *'),
                        FormHelper.input(context, billing.email, (val) {
                          billing.email = val;
                        }, inputType: TextInputType.emailAddress),
                        FormHelper.label('Telefon Numarası *'),
                        FormHelper.input(context, billing.phone, (val) {
                          billing.phone = val;
                        }, inputType: TextInputType.phone),
                      ],
                    )
                  : SizedBox(),
              Divider(),
              FormHelper.button('Kaydet', () {
                if (isShipping) {
                  shipping.country = 'TR';
                  if (shipping.firstName.isEmpty ||
                      shipping.lastName.isEmpty ||
                      shipping.country.isEmpty ||
                      shipping.address1.isEmpty ||
                      shipping.state.isEmpty ||
                      shipping.city.isEmpty ||
                      shipping.postcode.isEmpty) {
                    showDialogCustom(context,
                        subTitle: 'Lütfen gerekli alanları doldurunuz');
                    return;
                  }
                } else {
                  billing.country = 'TR';
                  if (billing.firstName.isEmpty ||
                      billing.lastName.isEmpty ||
                      billing.country.isEmpty ||
                      billing.address1.isEmpty ||
                      billing.state.isEmpty ||
                      billing.city.isEmpty ||
                      billing.postcode.isEmpty ||
                      billing.email.isEmpty ||
                      billing.phone.isEmpty) {
                    showDialogCustom(context,
                        subTitle: 'Lütfen gerekli alanları doldurunuz');
                    return;
                  }
                }
                loadingOpen(context);
                saveUserAddress().then((value) {
                  setState(() {
                    loggedInCustomer = value;
                    print(loggedInCustomer.toJson());
                  });
                }).then((value) {
                  loadingHide(context);
                  showDialogCustom(context,
                      subTitle: 'Bilgileriniz Kaydedildi');
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
