import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class League {

  static const demoLeagueId = "fOfk8aa6Z3xsbJbVGDff";

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
  String outcome;

  Result(this.id, this.opponentId, this.hostId, this.outcome);

  Result.decode(DocumentSnapshot snap) {
    id = snap.documentID;
    opponentId = snap.data["opponentId"];
    hostId = snap.data["hostId"];
    outcome = snap.data["outcome"];

    if (opponentId == null || hostId == null || outcome == null) {
      throw FormatException("Could not decode Result");
    }
  }

  Map<String, dynamic> encode() {
    return {
      'id': id,
      'opponentId': opponentId,
      'hostId': hostId,
      'outcome': outcome
    };
  }
}

class User {
  String id;
  String name;
  String picture;

  User(this.id, this.name, this.picture);

  User.decode(Map<String, dynamic> data) {
    id = data["id"];
    name = data["firstName"];
    picture = data["picture"] ?? "https://randomuser.me/api/portraits/women/78.jpg";

    if (id == null || name == null || picture == null) {
      throw new Exception("Invalid user $id");
    }
  }

  Map<String, dynamic> encode() {
    return {
      "id": id,
      "firstName": name,
      "picture": picture
    };
  }

  static Future<User> currentUser() async {
    var prefs = await SharedPreferences.getInstance();
    var jsonString = prefs.getString("currentUser");
    if (jsonString == null) return null;
    return User.decode(jsonDecode(jsonString));
  }
}

class Member {
  String id;
  User user;
  int score;

  Member(this.id, this.user, this.score);

  static Future<Member> fetch(String leagueId, String userId) async {
    var snap = await Firestore.instance
        .document("leagues/$leagueId/members/$userId").get();
    var userSnap = await Firestore.instance
        .document("users/$userId").get();
    print("User: $userId");
    return Member.decode(snap, userSnap);
  }

  Member.decode(DocumentSnapshot memberSnap, DocumentSnapshot userSnap) {
    id = memberSnap.documentID;
    score = memberSnap.data["score"];

    var data = userSnap.data;
    data["id"] = userSnap.documentID;
    user = User.decode(data);
  }

  Map<String, dynamic> encode() {
    return {
      'score': score,
      'userId': user.id
    };
  }

}