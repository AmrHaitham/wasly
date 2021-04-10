// Developed by ENG Amr Haitham amro88981@gmail.com
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:e_commerce/widgets/numCustom_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class AddProductsPage extends StatefulWidget {
  @override
  _AddProductsPageState createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  bool _isLoading = false;
  String _uploadedFileURL;
  String _name;
  num _price;
  String _type;
  String _subType;
  File _imageFile;
  final _picker = ImagePicker();
  CollectionReference _productRef = FirebaseFirestore.instance.collection("Products");

  Future pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
    uploadFile();
  }
  Future uploadFile() async {
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Path.basename(_imageFile.path));
    firebase_storage.UploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.whenComplete(() =>
        setState(() {
      _isLoading= false;
    })
    );
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }
  uploadProduct() async{
    return await _productRef.add(
      {
        'name':_name,
        'price':_price,
        'type':_type,
        'subType':_subType,
        'image':_uploadedFileURL
      }
    );
  }
  SnackBar _snackBar = new SnackBar(content: Text("رجاء ادخال بيانات صحيحه"),duration: Duration( milliseconds: 100));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اضافه منتجات"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomBtn(text: "اختر صوره المنتج",isLoading: _isLoading,outlineBtn: true,onPressed: (){
              pickImage();
              if(_uploadedFileURL==null){
                setState(() {
                  _isLoading= true;
                });
              }
            },),
            Custom_input(hint: "اسم المنتج",onChanged: (value){
              _name = value;
            },),
            NumCustom_input(
                hint: "سعر المنتج",
                onChanged: (value){
                  _price = num.parse(value);
                },
            ),
            DropdownButton<String>(
              hint: Text("اختر مكان ظهور المنتج"),
              value: _type,
              onChanged: (String newValue) {
                setState(() {
                  _type = newValue;
                });
              },
              items: <String>['سوبر ماركت', 'خضروات و فواكه', 'مخبوزات وحلويات',
                'لحوم ودواجن','محمصات','شحن ودفع فواتير','بقوليات','مستحضرات تجميل',
                'مطاعم وكافيهات','منظفات','عطارة وأعشاب','خدمات منزلية']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Custom_input(hint: "نوع المنتج مثال مشروبات سنانكس",onChanged: (value){
              _subType = value;
            },),
            // && _uploadedFileURL!=null
            CustomBtn(text: "اضافه المنتج",onPressed: (){
              if(_name != null && _price !=null && _type != null && _subType != null ){
                uploadProduct();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AddProductsPage())
                );
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              }
            },)
          ],
        ),
      ),
    );
  }
}


