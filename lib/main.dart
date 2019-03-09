import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rivaly/LeaguePage.dart';

void main() => runApp(MyApp());

const primaryColor = Colors.purple;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.black, //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      //home: OnboardingPage(),
      home: LeaguePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
