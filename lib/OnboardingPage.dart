import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rivaly/LeaguePage.dart';
import 'package:rivaly/models.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const primaryColor = Colors.purple;

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File _image;
  final nameFieldController = TextEditingController();
  bool actionButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.black, //or set color with: Color(0xFF0000FF)
    ));
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  _signUp() async {
    var firebaseUser = await _auth.signInAnonymously();
    var user = User(firebaseUser.uid, nameFieldController.text, null);
    await Firestore.instance
        .document("users/${firebaseUser.uid}")
        .setData(user.encode());

    var member = Member(user.id, user, 900);
    await Firestore.instance
        .document("leagues/${League.demoLeagueId}/members/${user.id}")
        .setData(member.encode());
    var prefs = await SharedPreferences.getInstance();
    var jsonString = jsonEncode(user.encode());
    await prefs.setString("currentUser", jsonString);
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = new Container(
        width: 150,
        height: 150,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage("https://randomuser.me/api/portraits/women/78.jpg"))));

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Join SF PingPong league',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 40)),
              Container(height: 25),
              GestureDetector(
                  onTap: getImage,
                  child: _image != null ? widget : Icon(Icons.person)),
              Container(height: 25),
              TextField(
                style: TextStyle(fontSize: 40, color: Colors.black87),
                controller: nameFieldController,
                textCapitalization: TextCapitalization.words,
                onChanged: (text) {
                  this.setState(() {
                    this.actionButtonDisabled = text.length < 3;
                  });
                },
                decoration: InputDecoration(border: InputBorder.none, hintText: 'Name'),
              ),
              Container(height: 25),
              SizedBox(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),

                  onPressed: this.actionButtonDisabled ? null : () async {
                    this.setState(() { this.actionButtonDisabled = true; });
                    await _signUp();
                    Navigator.pushReplacement(
                      context,
                      FadeInSlideOutRoute(builder: (context) => LeaguePage(League.demoLeagueId)),
                    );
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: primaryColor,
                ),
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}