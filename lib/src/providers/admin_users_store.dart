import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/services/team_service.dart';
import 'package:appli_wei_custom/services/user_service.dart';
import 'package:flutter/material.dart';

class AdminUsersStore with ChangeNotifier {
  AdminUsersStore({@required this.authorizationHeader});

  final List<User> _users = [];
  final Map<String, String> _originalTeams = {};

  final String authorizationHeader;

  Future<List<User>> getUsers({bool forceUpdate = false}) async {
    if (_users.isEmpty || forceUpdate) {
      _users.clear();
      _originalTeams.clear();
      try {
        _users.addAll(await UserService.instance.getUsers(authorizationHeader));

        for (final user in _users) {
          _originalTeams[user.id] = user.teamId;
        }
      }
      catch (e) {
        throw Exception("Impossible d'obtenir les utilisateurs : ${e.toString()}");
      }
    }

    return _users;
  }

  Future<String> updateUser(User toUpdate) async {
    try {
      if (toUpdate.profilePictureId == null || toUpdate.profilePictureId.isNotEmpty) {
        toUpdate.profilePicture = "";
      }
      await UserService.instance.updateUser(authorizationHeader, toUpdate);
      
      if (toUpdate.teamId != _originalTeams[toUpdate.id]) {
        if (toUpdate.teamId == null) {
          await TeamService.instance.removeUserFromTeam(authorizationHeader, _originalTeams[toUpdate.id], toUpdate.id);
          _originalTeams[toUpdate.id] = null;
        }
        else {
          await TeamService.instance.addUserToTeam(authorizationHeader, toUpdate.teamId, toUpdate.id);
          _originalTeams[toUpdate.id] = toUpdate.teamId; 
        }
      }
      // We need to notify listeners to update images
      notifyListeners();

      return "";
    }
    catch (e) {
      return "Erreur : ${e.toString()}";
    }
  }

  Future<String> deleteUser(User toDelete) async {
    try {
      UserService.instance.deleteUser(authorizationHeader, toDelete.id);
      
      _users.remove(toDelete);
      notifyListeners();
      
      return "";
    }
    catch (e) {
      return "Erreur : ${e.toString()}";
    }
  }

  void refreshData() {
    _users.clear();
    notifyListeners();
  }

}