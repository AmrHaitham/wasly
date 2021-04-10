// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:e_commerce/screens/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  final int selectedTap;
  final Function tabPressed;
  const BottomTabs({Key key, this.selectedTap, this.tabPressed}) : super(key: key);

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTap = 0;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
      _selectedTap = widget.selectedTap ?? 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        boxShadow: [
          BoxShadow(
            color :Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 20
          )
        ]
      ),
      margin: EdgeInsets.only(top :5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomTabBtn(
            imagePath: "assets/tab_home.png",
            selected: _selectedTap == 0 ? true : false,
            onPressed: (){
                widget.tabPressed(0);
            },
          ),
          BottomTabBtn(
            imagePath: "assets/tab_search.png",
            selected: _selectedTap == 1 ? true : false,
            onPressed: (){
                widget.tabPressed(1);
            },
          ),
          BottomTabBtn(
              imagePath: "assets/cart.png",
              selected: _selectedTap == 2 ? true : false,
              onPressed: (){
                  widget.tabPressed(2);
              },
            ),
          BottomTabBtn(
            imagePath: "assets/tab_logout.png",
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
                        alignment: Alignment.centerRight,
                        child :Text("هل انت متأكد من تسجيل الخروج"),
                        )
                      ),
                      actions: [
                        TextButton(
                            onPressed: (){Navigator.pop(context);},
                                child: Text("لا",)
                        ),
                        TextButton(
                            onPressed: (){
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => LoginPage())
                              );
                              }
                            , child: Text("نعم")
                        )
                      ],
                    );
                  }
              );
            },
          ),
        ],
      )
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final String imagePath;
  final bool selected ;
  final Function onPressed;
  const BottomTabBtn({Key key, this.imagePath, this.selected, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(8),
        // // padding: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selected ? Theme.of(context).accentColor : Colors.transparent,
              width: 3,
            )
          )
        ),
        child: Image(
            image: AssetImage(
              imagePath ?? "assets/tab_home.png"
            ),
          height: 18,
          width: 30,
          color: _selected ? Theme.of(context).accentColor : Colors.black,
        ),
      ),
    );
  }
}
