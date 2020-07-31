import 'dart:convert';

import 'package:flutter/material.dart';

class AdminChallenge {
  String id;

  String name;
  String description;
  int value;
  int numberOfRepetitions;

  MemoryImage image;
  String imageId;

  bool isVisible;
  bool isForTeam;

  AdminChallenge() :
    name = "",
    description = "",
    value = 0,
    numberOfRepetitions = 0,
    isVisible = false,
    isForTeam = false;

  AdminChallenge.fromMap(Map<String, dynamic> map) :
    id = map['id'] as String,
    imageId = map['imageId'] as String,
    name = map['name'] as String,
    description = map['description'] as String,
    value = map['value'] as int,
    numberOfRepetitions = map['numberOfRepetitions'] as int,
    isForTeam = map['isForTeam'] as bool,
    isVisible = map['isVisible'] as bool;

  String toJson() => jsonEncode(<String, dynamic>{
    "id": id,
    "name": name,
    "description": description,
    "imageId": imageId,
    "image": base64Encode(image.bytes),
    "value": value,
    "numberOfRepetitions": numberOfRepetitions,
    "isForTeam": isForTeam,
    "isVisible": isVisible
  });
}