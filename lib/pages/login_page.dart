import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/customer.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:ecommerceapp/utils/form_helper.dart';
import 'package:ecommerceapp/utils/loading_dialog.dart';
import 'package:ecommerceapp/utils/show_dialog_custom.dart';
import 'package:ecommerceapp/widgets/tabs_layout.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  WooCustomer _loginCustomer = new WooCustomer();
  WooCustomer _registerCustomer = new WooCustomer();

  bool hiddentLoginPassText = true;
  bool hiddentRegisterPassText = true;
  bool hiddentRegisterResPassText = true;
  String _resPassword = "";

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
          FormHelper.label("İsim Soyisim"),
          FormHelper.input(
            context,
            this._registerCustomer.firstName,
            (val) => this._registerCustomer.firstName = val,
            hintText: "Adınız",
          ),
          FormHelper.spacer(height: 5.0),
          FormHelper.input(
            context,
            this._registerCustomer.lastName,
            (val) => this._registerCustomer.lastName = val,
            hintText: "Soyadınız",
          ),
          FormHelper.spacer(height: 10.0),
          FormHelper.label("E-Mail Adresiniz"),
          FormHelper.input(
            context,
            this._registerCustomer.email,
            (val) => this._registerCustomer.email = val,
            hintText: "E-Mail Adresiniz",
          ),
          FormHelper.spacer(height: 10.0),
          FormHelper.label("Şifreniz"),
          FormHelper.input(
            context,
            this._registerCustomer.password,
            (val) => this._registerCustomer.password = val,
            hintText: "Şifre",
            obscureText: hiddentRegisterPassText,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: hiddentRegisterPassText
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    hiddentRegisterPassText = !hiddentRegisterPassText;
                  });
                },
                color: Colors.grey,
              ),
            ),
          ),
          FormHelper.spacer(height: 5),
          FormHelper.input(
            context,
            this._resPassword,
            (val) => this._resPassword = val,
            hintText: "Şifrenizi Tekrar Girin",
            obscureText: hiddentRegisterResPassText,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: hiddentRegisterResPassText
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    hiddentRegisterResPassText = !hiddentRegisterResPassText;
                  });
                },
                color: Colors.grey,
              ),
            ),
          ),
          Divider(height: 40),
          FormHelper.button("Kayıt Ol", () async {
            if (_resPassword == _registerCustomer.password) {
              loadingOpen(context);
              try {
                _registerCustomer.username =
                    generateUsernameByEmail(_registerCustomer.email);
                bool res = await woocommerce.createCustomer(_registerCustomer);
                if (res) {
                  this._loginCtrl(
                    _registerCustomer.email,
                    _registerCustomer.password,
                  );
                } else {
                  loadingHide(context);
                  showDialogCustom(
                    context,
                    subTitle: 'Kayıt olurken bir hata oluştu',
                    failIcon: true,
                  );
                }
              } catch (e) {
                loadingHide(context);
                String textShowMessage = "Beklenmedik Hata";
                if (e.message is String) {
                  List<String> errs = e.message.toString().split('\n');
                  if (errs.length > 2) {
                    List<String> msgTexts = errs[2].split("message:");
                    if (msgTexts.length > 1) {
                      textShowMessage = msgTexts[1].trim();
                    }
                    textShowMessage = _removeHtmlTags(textShowMessage);
                  }
                }
                showDialogCustom(
                  context,
                  subTitle: (textShowMessage is String)
                      ? textShowMessage
                      : 'Kayıt olurken bir hata oluştu',
                  failIcon: true,
                );
              }
            } else {
              showDialogCustom(
                context,
                subTitle: 'Lütfen Şifrenizi kontrol ediniz',
                failIcon: true,
              );
            }
          }, fullWidth: true),
        ],
      );

  Widget get _formLogin => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FormHelper.input(
            context,
            this._loginCustomer.email,
            (val) => this._loginCustomer.email = val,
            hintText: "E-Mail Adresinizi Girin",
          ),
          FormHelper.spacer(),
          FormHelper.input(
            context,
            this._loginCustomer.password,
            (val) => this._loginCustomer.password = val,
            hintText: "Şifrenizi Girin",
            obscureText: hiddentLoginPassText,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: hiddentLoginPassText
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    hiddentLoginPassText = !hiddentLoginPassText;
                  });
                },
                color: Colors.grey,
              ),
            ),
          ),
          FormHelper.spacer(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            child: FormHelper.button(
              "Şifremi Unuttum!",
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LostPassWebView()),
                );
              },
              height: 30.0,
              color: Colors.white,
              borderColor: Colors.white,
              textColor: Colors.grey[600],
            ),
          ),
          Divider(height: 30.0),
          FormHelper.button("Giriş Yap", () async {
            loadingOpen(context);
            this._loginCtrl(
              _loginCustomer.email,
              _loginCustomer.password,
            );
          }, fullWidth: true),
          Divider(height: 50),
          FormHelper.button("Devam Et", () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => TabsLayout()),
            );
          }, color: Colors.grey, borderColor: Colors.grey),
        ],
      );

  void _loginCtrl(String username, String password) async {
    try {
      final cus = await woocommerce.loginCustomer(
        username: username,
        password: password,
      );
      loadingHide(context);
      if (cus is WooCustomer) {
        loggedInCustomer = cus;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => TabsLayout()),
        );
      } else {
        showDialogCustom(
          context,
          subTitle: (cus is String)
              ? _removeHtmlTags(cus)
              : 'Giriş sırasında bir hata oluştu',
          failIcon: true,
        );
      }
    } catch (e) {
      loadingHide(context);
      showDialogCustom(
        context,
        subTitle: (e is String) ? e : 'Giriş sırasında bir hata oluştu',
        failIcon: true,
      );
    }
  }

  String _removeHtmlTags(String str) {
    RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true,
    ); // html taglarını temizler
    str = str.replaceAll(exp, '');
    return str;
  }
}

class LostPassWebView extends StatefulWidget {
  @override
  _LostPassWebViewState createState() => _LostPassWebViewState();
}

class _LostPassWebViewState extends State<LostPassWebView> {
  String email;

  /* @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Şifre Sıfırla"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormHelper.input(context, this.email, (val) {
              this.email = val;
            },
                hintText: "E-Mail Adresiniz",
                helperText: "Kayıtlı olduğunuz e-mail adresinizi giriniz"),
            FormHelper.spacer(),
            FormHelper.button("Sıfırlama Linki Gönder", () {
              if (this.email == null) return;
              loadingOpen(context);
              CustomApiService.lostPassword(this.email).then((res) {
                loadingHide(context);
                if (res.success) {
                  showDialogCustom(
                    context,
                    subTitle: res.data.toString(),
                    successIcon: true,
                  ).then((_) {
                    Navigator.of(context).pop();
                  });
                } else {
                  showDialogCustom(context,
                      subTitle: res.data.toString(), failIcon: true);
                }
              });
            }),
          ],
        ),
      ),
      /* WebView(
        initialUrl: woocommerce.baseUrl + lostPassUrlForWebView,
      ), */
    );
  }
}
