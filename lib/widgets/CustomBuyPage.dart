// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:e_commerce/tabs/buy_tab.dart';
import 'package:flutter/material.dart';
class CustomBuy extends StatefulWidget {
  @override
  _CustomBuyState createState() => _CustomBuyState();
}

class _CustomBuyState extends State<CustomBuy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(child: BuyTab()),
    );
  }
}
