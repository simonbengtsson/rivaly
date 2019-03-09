import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rivaly/models.dart';

class EnterResultsScreen extends StatelessWidget {
  int mySavedRating = 100;
  int opponentSavedRating = 100;

  Member opponent;

  EnterResultsScreen({this.opponent});

  // ELO Rankings
  // Inspiration from https://github.com/moroshko/elo.js/blob/master/elo.js
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
                image: NetworkImage(this.opponent.picture)
            )
        )
    );

    return Scaffold(
      body: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close)),
                  ),
                  Text('Enter results',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30))
                ],
              ),
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
                          Text(this.opponent.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black54)),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Winner',
                            style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      DropdownButton<String>(
                        value: 'Me',
                        onChanged: (String newValue) {
                          print(newValue);
                        },
                        items: <String>['Me', 'Opponent'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                            .toList(),
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