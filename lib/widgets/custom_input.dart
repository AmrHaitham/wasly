// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:e_commerce/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Custom_input extends StatelessWidget {
  final String hint ;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final double contentPaddingVertical;
  final double contentPaddingHorizontal;
  Custom_input({Key key, this.hint, this.onChanged, this.onSubmitted, this.focusNode, this.textInputAction, this.isPasswordField, this.contentPaddingVertical, this.contentPaddingHorizontal}) : super(key: key);
  double chight ;
  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.height<683.4285714285714) {
      chight = 50;
    }
    else {
      chight = 62;
    }
    return Container(
        height: chight,
      margin: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 24,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(12)
        ),
        child: TextField(
          obscureText: isPasswordField ?? false,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint ?? "ادخل معلومات",
            contentPadding: EdgeInsets.symmetric(
              vertical: contentPaddingVertical ?? 18,
              horizontal: contentPaddingHorizontal ?? 18
            )
          ),
          style: Constants.regularDarkText,
        ),
      ),
    );
  }
}
