// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'custom_counter_btn.dart';

class CustomCounter extends StatefulWidget {
  final String productId ;

  const CustomCounter({Key key, this.productId}) : super(key: key);
  @override
  _CustomCounterState createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  int _counter = 0;
  final CollectionReference _userRef =
  FirebaseFirestore.instance.collection("UsersCart");
  User _user = FirebaseAuth.instance.currentUser;
  SnackBar _snackBarAdd = SnackBar(content: Text(("تم اضافه المنتج لصفحه المشتريات")),duration: Duration( milliseconds: 100),);
  SnackBar _snackBarRemove = SnackBar(content: Text(("تم ازاله المنتج من صفحه المشتريات")),duration: Duration( milliseconds: 100),);

  Future addToCart() async{
    return await _userRef.doc(_user.uid).collection("Cart").doc(widget.productId).set(
      {
        "quantity":_counter
      }
    );
  }
  Future removeFromCart() async{
    return await _userRef.doc(_user.uid).collection("Cart").doc(widget.productId).delete();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: CustomCounterBtn(
                  text: "+",
                  onPressed: () {
                    setState(() {
                    _counter++;
                    addToCart();
                  });
                    ScaffoldMessenger.of(context).showSnackBar(_snackBarAdd);
                    },
                ),
              ),
              // if(_userRef.doc(_user.uid).collection("Cart").doc(widget.productId).get()!= null)
                Container(
                child: CustomCounterBtn(text: "${_counter}",outlineBtn: true,),
                ),
              Container(
                child: CustomCounterBtn(
                  text: "-",
                  onPressed: () {
                    setState(() {
                      if(_counter <= 0){
                        _counter =0;
                        removeFromCart();
                      }else{
                        _counter--;
                        if(_counter == 0){
                          removeFromCart();
                          ScaffoldMessenger.of(context).showSnackBar(_snackBarRemove);
                        }else {
                          addToCart();
                          ScaffoldMessenger.of(context).showSnackBar(_snackBarRemove);
                        }
                      }
                    });
                  },
                ),
              ),
            ],
          );
  }
}
