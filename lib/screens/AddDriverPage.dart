// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:e_commerce/widgets/numCustom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Verify.dart';


class DriverRegisterPage extends StatefulWidget {
  @override
  _DriverRegisterPageState createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  testPhone(){
    if(_phoneNumber.isEmpty || _phoneNumber.characters.first !="0"){
      print(_phoneNumber.isEmpty);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              content: Text("ادخل بيانات صحيحه"),
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getUserID() {
    final User user = _auth.currentUser;
    return user.uid;
  }
  final firestoreInstance = FirebaseFirestore.instance;
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
              TextButton(
                  onPressed: (){Navigator.pop(context);}
                  , child: Text("خروج")
              )
            ],
          );
        }
    );
  }
  Future<String> _createAccount() async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail,
          password: _registerPassword
      );
      return null;
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        return 'كلمه السر التي ادخلتها ضعيفه جدا.';
      } else if (e.code == 'email-already-in-use') {
        return 'الحساب الذي ادخلته موجود بالفعل';
      }
      return "الحساب الذي ادخلته او كلمه السر غير صحيحه.";
    }catch (e) {
      return 'تأكد من اتصالك بالنترنت قبل التسجيل.';
    }
  }

  void _submitForm() async{
    String _createAccountFeedback = await _createAccount();
    if(_createAccountFeedback != null){
      setState(() {
        _isloading = false;
      });
      _alterDialogBuilder(_createAccountFeedback);
    }else{
      setState(() {
        _isloading = false;
      });
      _submitData();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => VerifyEmail())
      );
    }
  }
  void _submitData() async{
    firestoreInstance.collection("Users").doc('${getUserID()}').collection("info").add(
        {
          "name" : _name,
          "phone" : _phoneNumber,
          "type":"driver"
        }
    );
  }
  bool _isloading = false;
  String _registerEmail ="";
  String _registerPassword="";
  String _name="";
  String _phoneNumber="";
  FocusNode _passwordFocusNode ;
  double chight;
  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }
  @override
  void dispose(){
    _passwordFocusNode.dispose();
    // _numberFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.height<683.4285714285714) {
      chight = 0.71;
    }
    else {
      chight = 0.65;
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("صفحه اضافه سائق"),),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*chight,
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
                      Custom_input(
                          hint: "الاسم",
                          onChanged: (value){
                            _name=value;
                          },
                          textInputAction: TextInputAction.next
                      ),
                      NumCustom_input(
                          hint: "رقم الهاتف",
                          onChanged: (value){
                            _phoneNumber=value;
                          },
                          onSubmitted: (value){
                            testPhone();
                          },
                          textInputAction: TextInputAction.next
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
                          _submitForm();
                          setState(() {
                            _isloading = true;
                          });
                        },
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height*0.13,
                        child: CustomBtn(
                          text: "اضافه حساب السائق",
                          onPressed: (){
                            testPhone();
                            if(_phoneNumber.isNotEmpty && _phoneNumber.characters.first =="0") {
                              _submitForm();
                              setState(() {
                                _isloading = true;
                              });
                            }
                          },
                          isLoading: _isloading,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
