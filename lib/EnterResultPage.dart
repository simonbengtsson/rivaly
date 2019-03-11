import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rivaly/models.dart';

class EnterResultsScreen extends StatefulWidget {
  final Member opponent;

  EnterResultsScreen({this.opponent});

  @override
  _EnterResultsScreenState createState() => _EnterResultsScreenState();
}

class _EnterResultsScreenState extends State<EnterResultsScreen> {
  int mySavedRating = 100;

  int opponentSavedRating = 100;

  String outcome = Outcome.win;

  int getRatingDelta(double myGameResult, int myRating, int opponentRating) {
    if ([0, 0.5, 1].indexOf(myGameResult) == -1) {
      return null;
    }

    var myChanceToWin = 1 / (1 + pow(10, (opponentRating - myRating) / 400));

    return (32 * (myGameResult - myChanceToWin)).round();
  }

  @override
  Widget build(BuildContext context) {
    Widget opponentImage = new Container(
        width: 50,
        height: 50,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(this.widget.opponent.user.picture)
            )
        )
    );

    return Scaffold(
      appBar: AppBar(title: Text("Enter Results"), actions: <Widget>[
        IconButton(icon: Icon(Icons.send), onPressed: () {})
      ]),
      body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Opponent',
                            style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      Container(height: 10),
                      Row(
                        children: <Widget>[
                          opponentImage,
                          Container(width: 10),
                          Text(this.widget.opponent.user.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black54)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Winner',
                              style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: DropdownButton<String>(
                          value: this.outcome,
                          onChanged: (String newValue) {
                            this.setState(() {
                              this.outcome = newValue;
                            });
                          },
                          items: <String>[Outcome.win, Outcome.loss].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value == Outcome.win ? 'Me' : 'Opponent'),
                            );
                          })
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}