import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/utils/form_helper.dart';
import 'package:ecommerceapp/utils/show_dialog_custom.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/models/customer.dart';
import 'package:woocommerce/models/user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hiddentText = true;

  WooCustomer _wooCustomer = new WooCustomer();

  void _toggleVisibility() {
    setState(() {
      hiddentText = !hiddentText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Hoşgeldin!", style: Theme.of(context).textTheme.headline4),
          toolbarHeight: 200,
          bottom: TabBar(tabs: [Tab(text: "Giriş Yap"), Tab(text: "Kayıt Ol")]),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _formLogin,
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _formRegister,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _formRegister => Column(
        children: [
          FormHelper.input(
            context,
            this._wooCustomer.email,
            (val) => this._wooCustomer.email = val,
            hintText: "Kayıt Ol",
          ),
          FormHelper.button("Kayıt Ol", () {
            WooCustomer user = WooCustomer(
                username: "username",
                password: "password",
                email: "email@hotmail.com");
            final result = woocommerce.createCustomer(user);
            print(result);
          }),
        ],
      );

  Widget get _formLogin => Column(
        children: [
          FormHelper.input(
            context,
            this._wooCustomer.email,
            (val) => this._wooCustomer.email = val,
            hintText: "E-Mail",
          ),
          FormHelper.spacer(),
          FormHelper.input(
            context,
            this._wooCustomer.password,
            (val) => this._wooCustomer.password = val,
            hintText: "Şifre",
            obscureText: hiddentText,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: hiddentText
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onPressed: _toggleVisibility,
                color: Colors.grey,
              ),
            ),
          ),
          FormHelper.spacer(height: 30.0),
          Text("Unuttum"),
          Divider(
            height: 40,
          ),
          FormHelper.button("Giriş Yap", () async {
            try {
              final d = await woocommerce.loginCustomer(
                username: "hhgsun",
                password: "hhgsun",
              );
              if(d is WooCustomer) {
                print(d);
              } else {
                showDialogCustom(context, title: "Hata", subTitle: d);
              }
            } catch (e) {
              showDialogCustom(context, title: "Hata", subTitle: e);
            }
          }),
          FormHelper.button("Çıkış", () async {
            final d = await woocommerce.logUserOut();
            print(d);
          }),
        ],
      );
}
