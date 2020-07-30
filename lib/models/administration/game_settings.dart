class GameSettings {
  bool isUsersRankingVisible = false;
  bool isTeamsRankingVisible = false;

  GameSettings.fromMap(Map<String, dynamic> map) :
    isUsersRankingVisible = map['isUsersRankingVisible'] as bool,
    isTeamsRankingVisible = map['isTeamsRankingVisible'] as bool;
}