import 'package:corona_tracker/views/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:corona_tracker/views/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final backgroundColor=const Color( 0xFF3C3B58);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Corona Tracker",
        theme: ThemeData(
        primaryColor:backgroundColor
    ),
    home: SplashScreen(),
      routes: <String,WidgetBuilder>{
          '/singup':(BuildContext context)=>Home(),
           '/home':(BuildContext context)=>Home(),
      },
    );
  }
}

