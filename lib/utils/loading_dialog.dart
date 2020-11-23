import 'package:flutter/material.dart';

void loadingOpen(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.only(top: 15, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 5,
              ),
              Text("Bekleyiniz"),
            ],
          ),
        ),
      );
    },
  );
}

void loadingHide(context) {
  Navigator.of(context).pop();
}