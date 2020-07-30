import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/team_service.dart';
import 'package:appli_wei_custom/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  AuthenticationService._privateConstructor();

  final String serviceBaseUrl = "https://192.168.1.38:45455/api/authentication";

  static final AuthenticationService instance = AuthenticationService._privateConstructor();

  final _client = http.Client();

  // We need to check application settings to avoid need
  // to connect at every startup
  Future<User> getLoggedUser() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final String userId = preferences.getString("loggedUserId");

    if (userId == null) {
      return null;
    }

    return User.fromMap(<String, dynamic>{
      'id': preferences.getString("loggedUserId"),
      'firstName': preferences.getString("loggedUserFirstName"),
      'lastName': preferences.getString("loggedUserLastName"),
      'username': preferences.getString("loggedUserUsername"),
      'role': preferences.getString("loggedUserRole"),
      'score': preferences.getInt("loggedUserScore"),
      'email': preferences.getString("loggedUserEmail"),
      'passwordHash': preferences.getString("loggedUserPasswordHash")
    })
    ..profilePicture = preferences.getString("loggedUserProfilePicture")
    ..teamName = preferences.getString("loggedUserTeamName")
    ..teamId = preferences.getString("loggedUserTeamId");
  }

  Future<User> login(String username, String password) async {
    final http.Response response = await _client.post(
      '$serviceBaseUrl/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final User loggedUser = User.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
      final Team userTeam = await TeamService.instance.getTeamForUser(loggedUser.authentificationHeader, loggedUser.id);

      if (userTeam == null) {
        throw Exception("Vous n'avez pas encore d'équipe attribué");
      }

      loggedUser.profilePicture = await UserService.instance.getProfilePicture(loggedUser.authentificationHeader, loggedUser.id, loggedUser.profilePictureId);
      loggedUser.teamName = userTeam.name;
      loggedUser.teamId = userTeam.id;
      
      await _saveLoggedUserToSettings(loggedUser);

      return loggedUser;
    }

    throw Exception("Impossible to login : ${response.body}");
  }

  Future register(User user, String password) async {
    final http.Response response = await _client.post(
      '$serviceBaseUrl/register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "firstName": user.firstName,
        "lastName": user.lastName,
        "email": user.email,
        "username": user.username,
        "password": password
      }),
    );

    if (response.statusCode != 200) {
       throw Exception("Impossible to register: ${response.body}");
    }
  }

  Future<String> updatePassword(String authorizationHeader, String oldPassword, String newPassword) async {
    final http.Response response = await _client.put(
      '$serviceBaseUrl/update/password',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: jsonEncode(<String, String>{
        "oldPassword": oldPassword,
        "newPassword": newPassword
      }),
    );

    if (response.statusCode == 200) {
      final String passwordHash = (jsonDecode(response.body) as Map<String, dynamic>)["newPasswordHash"] as String;

      final SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("loggedUserPasswordHash", passwordHash);

      return passwordHash;
    }
    
    throw Exception("Can't modify the password : ${response.body}");
  }

  Future logoutUser() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("loggedUserId", null);
    preferences.setString("loggedUserProfilePicture", null);
    preferences.setString("loggedUserFirstName", null);
    preferences.setString("loggedUserLastName", null);
    preferences.setString("loggedUserUsername", null);
    preferences.setString("loggedUserRole", null);
    preferences.setInt("loggedUserScore", null);
    preferences.setString("loggedUserEmail", null);
    preferences.setString("loggedUserPasswordHash", null);
    preferences.setString("loggedUserTeamName", null);
    preferences.setString("loggedUserTeamId", null);
  }

  Future _saveLoggedUserToSettings(User loggedUser) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("loggedUserId", loggedUser.id);
    preferences.setString("loggedUserProfilePicture", loggedUser.profilePicture);
    preferences.setString("loggedUserFirstName", loggedUser.firstName);
    preferences.setString("loggedUserLastName", loggedUser.lastName);
    preferences.setString("loggedUserUsername", loggedUser.username);
    preferences.setString("loggedUserRole", loggedUser.role);
    preferences.setInt("loggedUserScore", loggedUser.score);
    preferences.setString("loggedUserEmail", loggedUser.email);
    preferences.setString("loggedUserPasswordHash", loggedUser.passwordHash);
    preferences.setString("loggedUserTeamName", loggedUser.teamName);
    preferences.setString("loggedUserTeamId", loggedUser.teamId);
  }
}