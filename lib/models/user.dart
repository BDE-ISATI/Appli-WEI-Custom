class User {
  String id;

  String firstName;
  String lastName;
  String username;

  String teamName;
  int score;

  String email;
  String passwordHash;

  User.fromMap(Map<String, dynamic> map) :
    id = map['id'] as String,
    firstName = map['firstName'] as String,
    lastName = map['lastName'] as String,
    username = map['username'] as String,
    score = map['score'] as int,
    email = map['email'] as String,
    passwordHash = map['passwordHash'] as String;
}