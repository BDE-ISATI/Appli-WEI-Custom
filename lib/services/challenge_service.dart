import 'dart:convert';
import 'dart:io';

import 'package:appli_wei_custom/models/challenge.dart';
import 'package:appli_wei_custom/models/waiting_challenges.dart';
import 'package:http/http.dart' as http;

class ChallengeService {
  ChallengeService._privateConstructor();

  final String serviceBaseUrl = "https://192.168.1.38:45455/api/challenges";

  static final ChallengeService instance = ChallengeService._privateConstructor();

  final _client = http.Client();

  Future<List<Challenge>> challengesForUser(String authorizationHeader, String userId) async {
    final http.Response response = await _client.get(
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
      throw Exception("Can't get the challenges for user: ${response.body}");
    }

    return result;
  }

  Future<List<Challenge>> doneChallengesForUser(String authorizationHeader, String userId) async {
    final http.Response response = await _client.get(
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
      throw Exception("Can't get the done challenge for user: ${response.body}");
    }

    return result;
  }

  Future<List<WaitingChallenge>> waitingChallenges(String authorizationHeader) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/waiting',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    final List<WaitingChallenge> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> httpChallenges = jsonDecode(response.body) as List<dynamic>;

      for (final challenge in httpChallenges) {
        result.add(WaitingChallenge.fromMap(challenge as Map<String, dynamic>));
      }
    }
    else { 
      throw Exception("Can't get the waiting challenges: ${response.body}");
    }

    return result;
  }
  
  Future<String> proofImage(String authorizationHeader, String challengeId, String userId) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/proof/$challengeId/$userId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as Map<String, dynamic>)["image"] as String;
    }
    
    throw Exception("Can't get the proof: ${response.body}");
  }

  Future submitChallenge(String authorizationHeader, String challengeId, String proofImage) async {
    final http.Response response = await _client.post(
      '$serviceBaseUrl/submit',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: jsonEncode(<String, String>{
        "challengeId": challengeId,
        "proofImage": proofImage,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to login : ${response.body}");
    }
  }
}