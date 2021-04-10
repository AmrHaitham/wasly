// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:e_commerce/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetProducts extends StatelessWidget {
  final String title;
  GetProducts( {Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
        body:SafeArea(
          child: Stack(
            children:[
              FutureBuilder<QuerySnapshot>(
                future:FirebaseFirestore.instance.collection("Products").where('type',isEqualTo: "${title}").get(),
                builder: (context,snapshot){
                  if (snapshot.hasError){
                    return Scaffold(
                      body: Center(
                        child: Text(
                          "غير مسموح لك بأستخدام التطبيق يجب عليك التسجيل اولا",
                        ),
                      ),
                    );
                  }
                  if(snapshot.connectionState==ConnectionState.done){
                    return ListView.builder(
                        padding: EdgeInsets.only(
                          top: 80,
                          left: 10,
                          right: 10,
                        ),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (ctx,index){
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
                      }
                    );
                  }
                  return Scaffold(
                    backgroundColor: Theme.of(context).accentColor,
                    body: Center(
                      child: CircularProgressIndicator(backgroundColor: Colors.black,),
                    ),
                  );
                },
              ),
              CustomActionBar(title: title ,hasBackArrow: true,),
            ]
          ),
        ),
    );
  }
}
