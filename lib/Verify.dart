// Developed by ENG Amr Haitham amro88981@gmail.com
import 'dart:async';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/screens/LandingPage.dart';
import 'package:e_commerce/screens/LoginPage.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class VerifyEmail extends StatefulWidget {
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  Timer timer;
  final auth = FirebaseAuth.instance;
  User user;
  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();
    timer=Timer.periodic(Duration(seconds: 3), (timer) {
      user.reload();
    });
    super.initState();
  }
  Future<void> checkEmailVerified() async{
    user = auth.currentUser;
    await user.reload();
    if(user.emailVerified){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LandingPage())
      );
    }
    else{
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              content: Text("لم يتم التفعيل تأكد من فتح الرابط الموجود في الأيميل"),
              actions: [
                TextButton(
                    onPressed: (){Navigator.pop(context);},
                    child: Text("رجوع",)
                ),
              ],
            );
          }
      );
    }
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top:100),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    width: 120,
                    height: 120,
                    child: Image(
                      image: AssetImage(
                          "assets/clipboard.png"
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text("تم ارسال أيميل بتفعيل الحساب.",style: Constants.regularHeading,),
                  Text("برجاء فتح حسابك واضغل علي الايميل.",style: Constants.regularHeading,),
                  CustomBtn(text: "اضغط هنا بعد التفعيل",outlineBtn: true,onPressed: (){
                    checkEmailVerified();
                  },),
                  CustomBtn(text:"الرجوع الي صفحه التسجيل" ,onPressed: (){
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage())
                    );
                  },)
                ],
              )
            ),
        ),
      ),
    );
  }
}

