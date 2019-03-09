import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rivaly/LeaguePage.dart';

const primaryColor = Colors.purple;

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  File _image;

  @override
  void initState() {
    super.initState();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
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
              Text('Join Stena Center PingPong league',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 40)),
              Container(height: 25),
              GestureDetector(
                  onTap: getImage,
                  child: _image != null ? widget : Icon(Icons.person)),
              Container(height: 25),
              TextField(
                style: TextStyle(fontSize: 40, color: Colors.black87),
                decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Name'),
              ),
              Container(height: 25),
              SizedBox(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LeaguePage()),
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