// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/screens/LandingPage.dart';
import 'package:e_commerce/screens/registerPage.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:flutter/painting.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isloading = false;
  Future<void> _alterDialogBuilder(String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("خطأ"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                  onPressed: (){Navigator.pop(context);}
                  , child: Text("خروج")
              )
            ],
          );
        }
    );
  }
  Future<String> _login() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _registerEmail,
          password: _registerPassword
      );
      return null;
    }  on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'لا يوجد مستخدم بهذا الحساب.';
      } else if (e.code == 'wrong-password') {
        return 'كلمه السر غير صحيحه.';
      }else{
        return 'تأكد من ادخال بيانات صحيحه و اتصالك بالأنترنت';
      }
    }
  }
  void _submitForm() async{
    String _loginFeedback = await _login();
    if(_loginFeedback != null){
      setState(() {
        _isloading = false;
      });
      _alterDialogBuilder(_loginFeedback);
    }else{
      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LandingPage())
      );
    }
  }
  String _registerEmail ="";
  String _registerPassword="";
  FocusNode _passwordFocusNode ;
  double chight;
  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.height<683.4285714285714) {
      chight = 90;
    }
    else {
      chight = 140;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 10.0
                ),
                child: Text("اهلا بك, سجل الي حسابك",
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height*0.65,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
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
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10,bottom: 5),
                      height: chight,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image.asset("assets/wasly icon.jpeg",)
                      ),
                    ),
                    Custom_input(
                      hint: "الحساب",
                      onChanged:(value){
                        _registerEmail= value;
                      },
                      onSubmitted: (value){
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    Custom_input(
                      hint: "كلمه السر",
                      onChanged:(value){
                        _registerPassword = value;
                      },
                      isPasswordField: true,
                      focusNode: _passwordFocusNode,
                      onSubmitted: (value){
                        setState(() {
                          _isloading = true;
                        });
                        _submitForm();
                      },
                    ),
                    CustomBtn(
                      text: "تسجيل الدخول",
                      onPressed: (){
                        _submitForm();
                        setState(() {
                          _isloading = true;
                        });
                      },
                      isLoading: _isloading,
                    ),
                  ],
                ),
              ),
              CustomBtn(
                text: "اضافه حساب",
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                      builder: (context)=>RegisterPage()
                  ));},
                outlineBtn: true,
              ),
              ],

          ),
        ),
      )
    );
  }
}
