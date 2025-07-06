class RecipeDetails {
  const RecipeDetails({
    required this.title,
    required this.image,
    required this.calories,
    required this.ingredients,
    required this.preparationSteps,
  });

  final String title;
  final String image;
  final int calories;
  final List<String> ingredients;
  final String preparationSteps;

  factory RecipeDetails.fromJson(Map<String, dynamic> json) => RecipeDetails(
    title: json['title'] as String,
    image: json['image'] as String,
    calories: json['calories'] as int,
    ingredients:
        (json['ingredients'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
    preparationSteps: json['preparation_steps'] as String,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'image': image,
    'calories': calories,
    'ingredients': ingredients,
    'preparation_steps': preparationSteps,
  };
}
