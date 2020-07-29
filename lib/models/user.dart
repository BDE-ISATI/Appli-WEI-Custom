import 'dart:convert';

mixin UserRoles {
  static String defaultRole = "Default";
  static String captain = "Captain";
  static String administrator = "Administrator";
}

class User {
  String id;

  String profilePicture;
  String profilePictureId;

  String firstName;
  String lastName;
  String username;

  String role;
  String teamName;
  String teamId;
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
    profilePictureId = map['profilePictureId'] as String,
    firstName = map['firstName'] as String,
    lastName = map['lastName'] as String,
    username = map['username'] as String,
    role = map['role'] as String,
    score = map['score'] as int,
    email = map['email'] as String,
    passwordHash = map['passwordHash'] as String;

  String toJson() => jsonEncode(<String, dynamic>{
    "id": id,
    "profilePicture": profilePicture,
    "profilePictureId": profilePictureId,
    "firstName": firstName,
    "lastName": lastName,
    "username": username,
    "email": email,
    "role": role,
    "score": score
  });
}