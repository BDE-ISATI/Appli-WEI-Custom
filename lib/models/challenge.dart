class Challenge {
  String id;

  String name;
  String description;
  int value;

  String imageBase64;

  bool isWaitingValidation;
  int numberLeft;

  final bool isForTeam;

  Challenge.fromMap(Map<String, dynamic> map, {this.isForTeam = false}) :
    id = map['id'] as String,
    name = map['name'] as String,
    description = map['description'] as String,
    value = map['value'] as int,
    numberLeft = map['numberLeft'] as int,
    imageBase64 = map['image'] as String {
      if (!isForTeam) {
        isWaitingValidation = map['waitingValidation'] as bool;
      }
    }
}