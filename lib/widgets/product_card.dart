// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/widgets/custom_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String title;
  final String image;
  final num price;
  final String subType;
  final String productId;

  const ProductCard({Key key, this.title, this.image, this.price, this.subType, this.productId}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    String _title = widget.title ?? "النوع" ;
    String _image = widget.image ?? "";
    String _subType = widget.subType ?? "" ;
    num _price = widget.price ?? 0 ;
    String _productId = widget.productId;

    return Container(
      // padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.7,
            child: Text(
              "${_title}",
              style: Constants.boldHeading,
            ),
          ),
          Stack(
              children: [
                if(_image =="")
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    width:100,
                    height: 140,
                    child: Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                          child: Image.asset("assets/wasly icon.jpeg")
                      ),
                    ),
                  ),
                if(_image!="")
                Container(
                    padding: EdgeInsets.only(left: 20),
                    width:100,
                    height: 140,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image(
                          image: NetworkImage(
                              _image
                          ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Text(
                          "${_subType}",
                          style: Constants.regularRedHeading,
                        ),
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10,top: 30),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "جنيه ${_price}",
                        style: Constants.regularRedHeading,
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 85,
                      top: 60
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomCounter(productId: _productId),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
