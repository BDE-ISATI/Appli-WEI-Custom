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

  String get fullName => "${_user.firstName} ${_user.lastName}";
  String get firstName => _user.firstName;
  String get lastName => _user.lastName;

  String get role => _user.role;

  int get score => _user.score;
  String get teamName => _user.teamName;
}