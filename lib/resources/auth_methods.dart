import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MakeMyDay/models/user.dart' as model;
import 'package:MakeMyDay/resources/storage_methods.dart';
import 'dart:developer';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    print("=========signUpUser");
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        print("====tirta signup");
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            healthConditions: [],
            medicationCurrent: [],
            foodAlergies: []);
        print(user.toJson());

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson())
            .onError((e, _) => print("Error writing document: $e"));

        //await _firestore.collection("users").add(user.toJson()).then((DocumentReference doc) =>
        //print('DocumentSnapshot added with ID: ${doc.id}'));

        print("success register");
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      print("error firestore $err");
      return err.toString();
    }
    log("========result firestore $res");
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      print(err.toString());
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> updateUser({required model.User user}) async {
    String res = "Some error Occurred";
    print("=========updateUser");
    try {
      await _firestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson())
          .onError((e, _) => print("Error writing document: $e"));

      res = "success";
    } catch (err) {
      print("error firestore $err");
      return err.toString();
    }
    print("========result firestore $res");
    return res;
  }
}
