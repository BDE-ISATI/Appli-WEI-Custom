import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/team_service.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  UserService._privateConstructor();

    // final String serviceBaseUrl = "https://192.168.1.63:45455/api/users";
    final String serviceBaseUrl = "https://appli.wei.isati.org/api/users";
    // final String serviceBaseUrl = "https://demo.appli.wei.isati.org/api/users";

  static final UserService instance = UserService._privateConstructor();

  final _client = http.Client();

  // Get
  Future<List<User>> getUsers(String authorizationHeader) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    final List<User> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> httpUsers = jsonDecode(response.body) as List<dynamic>;

      for (final user in httpUsers) {
        final User toAdd = User.fromMap(user as Map<String, dynamic>);
        final Team userTeam = await TeamService.instance.getTeamForUser(authorizationHeader, toAdd.id);
        
        if (userTeam != null) {
          toAdd.teamName = userTeam.name;
          toAdd.teamId = userTeam.id;
        }
        else {
          toAdd.teamName = "Sans équipe";
        }

        result.add(toAdd);
      }
    }
    else { 
      throw Exception("Can't get the users: ${response.body}");
    }

    return result;
  }

  Future<List<User>> getRanking(String authorizationHeader) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/ranking',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    final List<User> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> httpUsers = jsonDecode(response.body) as List<dynamic>;

      for (final user in httpUsers) {
        final User toAdd = User.fromMap(user as Map<String, dynamic>);
        final Team userTeam = await TeamService.instance.getTeamForUser(authorizationHeader, toAdd.id);
        
        if (userTeam != null) {
          toAdd.teamName = userTeam.name;
          toAdd.teamId = userTeam.id;

          result.add(toAdd);
        }
      }
    }
    else if (response.statusCode != 204) { 
      throw Exception("Can't get the ranking: ${response.body}");
    }

    return result;
  }

  Future<User> getUser(String authorizationHeader, String userId) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/$userId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      return null;
    }
      
    throw Exception("Can't get the user: ${response.body}");
  }

  Future<String> getProfilePicture(String authorizationHeader, String userId, String profilePictureId) async {
    final String cachedImage = await _getCachedImage(userId, profilePictureId);

    if (cachedImage != null) {
      return cachedImage;
    }

    final http.Response response = await _client.get(
      '$serviceBaseUrl/$userId/profile_picture',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    if (response.statusCode == 200) {
      final String profilePicture = (jsonDecode(response.body) as Map<String, dynamic>)["profilePicture"] as String;

      await _cacheImage(userId, profilePictureId, profilePicture);
      return profilePicture;
    }
    else if  (response.statusCode == 204) {
      final ByteData bytes = await rootBundle.load('assets/logo.jpg');
      
      final buffer = bytes.buffer;
      return base64.encode(Uint8List.view(buffer));
    }
    
    throw Exception("Can't get the profile picture: ${response.body}");
  }

  // Update
  Future updateUser(String authorizationHeader, User user) async {
    final http.Response response = await _client.put(
      '$serviceBaseUrl/admin_update',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: user.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to update user: ${response.body}");
    }    

    if (user.profilePictureId == "modified") {
      user.profilePictureId = null;
    }
  }

  Future updateProfilePicture(String authorizationHeader, String profilePicture) async {
    final http.Response response = await _client.put(
      '$serviceBaseUrl/update/profile_picture',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: jsonEncode(<String, String>{
        "profilePicture": profilePicture,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to update profile picture : ${response.body}");
    }

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("loggedUserProfilePicture", profilePicture);

  }

  // Delete
  Future deleteUser(String authorizationHeader, String userId) async {
    final http.Response response = await _client.delete(
      '$serviceBaseUrl/delete/$userId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      }
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to delete user: ${response.body}");
    }    

    await _deleteCache(userId);
  }

  Future<String> _getCachedImage(String userId, String imageId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getString("users_${userId}_imageId") == imageId) {
      return preferences.getString("users_${userId}_cachedImage");
    }

    return null;
  }

  Future _cacheImage(String userId, String imageId, String image) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("users_${userId}_imageId", imageId);
    preferences.setString("users_${userId}_cachedImage", image);
  }

  Future _deleteCache(String userId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("users_${userId}_imageId", null);
    preferences.setString("users_${userId}_cachedImage", null);
  }
  
}