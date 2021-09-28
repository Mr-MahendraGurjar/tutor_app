import 'package:flutter/material.dart';
import 'package:tutor_app/widgets/constants.dart';

class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration({
    String labelText,
    String hintText = '',
     Icon prefixIcon,
    EdgeInsets contentPadding = const EdgeInsets.all(16),
  }) : super(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          contentPadding: contentPadding,
          filled: true,
          fillColor: Colors.white54,
          isDense: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.radius),
            borderSide: BorderSide(
              color: Colors.black45,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.radius),
            borderSide: BorderSide(
              color: Color(0xFFDCDCDC),
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.radius),
            borderSide: BorderSide(
              color: Color(0xFFDCDCDC),
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.radius),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          // hintStyle: TextStyle(color: Colors.grey),
        );
}
