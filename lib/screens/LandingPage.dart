// Developed by ENG Amr Haitham amro88981@gmail.com
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/Verify.dart';
import 'package:e_commerce/screens/AdminPanel.dart';
import 'package:e_commerce/screens/HomePage.dart';
import 'package:e_commerce/screens/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LandingPage extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){
          if (snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text(
                  "Initialization error : ${snapshot.error}",
                  style: Constants.regularHeading,
                ),
              ),
            );
          }
          else if(snapshot.connectionState == ConnectionState.done){
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context,streamSnapshot){
                if (snapshot.hasError){
                  return Scaffold(
                    body: Center(
                      child: Text(
                        "Auth error :${streamSnapshot.error}",
                        style: Constants.regularHeading,
                      ),
                    ),
                  );
                }
                else if(streamSnapshot.connectionState == ConnectionState.active){
                  User _user = streamSnapshot.data;
                  if (_user == null){
                    return LoginPage();
                  }
                  else {
                  return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance.collection('Users').doc(_user.uid).collection("info").get(),
                      builder: (context,querySnapshot) {
                        if (querySnapshot.hasData) {
                          if (_user.emailVerified) {
                            if (querySnapshot.data.docs.first["type"] ==
                                "driver") {
                              return AdminPanel();
                            }
                            else
                              return HomePage();
                          }
                          else {
                            if (_user.uid == "fpPekUP8XAeV0ehTYz8h2dnTcKu1") {
                              return AdminPanel();
                            }
                            else
                              return VerifyEmail();
                          }
                        }
                        else if (querySnapshot.hasError) {
                          return Scaffold(
                            backgroundColor: Theme
                                .of(context)
                                .accentColor,
                            body: Center(
                              child: Container(
                                width: 80,
                                height: 80,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballPulse,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }
                        else {
                          return Scaffold(
                            backgroundColor: Theme
                                .of(context)
                                .accentColor,
                            body: Center(
                              child: Container(
                                width: 80,
                                height: 80,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballPulse,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }
                      }
                  );}
                }
                return Scaffold(
                  backgroundColor: Theme.of(context).accentColor,
                  body: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Scaffold(
            backgroundColor: Theme.of(context).accentColor,
            body: Center(
              child: Container(
                width: 80,
                height: 80,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }
    );
  }
}
