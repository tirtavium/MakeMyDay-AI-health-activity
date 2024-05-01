import 'package:flutter/widgets.dart';
import 'package:MakeMyDay/models/user.dart';
import 'package:MakeMyDay/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

   Future<void> updateUser(User user) async {
     final result = await _authMethods.updateUser(user: user);
     _user = user;
     notifyListeners();
   }
}