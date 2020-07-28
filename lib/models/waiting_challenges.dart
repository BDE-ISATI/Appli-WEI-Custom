class WaitingChallenge {
  String id;

  String playerId;
  String playerName;

  String image = "";
  String imageId;

  String name;
  String description;

  final bool isForTeam;

  WaitingChallenge.fromMap(Map<String, dynamic> map, {this.isForTeam = false}) :
    id = map['id'] as String,
    imageId = map['imageId'] as String,
    playerId = map['validatorId'] as String,
    playerName = map['validatorName'] as String,
    name = map['name'] as String,
    description = map['description'] as String;
}