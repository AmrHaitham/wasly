import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:e_commerce/widgets/numCustom_input.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatelessWidget {
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection("Products");
  String _productName;
  num _productPrice;
  String _productID;
  getProductID() async{
    await _productRef.where("name", isEqualTo: _productName).get().then(
          (QuerySnapshot snapshot) => {
        snapshot.docs.forEach((f) {
          _productID= f.id;
        }),
      },
    );
  }
  updateData() async{
       await _productRef.doc(_productID).update({
            "price":_productPrice
       });
  }
  SnackBar _snackBar = SnackBar(content: Text("ادخل اسم منتج صحيح"));
  SnackBar _snackBarEmpty = SnackBar(content: Text("ادخل بيانات صحيحه"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تعديل سعر منتج"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Custom_input(
              hint: "اسم المنتج",
              onChanged: (value) {
                _productName = value;
              },
            ),
            NumCustom_input(
              hint: "سعر المنتج",
              onChanged: (value) {
                _productPrice = num.parse(value);
              },
            ),
            CustomBtn(
              text: "تعديل السعر",
              onPressed: () {
                if(_productName != null && _productPrice !=null){
                  getProductID();
                  if(_productID!=null){
                    updateData();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> EditProduct()));
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                  }
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(_snackBarEmpty);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
