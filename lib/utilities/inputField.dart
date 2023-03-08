import 'package:demoadmin/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFields {
  static Widget commonInputField(
      controller, labelText, validator, keyboardType, maxLines,
      [List<TextInputFormatter>? inputFormatters]) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
            labelText: labelText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }

  static Widget onlyDigitInputField(
      controller, labelText, validator, keyboardType, maxLines) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
            labelText: labelText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }

  static Widget textInputFormField(
      context, lableText, keyboardType, controller, maxLine, validator) {
    return TextFormField(
      cursorColor: btnColor,
      maxLines: maxLine,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          labelText: lableText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
          )),
    );
  }

  static Widget ageInputFormField(
      context, labelText, keyboardType, controller, readOnly, validator) {
    return TextFormField(
      cursorColor: btnColor,
      controller: controller,
      validator: validator,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
          )),
    );
  }

  static Widget passInputField(controller, labelText) {
    bool passValid = true;
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            TextFormField(
              obscureText: true,
              controller: controller,
              validator: (item) {
                if (item!.length > 7) {
                  String pattern =
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                  RegExp regExp = new RegExp(pattern);
                  bool checkValid = regExp.hasMatch(item);
                  if (checkValid)
                    passValid = true;
                  else
                    passValid = false;
                  return checkValid ? null : "Enter a valid password";
                } else {
                  return "length should be at least 8";
                }
              },
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  labelText: labelText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0),
                  )),
            ),
            !passValid ? SizedBox(height: 8) : Container(),
            !passValid
                ? Text(
                    "Password length should be greater then 8 and Minimum 1 Upper case, 1 lowercase,1 Numeric Number",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  )
                : Container(),
          ],
        ));
  }

  static Widget readableInputField(controller, labelText, maxLine) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: maxLine,
        readOnly: true,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: labelText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }
}
