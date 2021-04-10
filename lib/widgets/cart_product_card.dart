// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_counter_btn.dart';

class CartProductCard extends StatefulWidget {
  final String title;
  final num price;
  final num quantaty;

  final String productId;


  const CartProductCard({Key key, this.title,  this.price, this.quantaty, this.productId}) : super(key: key);
  @override
  _CartProductCardState createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  @override
  Widget build(BuildContext context) {
    String _title = widget.title ?? "النوع" ;
    num _price = widget.price ?? 0 ;
    num _quantaty = widget.quantaty;
    User _user = FirebaseAuth.instance.currentUser;
    final CollectionReference _userRef =
    FirebaseFirestore.instance.collection("UsersCart");
    Future removeFromCart() async{
      return await _userRef.doc(_user.uid).collection("Cart").doc(widget.productId).delete();
    }
    Future addToCart() async{
      return await _userRef.doc(_user.uid).collection("Cart").doc(widget.productId).update(
          {
            "quantity":_quantaty
          }
      );
    }
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.3,
            padding: EdgeInsets.only(left: 3),
            child: Text(
              "${_title}",
              style: Constants.regularHeading,
            ),
          ),
          Row(
            children: [
              CustomCounterBtn(text: "+",onPressed: (){
                setState(() {
                  _quantaty++;
                  addToCart();
                });
              },),
              CustomCounterBtn(text: "${_quantaty}",outlineBtn: true,),
              CustomCounterBtn(text: "-",onPressed: (){
                setState(() {
                  if(_quantaty <= 0){
                    _quantaty =0;
                    removeFromCart();
                  }else{
                    _quantaty--;
                    if(_quantaty == 0){
                      removeFromCart();
                    }else {
                      addToCart();
                    }
                  }
                });
              },),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.19,
            padding: EdgeInsets.only(right: 3),
            child: Text(
              "جنيه ${_price*_quantaty}",
              style: Constants.regularRedHeading,
            ),
          ),
        ],
      ),
    );
  }
}
