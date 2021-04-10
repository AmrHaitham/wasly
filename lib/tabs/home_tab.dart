// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:e_commerce/screens/ProductsType.dart';
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.only(
                top: 70
            ),
            child: ProductsType()
        ),
        CustomActionBar(title: "الصفحه الرئيسيه",),
      ]
    );
  }
}
