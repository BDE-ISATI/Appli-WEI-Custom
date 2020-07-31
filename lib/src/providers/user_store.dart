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

  bool hasPermission(String permission) {
    if (_user.role == UserRoles.administrator) {
      return true;
    }

    if (_user.role == UserRoles.captain) {
      return permission == UserRoles.captain || permission == UserRoles.defaultRole;
    } 
    
    if (_user.role == UserRoles.defaultRole) {
      return permission == UserRoles.defaultRole;
    }

    return false;
  }

  String get id => _user.id;
  String get authentificationHeader => _user.authentificationHeader;

  MemoryImage get profilePicture => (_user.profilePicture != null) ? _user.profilePicture : null;
  String get profilePictureId => _user.profilePictureId;

  String get fullName => "${_user.firstName} ${_user.lastName}";
  String get firstName => _user.firstName;
  String get lastName => _user.lastName;

  String get role => _user.role;

  int get score => _user.score;
  String get teamName => _user.teamName;
  String get teamId => _user.teamId;

  void updateProfilePicture(MemoryImage newProfilePicture) {
    _user.profilePicture = newProfilePicture;

    notifyListeners();
  }

  void updatePassword(String passwordHash) {
    _user.passwordHash = passwordHash;

    notifyListeners();
  }
}