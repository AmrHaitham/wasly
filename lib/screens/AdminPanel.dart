// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/screens/AddDriverPage.dart';
import 'package:e_commerce/screens/AddProduct.dart';
import 'package:e_commerce/screens/EditProductPrice.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'package:e_commerce/screens/OrdersPage.dart';

class AdminPanel extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getUserID() {
    final User user = _auth.currentUser;
    return user.uid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true , title: Text("صفحه الأدمن",style: Constants.regularHeading,),),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                if(getUserID() == "fpPekUP8XAeV0ehTYz8h2dnTcKu1")
                CustomBtn(outlineBtn: true,text: "طلبات لم يتم قبولها",onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersPage(status: "notAccepted",)),
                  );
                },),
                CustomBtn(outlineBtn: true,text: "طلبات مقبوله",onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersPage(status: "accepted",)),
                  );
                }),
                CustomBtn(outlineBtn: true,text: "طلبات يتم تحضيرها",onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersPage(status: "onPreparing",)),
                  );
                }),
                if(getUserID() == "fpPekUP8XAeV0ehTYz8h2dnTcKu1")
                CustomBtn(outlineBtn: true,text: "طلبات تم توصيلها",onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersPage(status: "done",)),
                  );
                }),
                CustomBtn(text: "اضافه منتج جديد",onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProductsPage())
                  );
                },),
                CustomBtn(text: "تعديل سعر منتج",onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProduct())
                  );
                },)
              ]
            ),
            CustomBtn(
              text: "تسجيل خروج",
              onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage())
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: getUserID()=="fpPekUP8XAeV0ehTYz8h2dnTcKu1" ? Align(
          alignment: Alignment(1,0.8),
        child: FloatingActionButton.extended(
            icon:Icon(Icons.add),
            label:Text("اضافه سائق",style:Constants.regularDarkText),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverRegisterPage()));
            },
        )
      ):Align(
        alignment: Alignment(1,0.8),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            icon:Icon(Icons.delete_forever),
            label:Text("مسح الحساب",style:Constants.regularDarkText),
            onPressed: (){
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context){
                    return AlertDialog(
                      content: Container(
                          width: 30,
                          height: 30,
                          child: Align(
                            alignment: Alignment.center,
                            child :Text("!هل انت متأكد من مسح الحساب"),
                          )
                      ),
                      actions: [
                        TextButton(
                            onPressed: (){Navigator.pop(context);},
                            child: Text("لا",)
                        ),
                        TextButton(
                            onPressed: (){
                              _auth.currentUser.delete();
                              Navigator.pop(context);
                              // Navigator.of(context).pushReplacement(
                              //     MaterialPageRoute(builder: (context) => LoginPage())
                              // );
                            }
                            , child: Text("نعم")
                        )
                      ],
                    );
                  }
              );
            },
          )
      ),
    );
  }
}
