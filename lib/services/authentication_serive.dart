import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/team_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  AuthenticationService._privateConstructor();

  final String serviceBaseUrl = "https://192.168.1.38:45455/api/authentication";

  static final AuthenticationService instance = AuthenticationService._privateConstructor();

  // TODO: remove this when API will be released
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  http.Client localApiClient() {
    final ioClient = HttpClient()..badCertificateCallback = _certificateCheck;

    return IOClient(ioClient);
  }

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
    ..teamName = preferences.getString("loggedUserTeamName");
  }

  Future<User> loggin(String username, String password) async {
    final http.Response response = await localApiClient().post(
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
      loggedUser.teamName = (await TeamService.instance.teamForUser(loggedUser.authentificationHeader, loggedUser.id)).name;
      
      await _saveLoggedUserToSettings(loggedUser);

      return loggedUser;
    }

    throw Exception("Impossible to login : ${response.body}");
  }

  Future _saveLoggedUserToSettings(User loggedUser) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("loggedUserId", loggedUser.id);
    preferences.setString("loggedUserFirstName", loggedUser.firstName);
    preferences.setString("loggedUserLastName", loggedUser.lastName);
    preferences.setString("loggedUserUsername", loggedUser.username);
    preferences.setString("loggedUserRole", loggedUser.role);
    preferences.setInt("loggedUserScore", loggedUser.score);
    preferences.setString("loggedUserEmail", loggedUser.email);
    preferences.setString("loggedUserPasswordHash", loggedUser.passwordHash);
    preferences.setString("loggedUserTeamName", loggedUser.teamName);
  }
}