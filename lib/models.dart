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

class Outcome {
  static const win = 'win';
  static const loss = "loss";
}

class Result {
  String id;
  String opponentId;
  String hostId;
  Outcome outcome;

  Result(DocumentSnapshot snap) {
    id = snap.documentID;
    opponentId = snap.data["opponentId"];
    hostId = snap.data["hostId"];
    outcome = snap.data["outcome"];

    if (opponentId == null || hostId == null || outcome == null) {
      throw FormatException("Could not decode Result");
    }
  }
}

class User {
  String id;
  String name;
  String picture;

  User.create(this.id, this.name, this.picture);

  User(DocumentSnapshot snap) {
    id = snap.documentID;
    name = snap.data["firstName"];
    picture = snap.data["picture"] ?? "https://randomuser.me/api/portraits/women/78.jpg";
  }

  Map<String, dynamic> encode() {
    return {
      "firstName": name,
      "picture": picture
    };
  }
}

class Member {
  String id;
  User user;
  int score;

  Member(DocumentSnapshot memberSnap, DocumentSnapshot userSnap) {
    id = memberSnap.documentID;
    user = User(userSnap);
    score = memberSnap.data["score"];
  }
}