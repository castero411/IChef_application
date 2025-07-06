// provider/meal_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chef_application/database/meal_db.dart';
import '../model/saved_meal.dart';

/// Shared database instance
final mealDbProvider = Provider<MealDatabase>((_) => MealDatabase());

// ─────────────────── SAVED MEALS ────────────────────────────────
class SavedMealsNotifier extends StateNotifier<List<SavedMeal>> {
  SavedMealsNotifier(this._db) : super([]) {
    _load();
  }

  final MealDatabase _db;

  Future<void> _load() async => state = await _db.getAllSaved();

  Future<void> toggle(SavedMeal meal) async {
    if (await _db.savedExists(meal.name)) {
      await _db.removeSaved(meal.name);
    } else {
      await _db.addSaved(meal);
    }
    state = await _db.getAllSaved();
  }

  bool contains(String name) => state.any((m) => m.name == name);
}

final savedMealsProvider =
    StateNotifierProvider<SavedMealsNotifier, List<SavedMeal>>(
      (ref) => SavedMealsNotifier(ref.read(mealDbProvider)),
    );

// ─────────────────── RECENTLY VIEWED (history) ──────────────────
class RecentMealsNotifier extends StateNotifier<List<SavedMeal>> {
  RecentMealsNotifier(this._db) : super([]) {
    _load();
  }

  final MealDatabase _db;

  Future<void> _load() async => state = await _db.getRecent();

  Future<void> add(SavedMeal meal) async {
    await _db.upsertRecent(meal); // keeps only 10 newest
    state = await _db.getRecent();
  }

  bool contains(String name) => state.any((m) => m.name == name);

  Future<void> clear() async {
    await _db.clearRecent();
    state = [];
  }
}

final recentMealsProvider =
    StateNotifierProvider<RecentMealsNotifier, List<SavedMeal>>(
      (ref) => RecentMealsNotifier(ref.read(mealDbProvider)),
    );
