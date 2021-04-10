// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/widgets/CustomBuyPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  final bool hasTrash;

  CustomActionBar({Key key, this.title, this.hasBackArrow, this.hasTitle, this.hasTrash}) : super(key: key);

  final CollectionReference _userRef = FirebaseFirestore
      .instance
      .collection("UsersCart");
  final User _user = FirebaseAuth.instance.currentUser;
  CollectionReference _cartRef = FirebaseFirestore.instance.collection("UsersCart");
  Future removeFromCart() async{
    await _cartRef.doc(_user.uid).collection("Cart").get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hasTitle ?? true;
    bool _hasTrash = hasTrash ?? false;
    
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).accentColor.withOpacity(0)
            ],
            begin: Alignment(0,0),
            end: Alignment(0,1)
          )
        ),
        padding: EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(_hasTrash)
              GestureDetector(
                onTap: (){
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                              "هل انت متأكد من مسح كل المنتجات من السله"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator
                                      .pop(
                                      context);
                                },
                                child: Text(
                                  "رجوع",)
                            ),
                            TextButton(
                                onPressed: () {
                                  removeFromCart();
                                  Navigator
                                      .pop(
                                      context);
                                },
                                child: Text(
                                  "متأكد",)
                            ),
                          ],
                        );
                      }
                  );
                },
                child: Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage(
                        "assets/delete.png"
                    ),
                    width: 42,
                    height: 42,
                  ),
                ),
              ),
            if(_hasBackArrow)
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  alignment: Alignment.center,
                  child: Image(
                    color: Colors.white,
                    image: AssetImage(
                      "assets/back_arrow.png"
                    ),
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            if(_hasTitle)
              Text(title,style: Constants.boldHeading,),
            GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomBuy()));
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8)
                ),
                alignment: Alignment.center,
                child: StreamBuilder(
                  stream: _userRef.doc(_user.uid).collection("Cart").snapshots(),//using snapshots() make it get data in real time
                  builder: (context,snapshot){
                    int _totalItems = 0;
                    if(snapshot.connectionState == ConnectionState.active){
                      List _document = snapshot.data.docs;
                      _totalItems = _document.length;
                    }
                    return Text(
                      "${_totalItems}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    );
                  },
                ),
              ),
            ),

          ],
        )
    );
  }
}
