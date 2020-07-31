import 'dart:convert';
import 'dart:typed_data';

import 'package:appli_wei_custom/models/team.dart';
import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/team_service.dart';
import 'package:appli_wei_custom/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminTeamsStore with ChangeNotifier {
  AdminTeamsStore({@required this.authorizationHeader});

  final List<Team> _teams = [];

  final String authorizationHeader;

  Future<List<Team>> getTeams({bool forceUpdate = false}) async {
    if (_teams.isEmpty || forceUpdate) {
      _teams.clear();
      try {
        _teams.addAll(await TeamService.instance.getTeams(authorizationHeader));
      }
      catch (e) {
        throw Exception("Impossible d'obtenir les équipes : ${e.toString()}");
      }
    }

    return _teams;
  }

  Future<String> createTeam(Team toCreate) async {
    if (toCreate.image == null) {
      final ByteData bytes = await rootBundle.load('assets/logo.jpg');
      
      final buffer = bytes.buffer;
      toCreate.image = MemoryImage(Uint8List.view(buffer));
    }

    try {
      toCreate.id = await TeamService.instance.createTeam(authorizationHeader, toCreate);

      final User captain = await UserService.instance.getUser(authorizationHeader, toCreate.captainId);
      toCreate.captainName = "${captain.firstName} ${captain.lastName}"; 
      
      _teams.add(toCreate);
      notifyListeners();
      
      return "";
    }
    catch (e) {
      return "Erreur : ${e.toString()}";
    }
  }

  Future<String> updateTeam(Team toUpdate) async {
    try {
      final MemoryImage image = toUpdate.image;

      if (toUpdate.imageId != "modified") {
        toUpdate.image = null;
      }

      await TeamService.instance.updateTeam(authorizationHeader, toUpdate);

      toUpdate.image = image;      
      
      final User captain = await UserService.instance.getUser(authorizationHeader, toUpdate.captainId);
      toUpdate.captainName = "${captain.firstName} ${captain.lastName}"; 
      

      // We need to notify listeners to update images
      notifyListeners();

      return "";
    }
    catch (e) {
      return "Erreur : ${e.toString()}";
    }
  }

  Future<String> deleteTeam(Team toDelete) async {
    try {
      TeamService.instance.deleteTeam(authorizationHeader, toDelete.id);
      
      _teams.remove(toDelete);
      notifyListeners();
      
      return "";
    }
    catch (e) {
      return "Erreur : ${e.toString()}";
    }
  }

  void refreshData() {
    _teams.clear();
    notifyListeners();
  }

}