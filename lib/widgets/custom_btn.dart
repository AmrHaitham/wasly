// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool outlineBtn;
  final bool isLoading;

  const CustomBtn({Key key, this.text, this.onPressed, this.outlineBtn,this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _outlineBtn = outlineBtn ?? false ;
    bool _isLoading = isLoading ?? false ;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60.0,
        decoration: BoxDecoration(
          color: _outlineBtn ? Colors.transparent :Colors.black,
          border: Border.all(
              color: Colors.black,
              width: 2.0
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16
        ),
        child: Stack(
          children:[
            Visibility(
              visible: _isLoading ? false : true ,
              child:Center(
              child: Text(
              text ?? "Text",
              style: TextStyle(
                fontSize: 17.0,
                color:  _outlineBtn ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600
              ),
          ),
            )
            ),
            Visibility(
              visible: _isLoading,
              child:Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            )
            )
          ]
        ),
      ),
    );
  }
}
