import 'dart:convert';

class UserRoles {
  static const defaultRole = "Default";
  static const captain = "Captain";
  static const administrator = "Administrator";
}

class User {
  String id;

  String firstName;
  String lastName;
  String username;

  String role;
  String teamName;
  int score;

  String email;
  String passwordHash;

  String get authentificationHeader {
    final String auth = "$id:$passwordHash";
    final String encodedAuth = utf8.fuse(base64).encode(auth);

    return "Basic $encodedAuth";
  }

  User.fromMap(Map<String, dynamic> map) :
    id = map['id'] as String,
    firstName = map['firstName'] as String,
    lastName = map['lastName'] as String,
    username = map['username'] as String,
    role = map['role'] as String,
    score = map['score'] as int,
    email = map['email'] as String,
    passwordHash = map['passwordHash'] as String;
}