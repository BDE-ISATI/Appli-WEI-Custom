import 'dart:convert';

class Team {
  String id;

  String name;
  String captainName;
  int score;

  List<String> members;

  Team.fromMap(Map<String, dynamic> map) :
    id = map['id'] as String,
    name = map['name'] as String,
    captainName = map['captainName'] as String,
    score = map['score'] as int,
    members = List<String>.from(map['members'] as List<dynamic>);
}