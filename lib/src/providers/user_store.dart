import 'package:appli_wei_custom/models/user.dart';
import 'package:flutter/material.dart';

class UserStore with ChangeNotifier {
  User _user;

  void loginUser(User loggedUser) {
    _user = loggedUser;
    notifyListeners();
  }

  String get fullName => "${_user.firstName} ${_user.lastName}";
  String get firstName => _user.firstName;
  String get lastName => _user.lastName;

  int get score => _user.score;
  String get teamName => _user.teamName;
}