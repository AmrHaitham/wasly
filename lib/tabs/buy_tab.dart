// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/widgets/FakeCartProductCard.dart';
import 'package:e_commerce/widgets/cart_product_card.dart';
import 'package:e_commerce/widgets/custom_action_bar.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../Constants.dart';
import 'package:intl/intl.dart';

class BuyTab extends StatefulWidget {
  @override
  _BuyTabState createState() => _BuyTabState();
}

class _BuyTabState extends State<BuyTab> {
  String _location ;
  String _note;
  List<String> _productS =[];
  num _total = 0;
  String _day = DateFormat('yMMMMd').format(DateTime.now());
  String _time = DateFormat('Hms').format(DateTime.now());
  String _date ;
  String _userName;
  String _userPhone;
  int _dliverPrice = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getUserID() {
    final User user = _auth.currentUser;
    return user.uid;
  }
  CollectionReference _cartRef = FirebaseFirestore.instance.collection("UsersCart");
  CollectionReference _productRef = FirebaseFirestore.instance.collection("Products");
  CollectionReference _orderRef = FirebaseFirestore.instance.collection("UsersOrder");
  Future addToCart() async{
    // return await _orderRef.doc(getUserID()).collection("Order").doc("${_day}-${_time}").set(
    _date= _day+"-"+_time;
    return await _orderRef.doc("${_day}-${_time}-${getUserID()}").set(
        {
          "userID":getUserID(),
          "name":_userName,
          "phone":_userPhone,
          "location":_location,
          "note":_note,
          "total":_total,
          "deliveryPrice":_dliverPrice,
          "time":_date,
          "Item": FieldValue.arrayUnion(_productS),
          "status":"notAccepted"
        }
    );
  }
  Future removeFromCart() async{
    await _cartRef.doc(getUserID()).collection("Cart").get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
  Stream<QuerySnapshot> userCart ;
  Position _currentPosition;
  double _distanceInKilo;
  _getCurrentLocation() async {
    await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
      });
    }
    );
    _calc();
  }
  _calc() async {
    double distanceInMeters = await Geolocator.distanceBetween(
      _currentPosition.latitude,
      _currentPosition.longitude,
        30.8521012,32.3057855
    );
    setState(() {
      _distanceInKilo= distanceInMeters / 1000;
      print("distance : ${_distanceInKilo}");
      calcDelv();
    });
  }
  final CollectionReference infoCollection = FirebaseFirestore.instance.collection("Users") ;
  calcDelv(){
    if(_distanceInKilo > 7 && _distanceInKilo<=30){
      _dliverPrice = _distanceInKilo.toInt();
    }
    else if(_distanceInKilo>30){
      _dliverPrice = 30;
    }
    else{
      _dliverPrice = 7;
    }

    print("delvare : ${_dliverPrice}");
  }
  @override
  void initState() {
    userCart = _cartRef.doc(getUserID()).collection("Cart").snapshots();
    _getCurrentLocation();
    super.initState();
  }
  @override
   Widget build(BuildContext context){
    return Container(
        child:
          StreamBuilder(
            stream: userCart,//using snapshots() make it get data in real time
            builder: (context,snapshot){
              int _totalItems = 0;
              if(_productS!=null){
                _productS.clear();
              }
              if(snapshot.connectionState == ConnectionState.active){
                List _document = snapshot.data.docs;
                _totalItems = _document.length;
              }
              if (_currentPosition==null){
                return AlertDialog(
                    content: Container(
                        width: 30,
                        height: 120,
                          child :Column(
                            children: [
                              Text("جاري التحقق من مكانك اولا"),
                              Text(".للتأكد من ان الخدمه متاحه في منطقتك"),
                              CircularProgressIndicator(backgroundColor: Colors.black,),
                            ],
                          ),
                    ));
              }
              if(_distanceInKilo>30){
                return Scaffold(
                    backgroundColor: Theme.of(context).accentColor,
                    body:  Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            width: 150,
                            height: 150,
                            child: Image(
                                image: AssetImage(
                                    "assets/denied.png"
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text("نأسف ولكن الخدمه غير متاحه في منطقتك",
                              style: Constants.boldHeading,
                            ),
                          ),
                        ],
                      ),
                    )
                );
              }
              if (_totalItems==0)
              return Scaffold(
                  backgroundColor: Theme.of(context).accentColor,
                body:  Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        child: Image(
                            image: AssetImage(
                                "assets/empty-cart.png"
                            )
                        ),
                      ),
                      Align(
                            alignment: Alignment.center,
                            child: Text("لم يتم اضافه منتجات في السله",
                              style: Constants.boldHeading,
                            ),
                          ),
                    ],
                  ),
                )
              );
              else {
                return Stack(
                  children: [
                    FutureBuilder<QuerySnapshot>(
                      future: _cartRef.doc(getUserID())
                          .collection("Cart")
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Scaffold(
                            body: Center(
                              child: Text(
                                "غير مسموح لك بأستخدام التطبيق يجب عليك التسجيل اولا",
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          _total = 0;
                          return ListView(
                            padding: EdgeInsets.only(
                                top: 80,
                                left: 10,
                                right: 10,
                                bottom: 80
                            ),
                            children: snapshot.data.docs.map((document) {
                              return FutureBuilder<DocumentSnapshot>(
                                  future: _productRef.doc(document.id).get(),
                                  builder: (context, productSnap) {
                                    if (productSnap.hasError) {
                                      Center(
                                        child: Text(
                                            "يوجد خطأ في تحميل المنتجات"),
                                      );
                                    }
                                    else if (productSnap.connectionState ==
                                        ConnectionState.done) {
                                       Map _productMap = productSnap.data.data();
                                      _productS.add(
                                          "(${_productMap['name']}-${_productMap['price']}) "
                                              "(${document.data()["quantity"]})"
                                      );
                                      _total += _productMap['price']
                                          * document.data()["quantity"];
                                      return Container(
                                        padding: EdgeInsets.only(top: 12),
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.3,
                                        child:
                                            CartProductCard(
                                            title: _productMap['name'],
                                            price: _productMap['price'],
                                            quantaty: document.data()["quantity"],
                                            productId: document.id,
                                        ),
                                      );
                                    }
                                    return Padding(
                                        padding: EdgeInsets.only(
                                            top: 18,
                                            left: 18,
                                            right: 18,
                                            bottom: 10
                                        ),
                                        child: FakeCartProductCart()
                                    );
                                  }
                              );
                            }).toList(),
                          );
                        }
                        return Scaffold(
                          backgroundColor: Theme
                              .of(context)
                              .accentColor,
                          body: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.black,),
                          ),
                        );
                      },
                    ),
                    CustomActionBar(title: "صفحه الشراء",hasTrash: true,),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomBtn(
                          text: "باقي تفاصيل الطلب واتمام الشراء",
                          onPressed: () {
                            if (_currentPosition != null)
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.only(top: 25),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25))
                                        ),
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.9,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 1,
                                              height: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height * 0.13,
                                              child: Custom_input(
                                                hint: "ادخل العنوان",
                                                onChanged: (value) {
                                                  setState(() {
                                                    _location = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 1,
                                              height: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height * 0.13,
                                              child: Custom_input(
                                                hint: "ملحوظه",
                                                onChanged: (value) {
                                                  _note = value;
                                                },
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    "    جنيه",
                                                    style: Constants
                                                        .regularHeading,),
                                                  Text(
                                                    "${_dliverPrice}",
                                                    style: Constants
                                                        .regularRedHeading,),
                                                  Text(
                                                    ": سعر التوصيل",
                                                    style: Constants
                                                        .regularHeading,),
                                                ],),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    "    جنيه",
                                                    style: Constants
                                                        .regularHeading,),
                                                  Text(
                                                    "${_total}",
                                                    style: Constants
                                                        .regularRedHeading,),
                                                  Text(
                                                    ": سعر الطلب",
                                                    style: Constants
                                                        .regularHeading,),
                                                ],),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    "    جنيه",
                                                    style: Constants
                                                        .regularHeading,),
                                                  Text(
                                                    "${_total+_dliverPrice}",
                                                    style: Constants
                                                        .regularRedHeading,),
                                                  Text(
                                                    ": مجموع المطلوب دفعه",
                                                    style: Constants
                                                        .regularHeading,),
                                                ],),
                                            ),
                                            FutureBuilder<QuerySnapshot>(
                                                future: infoCollection.doc(
                                                    '${getUserID()}').collection(
                                                    "info").get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Scaffold(
                                                      body: Center(
                                                        child: Text(
                                                          "غير مسموح لك بأستخدام التطبيق يجب عليك التسجيل اولا",
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  else
                                                  if (snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                    return ListView(
                                                      shrinkWrap: true,
                                                      children: snapshot.data.docs
                                                          .map((document) {
                                                            _userName ="${document.data()['name']}";
                                                            _userPhone ="${document.data()['phone']}";
                                                        return Container(
                                                          width: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width * 0.3,
                                                          height: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .height * 0.2,
                                                          margin: EdgeInsets.only(
                                                              left: 5, right: 5),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(left: 5,
                                                                    right: 5),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "${document
                                                                          .data()['name']}",
                                                                      style: Constants
                                                                          .regularRedHeading,),
                                                                    Text(
                                                                      ":اسم المستخدم",
                                                                      style: Constants
                                                                          .regularHeading,),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(left: 5,
                                                                    right: 5),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "${document
                                                                          .data()['phone']}",
                                                                      style: Constants
                                                                          .regularRedHeading,),
                                                                    Text(
                                                                      ":رقم الهاتف",
                                                                      style: Constants
                                                                          .regularHeading,),
                                                                  ],),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                    );
                                                  }
                                                  return Center(
                                                      child: CircularProgressIndicator(
                                                        backgroundColor: Colors
                                                            .black,));
                                                }
                                            ),
                                            Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 1,
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height * 0.13,
                                                child: CustomBtn(text: "اطلب",
                                                  outlineBtn: true,
                                                  onPressed: () {
                                                    if (_location == null) {
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              content: Text(
                                                                  "تأكد من ادخال العنوان"),
                                                              actions: [
                                                                FlatButton(
                                                                    onPressed: () {
                                                                      Navigator
                                                                          .pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      "رجوع",)
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                      );
                                                    } else {
                                                      addToCart();
                                                      removeFromCart();
                                                      Navigator.pop(context);
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              content: Text(
                                                                  "تم طلب الاوردر بنجاح"),
                                                              actions: [
                                                                FlatButton(
                                                                    onPressed: () {
                                                                      Navigator
                                                                          .pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      "رجوع",)
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                      );
                                                    }
                                                  },)
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              );
                          }
                          ,)
                    )
                  ],
                );
              }
            },
          ),
    );
  }
}