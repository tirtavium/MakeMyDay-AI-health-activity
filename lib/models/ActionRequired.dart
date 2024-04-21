import 'package:cloud_firestore/cloud_firestore.dart';

class ActionRequiredPost {
  final String description;
  final String uid;
  final String username;
  final String actionRequiredId;
  final DateTime datePublished;
  final DateTime selectedDate;
  ActionRequiredPost({required this.selectedDate, required this.description, required this.uid, required this.username, required this.actionRequiredId, required this.datePublished});

static ActionRequiredPost fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ActionRequiredPost(
      description: snapshot["description"],
      uid: snapshot["uid"],
      actionRequiredId: snapshot["actionRequiredId"],
      datePublished: snapshot["datePublished"].toDate(),
      selectedDate: snapshot["selectedDate"].toDate(),
      username: snapshot["username"]);
  }

   Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "actionRequiredId": actionRequiredId,
        "datePublished": datePublished,
        "selectedDate": selectedDate
      };
}