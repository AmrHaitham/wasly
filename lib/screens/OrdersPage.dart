// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/screens/OrderDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
    final String status ;

   OrdersPage({Key key, this.status}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}
class _OrdersPageState extends State<OrdersPage> {
    CollectionReference _orders =FirebaseFirestore.instance.collection("UsersOrder");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String getUserEmail() {
      final User user = _auth.currentUser;
      return user.email;
    }
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("صفحه الطلبات",style: Constants.regularHeading,),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh_sharp),
              onPressed: () {
                setState(() {
                  _orders =FirebaseFirestore.instance.collection("UsersOrder");
                });
              },
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.8,
            child: FutureBuilder<QuerySnapshot>(
              future: (widget.status=="onPreparing")
                    ? (getUserEmail()!="admin@iris.com")
                      ? _orders.where("status", isEqualTo: widget.status).where("driverEmail",isEqualTo: getUserEmail()).get()
                      : _orders.where("status", isEqualTo: widget.status).get()
                    :_orders.where("status", isEqualTo: widget.status).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text(
                        "${snapshot.error}",
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: snapshot.data.size,
                      itemBuilder: (ctx, index){
                        QueryDocumentSnapshot document = snapshot.data.docs[index];
                        return Container(
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
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text("${document.data()["name"]}",style: Constants.regularHeading,),
                            subtitle:Text("${document.data()["location"]}",style: Constants.regularRedHeading) ,
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => OrderDetailsPage(document: document,)));
                            },
                          ),
                        );
                      }
                  );
                }
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
}
