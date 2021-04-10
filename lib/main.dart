// Developed by ENG Amr Haitham amro88981@gmail.com
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/LandingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String infoContainorColor ="ffc600";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: Colors.transparent),
        textTheme: GoogleFonts.amiriTextTheme(
          Theme.of(context).textTheme,
        ),
        accentColor: Color(int.parse("0xff${infoContainorColor}")),
      ),

      home: LandingPage()
    );
  }
}

