import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rivaly/LeaguePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rivaly/OnboardingPage.dart';
import 'package:rivaly/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyApp());

const primaryColor = Colors.purple;

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool loading = false;
  User currentUser;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  _setup() async {
    var user = await User.currentUser();
    this.setState(() {
      this.currentUser = user;
      this.loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("heyy");
    return MaterialApp(
      title: 'Rivaly',
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      home: this.loading ? null : this.currentUser == null ? OnboardingPage() : LeaguePage(League.demoLeagueId),
      debugShowCheckedModeBanner: false,
    );
  }
}
