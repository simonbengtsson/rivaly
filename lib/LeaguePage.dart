import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rivaly/EnterResultPage.dart';
import 'package:rivaly/models.dart';

const primaryColor = Colors.purple;
const demoLeagueId = "fOfk8aa6Z3xsbJbVGDff";

class LeaguePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LeaguePageState();
  }
}

class _LeaguePageState extends State<LeaguePage> {
  League _league;
  List<Member> _members;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    var snap =
        await Firestore.instance.document('leagues/$demoLeagueId').get();

    setState(() {
      _league = League(snap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rivaly")),
      body: _league == null ? Text("Loading...") : buildLeague(_league),
    );
  }

  Widget buildLeague(League league) {
    return Column(children: [
      Stack(children: <Widget>[
        Image.network(_league.picture),
        Positioned(
          bottom: 20,
          left: 20,
          child: Text(_league.name,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Colors.white)),
        ),
      ]),
      Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text('Ranking',
                  textAlign: TextAlign.left,
                  style:
                  TextStyle(fontWeight: FontWeight.w900, fontSize: 30)),
            )),
        RankingList(_league.id)
      ]),
    ]);
  }
}

class RankingList extends StatefulWidget {
  String _leagueId;

  RankingList(String leagueId) {
    _leagueId = leagueId;
  }

  @override
  State<StatefulWidget> createState() {
    return _RankingListState(_leagueId);
  }
}

class _RankingListState extends State<RankingList> {
  String _leagueId;
  List<Member> _members;

  _RankingListState(String leagueId) {
    _leagueId = leagueId;
    _fetchData();
  }

  _fetchData() async {
    var membersSnap = await Firestore.instance
        .collection('leagues/$demoLeagueId/members')
        .getDocuments();
    Map<String, DocumentSnapshot> userMap = Map();
    var users = await _fetchRelations(
        Firestore.instance.collection('users'),
        membersSnap.documents.toList().map((snap) {
          return snap.documentID;
        }).toList());
    setState(() {
      _members = membersSnap.documents.toList().map((snap) {
        return Member(snap, users[snap.documentID]);
      }).toList();
    });
  }

  Future<Map<String, DocumentSnapshot>> _fetchRelations(
      CollectionReference ref, List<String> ids) async {
    var futures = ids.map((id) {
      return ref.document(id).get();
    });
    Map<String, DocumentSnapshot> resultMap = Map();
    var result = await Future.wait(futures);
    result.toList().forEach((doc) {
      resultMap[doc.documentID] = doc;
    });
    return resultMap;
  }

  @override
  Widget build(BuildContext context) {
    if (_members == null) {
      return Text("Loading...");
    }
    if (_members.length == 0) {
      return Text("No members");
    }

    var listTextStyle =  TextStyle(fontWeight: FontWeight.w500, fontSize: 18);

    return Column(
        children: _members
            .asMap()
            .map((index, member) {
              return MapEntry(
                  index,
                  ListTile(
                    leading: new Container(
                        width: 35,
                        height: 35,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(member.user.picture)))),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("${member.score}", style: listTextStyle),
                        IconButton(
                          icon: Icon(Icons.cake),
                          color: primaryColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EnterResultsScreen(opponent: member),
                                    fullscreenDialog: true),
                              );
                            }
                        )
                      ],
                    ),
                    title: Text("${index + 1} ${member.user.name}", style: listTextStyle),
                  ));
            })
            .values
            .toList());
  }
}
