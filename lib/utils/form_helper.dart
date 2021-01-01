import 'package:ecommerceapp/constants.dart';
import 'package:flutter/material.dart';
// BUNU UYGULA
// https://github.com/codegrue/card_settings

class FormHelper {
  static Widget input(
    BuildContext context,
    Object initialValue,
    Function onChanged, {
    String hintText,
    String helperText,
    int lineCount = 1,
    TextInputType inputType = TextInputType.text,
    obscureText: false,
    Function onValidate,
    Widget prefixIcon,
    Widget suffixIcon,
  }) {
    return TextFormField(
      initialValue: initialValue != null ? initialValue.toString() : "",
      decoration: decoration(
        context,
        hintText,
        helperText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
      obscureText: obscureText,
      maxLines: lineCount,
      keyboardType: inputType,
      onChanged: (String value) {
        return onChanged(value);
      },
      validator: (value) {
        return onValidate(value);
      },
    );
  }

  static InputDecoration decoration(
    BuildContext context,
    String hintText,
    String helperText, {
    Widget prefixIcon,
    Widget suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(15),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
  }

  static Widget label(String labelName,
      {TextAlign textAlign = TextAlign.left}) {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      alignment: Alignment.bottomLeft,
      child: Text(
        labelName,
        textAlign: textAlign,
        style: TextStyle(color: colorLightDart),
      ),
    );
  }

  static SizedBox spacer({double height = 20.0}) => SizedBox(height: height);

  static Widget button(
    String buttonText,
    Function onTap, {
    bool fullWidth = false,
    double width = 200.0,
    double height = 50.0,
    Color color = colorPrimary,
    Color borderColor = colorPrimary,
    Color textColor = colorwhite,
  }) {
    return Container(
      height: height,
      width: fullWidth ? double.maxFinite : width,
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              style: BorderStyle.solid,
              width: 2.0,
            ),
            color: color,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
