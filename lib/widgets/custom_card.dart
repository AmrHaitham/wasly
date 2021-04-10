// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/screens/GetDoubleProducts.dart';
import 'package:e_commerce/screens/GetProducts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String image;

  const CustomCard({Key key, this.title, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String _title = title ?? "النوع" ;
    String _image = image ?? "assets/tab_home.png";
    return GestureDetector(
      onTap: (){
        if(_title=="محمصات"||_title=="خضروات و فواكه"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GetDoubleProducts(title:_title)),
          );
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GetProducts(title:_title)),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
        ),
        child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height*0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                      ),
                      child: Image(
                          image: AssetImage(
                              _image
                          ),
                          fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(_title,style: Constants.regularHeading,),
                  )
              ),
            ],
        ),
      ),
    );
  }
}
