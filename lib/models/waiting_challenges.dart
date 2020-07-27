class WaitingChallenge {
  String id;

  String playerId;
  String playerName;

  String name;
  String description;

  String imageBase64;

  final bool isForTeam;

  WaitingChallenge.fromMap(Map<String, dynamic> map, {this.isForTeam = false}) :
    id = map['id'] as String,
    playerId = map['validatorId'] as String,
    playerName = map['validatorName'] as String,
    name = map['name'] as String,
    description = map['description'] as String,
    imageBase64 = map['image'] as String;
}