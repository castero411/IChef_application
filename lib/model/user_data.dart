class UserData {
  String name;
  String email;
  String username;
  String country;
  List<String> diet;
  List<String> allergies;
  List<String> intolerances;
  int age;
  String gender;

  UserData({
    required this.name,
    required this.email,
    required this.username,
    required this.country,
    required this.diet,
    required this.allergies,
    required this.intolerances,
    required this.age,
    required this.gender,
  });

  factory UserData.fromMap(Map<String, dynamic> map) => UserData(
    name: map['name'] ?? '',
    email: map['email'] ?? '',
    username: map['username'] ?? '',
    country: map['country'] ?? '',
    diet: List<String>.from(map['diet'] ?? []),
    allergies: List<String>.from(map['allergies'] ?? []),
    intolerances: List<String>.from(map['intolerances'] ?? []),
    age: map['age'] ?? 0,
    gender: map['gender'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'username': username,
    'country': country,
    'diet': diet,
    'allergies': allergies,
    'intolerances': intolerances,
    'age': age,
    'gender': gender,
  };

  UserData copyWith({
    String? name,
    String? email,
    String? username,
    String? country,
    List<String>? diet,
    List<String>? allergies,
    List<String>? intolerances,
    int? age,
    String? gender,
  }) {
    return UserData(
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      country: country ?? this.country,
      diet: diet ?? this.diet,
      allergies: allergies ?? this.allergies,
      intolerances: intolerances ?? this.intolerances,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }
}
