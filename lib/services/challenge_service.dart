import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:appli_wei_custom/models/administration/admin_challenge.dart';
import 'package:appli_wei_custom/models/challenge.dart';
import 'package:appli_wei_custom/models/waiting_challenges.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeService {
  ChallengeService._privateConstructor();

  // final String serviceBaseUrl = "https://192.168.0.18:45455/api/challenges";
  final String serviceBaseUrl = "https://appli.wei.isati.org/api/challenges";

  static final ChallengeService instance = ChallengeService._privateConstructor();

  final _client = http.Client();

  // Get
  Future<List<AdminChallenge>> getChallengesForAdministration(String authorizationHeader) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    final List<AdminChallenge> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> httpChallenges = jsonDecode(response.body) as List<dynamic>;

      for (final challenge in httpChallenges) {
        result.add(AdminChallenge.fromMap(challenge as Map<String, dynamic>));
      }
    }
    else { 
      throw Exception("Can't get the challenges: ${response.body}");
    }

    return result;
  }

  Future<List<Challenge>> getChallengesForUser(String authorizationHeader, String userId) async {
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

  Future<List<Challenge>> getChallengesForTeam(String authorizationHeader, String teamId) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/team/$teamId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    final List<Challenge> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> httpChallenges = jsonDecode(response.body) as List<dynamic>;

      for (final challenge in httpChallenges) {
        result.add(Challenge.fromMap(challenge as Map<String, dynamic>, isForTeam: true),);
      }
    }
    else { 
      throw Exception("Can't get the challenges for team: ${response.body}");
    }

    return result;
  }

  Future<List<Challenge>> getDoneChallengesForUser(String authorizationHeader, String userId) async {
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

  Future<List<Challenge>> getDoneChallengesForTeam(String authorizationHeader, String teamId) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/done/team/$teamId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    final List<Challenge> result = [];

    if (response.statusCode == 200) {
      final List<dynamic> httpChallenges = jsonDecode(response.body) as List<dynamic>;

      for (final challenge in httpChallenges) {
        result.add(Challenge.fromMap(challenge as Map<String, dynamic>, isForTeam: true));
      }
    }
    else { 
      throw Exception("Can't get the done challenge for team: ${response.body}");
    }

    return result;
  }

  Future<List<WaitingChallenge>> getWaitingChallenges(String authorizationHeader) async {
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

  Future<String> getChallengeImage(String authorizationHeader, String challengeId, String imageId) async {
    final String cachedImage = await _getCachedImage(challengeId, imageId);

    if (cachedImage != null) {
      return cachedImage;
    }

    final http.Response response = await _client.get(
      '$serviceBaseUrl/$challengeId/image',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    if (response.statusCode == 200) {
      final String challengeImage = (jsonDecode(response.body) as Map<String, dynamic>)["image"] as String;

      await _cacheImage(challengeId, imageId, challengeImage);
      return challengeImage;
    }
    else if  (response.statusCode == 204) {
      final ByteData bytes = await rootBundle.load('assets/logo.jpg');
      
      final buffer = bytes.buffer;
      return base64.encode(Uint8List.view(buffer));
    }

    
    throw Exception("Can't get the image: ${response.body}");
  }
  
  Future<String> getProofImage(String authorizationHeader, String challengeId, String userId) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/$challengeId/proof/$userId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as Map<String, dynamic>)["image"] as String;
    }
    
    throw Exception("Can't get the proof: ${response.body}");
  }

  // Post
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
      throw Exception("Impossible to submit challenge: ${response.body}");
    }
  }

  Future validateChallengeForUser(String authorizationHeader, String challengeId, String userId) async {
    final http.Response response = await _client.post(
      '$serviceBaseUrl/validate_for_user',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: jsonEncode(<String, String>{
        "challengeId": challengeId,
        "validatorId": userId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to validate challenge : ${response.body}");
    }
  }

  Future validateChallengeForTeam(String authorizationHeader, String challengeId, String teamId) async {
    final http.Response response = await _client.post(
      '$serviceBaseUrl/validate_for_team',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: jsonEncode(<String, String>{
        "challengeId": challengeId,
        "validatorId": teamId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to validate challenge : ${response.body}");
    }
  }

  Future<String> createChallenge(String authorizationHeader, AdminChallenge challenge) async {
    final http.Response response = await _client.post(
      '$serviceBaseUrl/add',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: challenge.toJson(),
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as Map<String, dynamic>)["id"] as String;
    }
    
    throw Exception("Impossible to create challenge: ${response.body}");
  }

  // Update
  Future updateChallenge(String authorizationHeader, AdminChallenge challenge) async {
    final http.Response response = await _client.put(
      '$serviceBaseUrl/admin_update',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: authorizationHeader
      },
      body: challenge.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to update challenge: ${response.body}");
    }    

    if (challenge.imageId == "modified") {
      challenge.imageId = null;
    }
  }

  // Delete
  Future deleteChallenge(String authorizationHeader, String challengeId) async {
    final http.Response response = await _client.delete(
      '$serviceBaseUrl/delete/$challengeId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      }
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible to delete challenge: ${response.body}");
    }    

    await _deleteCache(challengeId);
  }

  Future<String> _getCachedImage(String challengeId, String imageId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getString("${challengeId}_imageId") == imageId) {
      return preferences.getString("${challengeId}_cachedImage");
    }

    return null;
  }

  Future _cacheImage(String challengeId, String imageId, String image) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("${challengeId}_imageId", imageId);
    preferences.setString("${challengeId}_cachedImage", image);
  }

  Future _deleteCache(String challengeId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("${challengeId}_imageId", null);
    preferences.setString("${challengeId}_cachedImage", null);
  }
}