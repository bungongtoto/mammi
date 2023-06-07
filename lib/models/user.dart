class UserApp {
  final String uid; /// Unique identifier of the user

  UserApp({required this.uid});
}

class UserData {
  final String uid; /// Unique identifier of the user
  final String name; /// Name of the user
  final String sugars; /// Preference for sugars
  final int strength; /// Strength preference

  UserData({
    required this.uid,
    required this.sugars,
    required this.strength,
    required this.name,
  });
}
