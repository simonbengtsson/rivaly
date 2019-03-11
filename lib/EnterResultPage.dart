import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rivaly/models.dart';

class EnterResultPage extends StatefulWidget {
  final Member opponent;

  EnterResultPage({this.opponent});

  @override
  _EnterResultPageState createState() => _EnterResultPageState();
}

class _EnterResultPageState extends State<EnterResultPage> {
  int mySavedRating = 100;

  String outcome = Outcome.win;

  int getNewRating(double myGameResult, int targetRating, int opponentRating) {
    if ([0, 0.5, 1].indexOf(myGameResult) == -1) {
      return null;
    }

    var myChanceToWin = 1 / (1 + pow(10, (opponentRating - targetRating) / 400));

    var delta = (32 * (myGameResult - myChanceToWin)).round();

    return targetRating + delta;
  }

  _submitResults() async {
    var currentUser = await User.currentUser();
    var me = await Member.fetch(League.demoLeagueId, currentUser.id);

    var gameResult = this.outcome == Outcome.win ? 1.0 : 0.0;
    var myNewRating = this.getNewRating(gameResult, me.score, this.widget.opponent.score);

    var opponentGameResult = this.outcome == Outcome.loss ? 1.0 : 0.0;
    var opponentNewRating = this.getNewRating(opponentGameResult, this.widget.opponent.score, me.score);

    var batch = Firestore.instance.batch();


    var resultsDoc = Firestore.instance
        .collection("leagues/${League.demoLeagueId}/results").document();
    var result = Result(resultsDoc.documentID, null, null, outcome);
    batch.setData(resultsDoc, result.encode());

    var meDoc = Firestore.instance
        .document("leagues/${League.demoLeagueId}/members/${me.id}");
    batch.updateData(meDoc, {'score': myNewRating});

    var opponentDoc = Firestore.instance
        .document("leagues/${League.demoLeagueId}/members/${this.widget.opponent.id}");
    batch.updateData(opponentDoc, {'score': opponentNewRating});

    await batch.commit();
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
        IconButton(icon: Icon(Icons.send), onPressed: () async {
          await _submitResults();
          Navigator.pop(context);
        })
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