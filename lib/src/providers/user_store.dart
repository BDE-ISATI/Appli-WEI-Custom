import 'dart:convert';
import 'dart:typed_data';

import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/authentication_serive.dart';
import 'package:flutter/material.dart';

class UserStore with ChangeNotifier {
  User _user;

  void loginUser(User loggedUser, {bool notify = true}) {
    _user = loggedUser;

    if (notify) {
      notifyListeners();
    }
  }

  void logoutUser() {
    _user = null;
    notifyListeners();
  }

  Future<User> getLoggedUser() async {
    return _user ??= await AuthenticationService.instance.getLoggedUser();
  }

  bool hasPermission(String level, String permission) {
    if (level == UserRoles.administrator) {
      return true;
    }

    if (level == UserRoles.captain) {
      return permission == UserRoles.captain || permission == UserRoles.defaultRole;
    } 
    
    if (level == UserRoles.defaultRole) {
      return permission == UserRoles.defaultRole;
    }

    return false;
  }

  String get id => _user.id;
  String get authentificationHeader => _user.authentificationHeader;

  Uint8List get profilePicture => (_user.profilePicture != null && _user.profilePicture.isNotEmpty) ? base64Decode(_user.profilePicture) : null;

  String get fullName => "${_user.firstName} ${_user.lastName}";
  String get firstName => _user.firstName;
  String get lastName => _user.lastName;

  String get role => _user.role;

  int get score => _user.score;
  String get teamName => _user.teamName;
  String get teamId => _user.teamId;

  void updateProfilePicture(String newProfilePicture) {
    _user.profilePicture = newProfilePicture;

    notifyListeners();
  }
}