class SavedMeal {
  final String name;
  final String image;
  final String calories;

  SavedMeal({required this.name, required this.image, required this.calories});

  // --- JSON helpers for sqflite ---
  factory SavedMeal.fromJson(Map<String, dynamic> json) => SavedMeal(
    name: json['name'] as String,
    image: json['image'] as String,
    calories: json['calories'] as String,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'calories': calories,
  };
}
