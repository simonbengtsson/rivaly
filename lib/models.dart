import 'package:cloud_firestore/cloud_firestore.dart';

class League {
  String id;
  String picture;
  String name;
  String note;

  League(DocumentSnapshot snap) {
    var data = snap.data;
    id = snap.documentID;
    name = data["name"];
    picture = data["picture"] ?? 'https://cdn6.f-cdn.com/contestentries/1216494/10168094/5a47db5a18926_thumb900.jpg';
    note = data["note"];
  }
}

class Member {
  String id;
  String name;
  String picture;
  int score;

  Member(DocumentSnapshot memberSnap, DocumentSnapshot userSnap) {
    var memberData = memberSnap.data;
    id = memberSnap.documentID;
    var userData = userSnap.data;
    score = memberData["score"];
    name = userData["first_name"];
    picture = userData["picture"] ?? "https://randomuser.me/api/portraits/women/78.jpg";
  }
}