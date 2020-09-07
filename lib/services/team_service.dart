import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/models/user.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TeamService {
  TeamService._privateConstructor();

  // final String serviceBaseUrl = "https://192.168.0.18:45455/api/teams";
  final String serviceBaseUrl = "https://appli.wei.isati.org/api/teams";

  static final TeamService instance = TeamService._privateConstructor();

  final _client = http.Client();

  // Get
  Future<Team> getTeamForUser(String authorizationHeader, String userId) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/for_user/$userId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    if (response.statusCode == 200) {
      return Team.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
    }
    if (response.statusCode == 204) {
      return null;
    }
      
    throw Exception("Can't get the team for user : ${response.body}");
  }

  Future<List<Team>> getTeams(String authorizationHeader) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    final List<Team> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> httpTeams = jsonDecode(response.body) as List<dynamic>;

      for (final team in httpTeams) {
        result.add(Team.fromMap(team as Map<String, dynamic>));
      }
    }
    else { 
      throw Exception("Can't get the teams: ${response.body}");
    }

    return result;
  }

  Future<List<Team>> getRanking(String authorizationHeader) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/ranking',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    final List<Team> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> httpTeams = jsonDecode(response.body) as List<dynamic>;

      for (final team in httpTeams) {
        result.add(Team.fromMap(team as Map<String, dynamic>));
      }
    }
    else if (response.statusCode != 204) {
      throw Exception("Can't get the teams: ${response.body}");
    }

    return result;
  }

  Future<String> getTeamImage(String authorizationHeader, String teamId, String imageId) async {
    final String cachedImage = await _getCachedImage(teamId, imageId);

    if (cachedImage != null) {
      return cachedImage;
    }

    final http.Response response = await _client.get(
      '$serviceBaseUrl/$teamId/image',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    if (response.statusCode == 200) {
      final String challengeImage = (jsonDecode(response.body) as Map<String, dynamic>)["image"] as String;

      await _cacheImage(teamId, imageId, challengeImage);
      return challengeImage;
    }
    else if  (response.statusCode == 204) {
      final ByteData bytes = await rootBundle.load('assets/logo.jpg');
      
      final buffer = bytes.buffer;
      return base64.encode(Uint8List.view(buffer));
    }

    throw Exception("Can't get the image: ${response.body}");
  }

  Future<List<User>> getAvailableCaptains(String authorizationHeader) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/available_captains',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    final List<User> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> httpUsers = jsonDecode(response.body) as List<dynamic>;

      for (final user in httpUsers) {
        result.add(User.fromMap(user as Map<String, dynamic>));
      }
    }
    else { 
      throw Exception("Can't get the available captains: ${response.body}");
    }

    return result;
  }

  // Create
  Future<String> createTeam(String authorizationHeader, Team team) async {
    final http.Response response = await _client.post(
      '$serviceBaseUrl/add',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: team.toJson(),
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as Map<String, dynamic>)["id"] as String;
    }
    
    throw Exception("Impossible to create team: ${response.body}");
  }

  // Update
  Future updateTeam(String authorizationHeader, Team team) async {
    final http.Response response = await _client.put(
      '$serviceBaseUrl/admin_update',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: team.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to update team: ${response.body}");
    }    

    if (team.imageId == "modified") {
      team.imageId = null;
    }
  }

  Future addUserToTeam(String authorizationHeader, String teamId, String userId) async {
    final http.Response response = await _client.put(
      '$serviceBaseUrl/$teamId/add_user',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: jsonEncode(<String, String>{
        "id": userId
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to validate challenge : ${response.body}");
    }
  }

  // delete
  Future removeUserFromTeam(String authorizationHeader, String teamId, String userId) async {
    final http.Response response = await _client.put(
      '$serviceBaseUrl/$teamId/remove_user',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: jsonEncode(<String, String>{
        "id": userId
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to validate challenge : ${response.body}");
    }
  }

  Future deleteTeam(String authorizationHeader, String teamId) async {
    final http.Response response = await _client.delete(
      '$serviceBaseUrl/delete/$teamId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      }
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to delete team: ${response.body}");
    }    

    await _deleteCache(teamId);
  }
  
  Future<String> _getCachedImage(String teamId, String imageId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getString("teams_${teamId}_imageId") == imageId) {
      return preferences.getString("teams_${teamId}_cachedImage");
    }

    return null;
  }

  Future _cacheImage(String teamId, String imageId, String image) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("teams_${teamId}_imageId", imageId);
    preferences.setString("teams_${teamId}_cachedImage", image);
  }

  Future _deleteCache(String teamId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("teams_${teamId}_imageId", null);
    preferences.setString("teams_${teamId}_cachedImage", null);
  }
}