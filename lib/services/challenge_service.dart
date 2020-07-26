import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/models/challenge.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ChallengeService {
  ChallengeService._privateConstructor();

  final String serviceBaseUrl = "https://192.168.1.38:45455/api/challenges";

  static final ChallengeService instance = ChallengeService._privateConstructor();

  // TODO: remove this when API will be released
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  http.Client localApiClient() {
    final ioClient = HttpClient()..badCertificateCallback = _certificateCheck;

    return IOClient(ioClient);
  }

  Future<List<Challenge>> challengesForUser(String authorizationHeader, String userId) async {
    final http.Response response = await localApiClient().get(
      '$serviceBaseUrl/individual/$userId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    final List<Challenge> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> httpChallenges = jsonDecode(response.body) as List<dynamic>;

      for (final challenge in httpChallenges) {
        result.add(Challenge.fromMap(challenge as Map<String, dynamic>));
      }
    }
    else { 
      throw Exception("Can't get the challenges for user : ${response.body}");
    }

    return result;
  }

    Future<List<Challenge>> doneChallengesForUser(String authorizationHeader, String userId) async {
    final http.Response response = await localApiClient().get(
      '$serviceBaseUrl/done/$userId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    final List<Challenge> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> httpChallenges = jsonDecode(response.body) as List<dynamic>;

      for (final challenge in httpChallenges) {
        result.add(Challenge.fromMap(challenge as Map<String, dynamic>));
      }
    }
    else { 
      throw Exception("Can't get the done challenge for user : ${response.body}");
    }

    return result;
  }
  
}