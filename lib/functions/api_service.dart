import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:i_chef_application/model/recipe_details.dart';

/// Updated for July 2025 backend spec.
/// * Adds user_id to recommendation & details requests.
/// * Chatbot path is now `/chatbot` (no `/message`).
/// * Chatbot payload expects `messages` list.
class ChefApiService {
  ChefApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl =
      'https://us-central1-chef-intelligence-app.cloudfunctions.net/api';

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$_baseUrl$path').replace(queryParameters: query);

  Future<RecipeDetails> fetchRecipeDetailsByTitle({
    required String userId,
    required String title,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ai/details'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'title': title}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Details error ${response.statusCode}: ${response.reasonPhrase}\n${response.body}',
      );
    }

    return RecipeDetails.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // ---------------------------------------------------------------- AI ----
  Future<List<RecipeMatch>> getRecipeRecommendations({
    required String userId,
    required String ingredients,
    String? cuisine,
  }) async {
    final res = await _client.post(
      _uri('/ai/recommendations'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'user_id': userId,
        'ingredients': ingredients,
        if (cuisine != null && cuisine.isNotEmpty) 'cuisine': cuisine,
      }),
    );
    _check(res);
    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    return (decoded['matches'] as List<dynamic>)
        .map((e) => RecipeMatch.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<RecipeDetails> getRecipeDetails({
    required String userId,
    required String ingredients,
    String? cuisine,
    int recipeIndex = 0,
  }) async {
    final res = await _client.post(
      _uri('/ai/details'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'user_id': userId,
        'ingredients': ingredients,
        if (cuisine != null && cuisine.isNotEmpty) 'cuisine': cuisine,
        'recipe_index': recipeIndex,
      }),
    );
    _check(res);
    return RecipeDetails.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  // --------------------------------------------------- Chatbot (new path) --
  Future<String> sendMessageToBot(String userMessage) async {
    final res = await _client.post(
      _uri('/chatbot'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'messages': [
          {'role': 'user', 'content': userMessage},
        ],
      }),
    );
    _check(res);
    return (jsonDecode(res.body) as Map<String, dynamic>)['reply'] as String;
  }

  // ------------------------------------------------ Meal‑planner CRUD ----
  Future<MealPlanResponse> saveMealPlan({
    required String userId,
    required DateTime date,
    required Meal meal,
    String mealType = 'Dinner',
  }) async {
    final res = await _client.post(
      _uri('/meal/plan'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'user_id': userId,
        'date': date.toIso8601String().split('T').first,
        'meal_type': mealType,
        'title': meal.title,
        'recipe': {'ingredients': meal.ingredients, 'steps': meal.steps},
      }),
    );
    _check(res);
    return MealPlanResponse.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }

  Future<void> updateMealPlan({
    required String mealId,
    required Meal meal,
    String? mealType,
  }) async {
    final res = await _client.put(
      _uri('/meal/plan/$mealId'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'title': meal.title,
        if (mealType != null) 'meal_type': mealType,
        'recipe': {'ingredients': meal.ingredients, 'steps': meal.steps},
      }),
    );
    _check(res);
  }

  Future<void> deleteMeal(String mealId) async {
    final res = await _client.delete(_uri('/meal/plan/$mealId'));
    _check(res);
  }

  Future<List<Meal>> getMealsForUser(String userId) async {
    final res = await _client.get(_uri('/meal/plan', {'user_id': userId}));
    _check(res);
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Meal.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ------------------------------------------------- helpers --------------
  Map<String, String> get _jsonHeaders => {'Content-Type': 'application/json'};

  void _check(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ApiException(res.statusCode, res.body);
    }
  }
}

// ---------------- models & exceptions (unchanged except Meal) ------------
class ApiException implements Exception {
  const ApiException(this.statusCode, this.body);
  final int statusCode;
  final String body;
  @override
  String toString() => 'ApiException($statusCode): $body';
}

class RecipeMatch {
  const RecipeMatch({
    required this.id,
    required this.title,
    required this.image,
    required this.calories,
  });

  final int id;
  final String title;
  final String image;
  final int calories;

  factory RecipeMatch.fromJson(Map<String, dynamic> json) => RecipeMatch(
    id: json['id'] as int,
    title: json['title'] as String,
    image: json['image'] as String,
    calories: json['calories'] as int,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
    'calories': calories,
  };
}

class Meal {
  const Meal({
    required this.title,
    required this.ingredients,
    required this.steps,
  });

  final String title;
  final List<String> ingredients;
  final String steps;

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    title: json['title'] as String,
    ingredients:
        (json['ingredients'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
    steps: json['steps'] as String,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'ingredients': ingredients,
    'steps': steps,
  };
}

class MealPlanResponse {
  const MealPlanResponse({required this.status, required this.mealId});

  final String status;
  final String mealId;

  factory MealPlanResponse.fromJson(Map<String, dynamic> json) =>
      MealPlanResponse(
        status: json['status'] as String,
        mealId: json['meal_id'] as String,
      );
}
