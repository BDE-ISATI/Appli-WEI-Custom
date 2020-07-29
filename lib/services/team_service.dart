import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/models/team.dart';
import 'package:http/http.dart' as http;

class TeamService {
  TeamService._privateConstructor();

  final String serviceBaseUrl = "https://192.168.1.38:45455/api/teams";

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

  // Update
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
  
}