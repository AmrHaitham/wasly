// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'custom_counter_btn.dart';

class FakeCartProductCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Shimmer.fromColors(
                baseColor: Colors.grey[100],
                highlightColor: Colors.redAccent[100],
                child: Padding(padding: EdgeInsets.only(left: 30 ),)
            ),
                Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.redAccent[100],
                    child: CustomCounterBtn(text: " ",)
                ),
                Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.redAccent[100],
                    child: CustomCounterBtn(text: " ",outlineBtn: true,)
                ),
                Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.redAccent[100],
                    child: CustomCounterBtn(text: " ",)
                ),
            Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.redAccent[100],
                child: Padding(padding: EdgeInsets.only(right: 30),)
            ),
          ],
        ),
    );
  }
}
