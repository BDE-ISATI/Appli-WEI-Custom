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
      
    throw Exception("Can't get the team for user : ${response.body}");
  }
  
}