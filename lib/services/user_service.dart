import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  UserService._privateConstructor();

  final String serviceBaseUrl = "https://192.168.1.38:45455/api/users";

  static final UserService instance = UserService._privateConstructor();

  final _client = http.Client();

  // Get
  Future<String> getProfilePicture(String authorizationHeader, String userId) async {
    final http.Response response = await _client.get(
      '$serviceBaseUrl/profile_picture/$userId',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorizationHeader
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as Map<String, dynamic>)["profilePicture"] as String;
    }
    else if  (response.statusCode == 204) {
      final ByteData bytes = await rootBundle.load('assets/logo.jpg');
      
      final buffer = bytes.buffer;
      return base64.encode(Uint8List.view(buffer));
    }
    
    throw Exception("Can't get the profile picture: ${response.body}");
  }

  // Update
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
  
}