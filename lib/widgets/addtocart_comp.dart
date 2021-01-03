import 'package:ecommerceapp/constants.dart';
import 'package:ecommerceapp/models/products.dart';
import 'package:ecommerceapp/services/custom_api_service.dart';
import 'package:ecommerceapp/utils/form_helper.dart';
import 'package:ecommerceapp/utils/loading_dialog.dart';
import 'package:ecommerceapp/utils/open_snackbar_bar.dart';
import 'package:ecommerceapp/utils/show_dialog_custom.dart';
import 'package:flutter/material.dart';

class AddToCartComp extends StatefulWidget {
  final WooProduct product;
  const AddToCartComp(this.product, {Key key}) : super(key: key);

  @override
  _AddToCartCompState createState() => _AddToCartCompState();
}

class _AddToCartCompState extends State<AddToCartComp> {
  WooProduct product;
  int addCount = 0;
  bool isLoad = false;

  @override
  void initState() {
    product = widget.product;
    if (cartItems != null && cartItems.length > 0) {
      cartItems.forEach((element) {
        if (element.productId == product.id) {
          setState(() {
            this.addCount = element.quantity;
          });
        }
      });
    }
    setState(() {
      isLoad = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoad == false) {
      return FormHelper.button("...", () {});
    }
    return Column(
      children: [
        Text(
          addCount > 0 ? addCount.toString() + " adet sepette mevcut" : '',
          style: TextStyle(color: colorLightDart),
        ),
        MaterialButton(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(10.0),
            color: Colors.redAccent,
            alignment: Alignment.center,
            child: Text(
              "Sepete Ekle",
              style: TextStyle(color: Colors.white),
            ),
          ),
          onPressed: () {
            loadingOpen(context);
            CustomApiService.addCart(product.id.toString(), "1").then((res) {
              loadingHide(context);
              if (res.success) {
                setState(() {
                  cartItems = res.data;
                  this.addCount = this.addCount + 1;
                });
                openSnackBar(context, "Ürün Sepete Eklendi");
              } else {
                showDialogCustom(context, subTitle: res.message);
              }
            });
          },
        ),
      ],
    );
  }
}
