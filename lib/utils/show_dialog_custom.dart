// GLOBAL WIDGETs
import 'package:ecommerceapp/constants.dart';
import 'package:flutter/material.dart';

Future<bool> showDialogCustom(
  context, {
  String title,
  String subTitle,
  String okText,
  List<FlatButton> buttons,
  bool successIcon = false,
  bool failIcon = false,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title != null ? title : '',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              successIcon
                  ? Icon(
                      Icons.check_circle,
                      color: colorPrimary,
                      size: 60,
                    )
                  : SizedBox(),
              failIcon
                  ? Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    )
                  : SizedBox(),
              Text(
                subTitle != null ? subTitle : '',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: buttons != null
            ? buttons
            : <Widget>[
                FlatButton(
                  child: Text(
                    okText != null ? okText : 'Tamam',
                    style: TextStyle(color: colorPrimary),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
      );
    },
  );
}
