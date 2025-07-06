// lib/provider/recommendations_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:i_chef_application/functions/api_service.dart';
import 'package:i_chef_application/provider/api_provider.dart';

final recipeRecommendationsProvider = FutureProvider<List<RecipeMatch>>((
  ref,
) async {
  final api = ref.read(chefApiServiceProvider);

  // signed‑in user’s UID or a fallback
  final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

  const ingredients = 'Chicken, Beef, Tomatoes';

  return api.getRecipeRecommendations(userId: uid, ingredients: ingredients);
});
