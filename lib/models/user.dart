import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final List healthConditions;
  final List medicationCurrent;
  final List foodAlergies;
  double? caloriesPerDay;
  DateTime? dateOfBirth;
  double? bmi;
  double? height;
  double? weight;
  String? gender;
  
  

   User({this.dateOfBirth, this.bmi, this.height, this.weight,
      this.healthConditions = const [], this.medicationCurrent = const [], this.foodAlergies = const [], this.gender, this.caloriesPerDay,
      required this.username,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.bio,
      required this.followers,
      required this.following});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      dateOfBirth: snapshot["dateOfBirth"].toDate(),
      gender: snapshot["gender"],
      bmi: snapshot["bmi"].toDouble(),
      height: snapshot["height"].toDouble(),
      weight: snapshot["weight"].toDouble(),
      healthConditions: snapshot["healthCondition"] ?? [],
      medicationCurrent: snapshot["medicineContraction"] ?? [],
      foodAlergies: snapshot["foodAlergies"] ?? [],
      caloriesPerDay: snapshot["caloriesPerDay"].toDouble()
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "dateOfBirth": dateOfBirth,
        "bmi": bmi,
        "height": height,
        "weight": weight,
        "healthCondition": healthConditions,
        "medicineContraction": medicationCurrent,
        "foodAlergies": foodAlergies,
        "gender": gender,
        "caloriesPerDay": caloriesPerDay
      };
}
