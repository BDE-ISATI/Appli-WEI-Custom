import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/models/team.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class TeamService {
  TeamService._privateConstructor();

  final String serviceBaseUrl = "https://192.168.1.38:45455/api/teams";

  static final TeamService instance = TeamService._privateConstructor();

  // TODO: remove this when API will be released
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  http.Client localApiClient() {
    final ioClient = HttpClient()..badCertificateCallback = _certificateCheck;

    return IOClient(ioClient);
  }

  Future<Team> teamForUser(String authorizationHeader, String userId) async {
    final http.Response response = await localApiClient().get(
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