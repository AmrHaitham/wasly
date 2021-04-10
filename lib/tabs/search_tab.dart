// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:e_commerce/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String name = "";
  double chightS ;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.height<683.4285714285714) {
      chightS = 34;
    }
    else {
      chightS = 42;
    }
    return Stack(children: [
      if(name != "" && name != null)
      StreamBuilder<QuerySnapshot>(
          stream:  FirebaseFirestore.instance
                  .collection("Products")
                  .where('name',isGreaterThanOrEqualTo: name )
                  .limit(10)
                  .snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.only(
                      top: 90,
                      left: 10,
                      right: 10,
                    ),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (ctx, index) {
                      DocumentSnapshot document = snapshot.data.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: ProductCard(
                          title: document.data()['name'],
                          image: document.data()['image'],
                          price: document.data()['price'],
                          subType: document.data()['subType'],
                          productId: document.id,
                        ),
                      );
                    });
          }),
      if(name == "")
        Center(
          child: Text("... نتائج البحث",style: Constants.boldHeading,),
        ),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Theme.of(context).accentColor,
          Theme.of(context).accentColor.withOpacity(0)
        ], begin: Alignment(0, 0), end: Alignment(0, 1))),
        padding: const EdgeInsets.only(top: 10),
        child: Custom_input(
          hint: "ابحث بأسم المنتج...",
          onChanged: (val) {
            setState(() {
              name = val;
            });
          },
          contentPaddingHorizontal: 40,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: chightS, left: 35),
        child: Align(
          alignment: Alignment.topLeft,
          child: Icon(Icons.search),
        ),
      ),
    ]);
  }
}
