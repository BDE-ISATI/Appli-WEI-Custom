import 'dart:convert';

import 'package:appli_wei_custom/models/user.dart';
import 'package:flutter/material.dart';

class UserStore with ChangeNotifier {
  UserStore({@required User user}): _user = user;

  final User _user;

  String get authentificationHeader {
    final String auth = "${_user.id}:${_user.passwordHash}";
    final String encodedAuth = utf8.fuse(base64).encode(auth);

    return "Basic $encodedAuth";
  }

  String get fullName => "${_user.firstName} ${_user.lastName}";
  String get firstName => _user.firstName;
  String get lastName => _user.lastName;

  int get score => _user.score;
  String get teamName => _user.teamName;
}