// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'OrdersPage.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class OrderDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot document;
  OrderDetailsPage({Key key, this.document}) : super(key: key);
  List itemList;
   Ticket ticket;
  String _day = DateFormat('yMMMMd').format(DateTime.now());
  String _time = DateFormat('Hms').format(DateTime.now());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getDriverEmail() {
    final User user = _auth.currentUser;
    return user.email;
  }
  CollectionReference _orderRef = FirebaseFirestore.instance.collection("UsersOrder");
  Future updateStatus(String status) async{
    return await _orderRef.doc("${document.id}").update(
        {
          "status":status
        }
    );
  }
  Future addDriver() async{
    return await _orderRef.doc("${document.id}").update(
        {
          "driverEmail":getDriverEmail(),
          "startTime":"${_day}-${_time}"
        }
    );
  }
  Future endTime() async{
    return await _orderRef.doc("${document.id}").update(
        {
          "endTime":"${_day}-${_time}"
        }
    );
  }
  Future deleteOrder() async{
    return await _orderRef.doc("${document.id}").delete();
  }
  Ticket testTicket() {
     ticket = Ticket(PaperSize.mm80);
    ticket.text('وصلي', styles: PosStyles(align: PosAlign.center,bold: true,height: PosTextSize.size2,
      width: PosTextSize.size2,));
    for(String item in document.data()["Item"]){
      ticket.text(item);
    }
     ticket.text(': ${document.data()["name"]}الاسم ');
     ticket.text(': ${document.data()["phone"]}رقم الهاتف ');
     ticket.text(': ${document.data()["total"]}سعر الطلب ');
     ticket.text(': ${document.data()["deliveryPrice"]}سعر التوصيل ');
    ticket.text(': ${document.data()["total"]+document.data()["deliveryPrice"]}مجموع الحساب ');
    ticket.feed(2);
    ticket.cut();
    return ticket;
  }

  @override
  Widget build(BuildContext context) {
    itemList = document.data()["Item"];
    return Scaffold(
      appBar: AppBar(title: Text("تفاصيل الطلب",style: Constants.regularHeading,)
              ,actions: [
                IconButton(icon: Icon(Icons.print), onPressed: () async{
                  print(ticket);
                  var printer;
                  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
                  printerManager.scanResults.listen((printers) async {
                    printer =printers.first;
                    });
                  printerManager.startScan(Duration(seconds: 4));
                  printerManager.selectPrinter(printer);
                  final PosPrintResult res = await printerManager.printTicket(testTicket());
                  print('Print result: ${res.msg}');
                },
                )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
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
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text("${document.data()["time"]}",style: Constants.boldHeading,),
                ),
                Container(
                  child: Text("${document.data()["location"]}",style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 18
                  ),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${document.data()["userID"]}"),
                    Text(":ID",style: Constants.regularRedHeading,)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${document.data()["name"]}",style: Constants.boldHeading,),
                    Text(":الاسم",style: Constants.regularRedHeading,)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectableText(
                      "${document.data()["phone"]}",
                      style: Constants.boldHeading,
                    ),
                    Text(":رقم الهاتف",style: Constants.regularRedHeading,)
                  ],
                ),
                if(document.data()["note"] != null)
                  Container(
                  margin: EdgeInsets.all(10),
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
                    children: [
                      Container(
                      decoration: BoxDecoration(
                      color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),),
                          width: double.infinity,
                          child: Text("ملحوظه",textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                            ),
                          )
                      ),
                      Text("${document.data()["note"]}",style: TextStyle(
                          fontSize: 18
                      ),),
                    ],
                    ),
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${document.data()["total"]}",style: Constants.boldHeading,),
                    Text(":سعر الطلب",style: Constants.regularRedHeading,)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${document.data()["deliveryPrice"]}",style: Constants.boldHeading,),
                    Text(":سعر التوصيل",style: Constants.regularRedHeading,)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${document.data()["total"]+document.data()["deliveryPrice"]}",style: Constants.boldHeading,),
                    Text(":مجموع الحساب",style: Constants.regularRedHeading,)
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(10),
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
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),),
                          width: double.infinity,
                          child: Text("الطلب",textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15
                            ),
                          )
                      ),
                      for(int i = 0; i< itemList.length ; i++)
                          Text("${itemList[i]}",style: TextStyle(
                            fontSize: 18
                          ),),
                    ],
                  ),
                ),
                if(document.data()["driverEmail"] != null)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("${document.data()["driverEmail"]}",style: Constants.boldHeading,),
                          Text(":ايميل السائق",style: Constants.regularRedHeading,)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("${document.data()["startTime"]}",style: Constants.regularDarkText,),
                          Text(":وقت قبول الطلب",style: Constants.regularRedHeading,)
                        ],
                      ),
                    ],
                  ),
                if(document.data()["endTime"] != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("${document.data()["endTime"]}",style: Constants.regularDarkText,),
                      Text(":وقت اتمام توصيل الطلب",style: Constants.regularRedHeading,)
                    ],
                  ),

                if(document.data()["status"]=="notAccepted")
                  CustomBtn(text: "اقبل الطلب",
                    onPressed: (){
                    updateStatus("accepted");
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => OrdersPage(status: "notAccepted",)),
                    );
                  }
                  ,),
                if(document.data()["status"]=="accepted")
                  CustomBtn(text: "حضر الطلب",
                      onPressed: (){
                        updateStatus("onPreparing");
                        addDriver();
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersPage(status: "accepted",)),
                        );
                      }
                  ),
                if(document.data()["status"]=="onPreparing")
                  CustomBtn(text: "تم التوصيل",
                      onPressed: (){
                        updateStatus("done");
                        endTime();
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersPage(status: "onPreparing",)),
                        );
                      }
                  ),
                if(document.data()["status"]=="done")
                  CustomBtn(text: "مسح الطلب",
                      onPressed: (){
                        deleteOrder();
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersPage(status: "done",)),
                        );
                      }
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}