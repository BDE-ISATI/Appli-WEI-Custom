import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/models/administration/game_settings.dart';
import 'package:http/http.dart' as http;

class GameSettingsService {
  GameSettingsService._privateConstructor();

  final String serviceBaseUrl = "https://192.168.1.38:45455/api/settings";

  static final GameSettingsService instance = GameSettingsService._privateConstructor();

  final _client = http.Client();

  // Get
  Future<GameSettings> getSettings(String authorizationHeader) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

   if (response.statusCode == 200) {
      return GameSettings.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw Exception("Can't get the settings: ${response.body}");
  }

  // Update
  Future toggleUsersRankingVisibility(String authorizationHeader) async {
    final http.Response response = await _client.put(
      '$serviceBaseUrl/admin_update/toggle_users_ranking_visibility',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      }
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to update users ranking visibility: ${response.body}");
    } 
  }

  Future toggleTeamsRankingVisibility(String authorizationHeader) async {
    final http.Response response = await _client.put(
      '$serviceBaseUrl/admin_update/toggle_teams_ranking_visibility',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      }
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to update teams ranking visibility: ${response.body}");
    } 
  }
}