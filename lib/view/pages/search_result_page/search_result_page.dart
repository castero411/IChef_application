import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:i_chef_application/functions/api_service.dart';
import 'package:i_chef_application/model/saved_meal.dart';
import 'package:i_chef_application/provider/saved_meals_providedr.dart';
import 'package:i_chef_application/view/pages/recipe_page/recipe_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Search page that queries the Express backend (/ai/recommendations)
/// and shows a scrollable list of matching recipes with a favourite‑toggle.
class SearchResultsPage extends ConsumerStatefulWidget {
  const SearchResultsPage({super.key, required this.query});

  final String query;

  @override
  ConsumerState<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends ConsumerState<SearchResultsPage> {
  final _controller = TextEditingController();
  late Future<List<RecipeMatch>> _future;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query.trim();
    _controller.text = _currentQuery;
    _future = _search(_currentQuery);
    _saveToHistory(_currentQuery);
  }

  Future<List<RecipeMatch>> _search(String q) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return ChefApiService().getRecipeRecommendations(
      userId: userId,
      ingredients: q,
    );
  }

  Future<void> _handleSearch(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _currentQuery = trimmed;
      _future = _search(trimmed);
    });

    await _saveToHistory(trimmed);
  }

  Future<void> _saveToHistory(String query) async {
    // optional UX improvement — keeps last 10 searches
    final prefs = await SharedPreferences.getInstance();
    var history = prefs.getStringList('searchHistory') ?? [];

    history.remove(query);
    history.insert(0, query);
    if (history.length > 10) history = history.sublist(0, 10);

    await prefs.setStringList('searchHistory', history);
  }

  @override
  Widget build(BuildContext context) {
    final savedMeals = ref.watch(savedMealsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Search ingredients…',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: _handleSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _handleSearch(_controller.text),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: FutureBuilder<List<RecipeMatch>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final recipes = snapshot.data ?? [];
          if (recipes.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          return ListView.separated(
            itemCount: recipes.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final r = recipes[i];
              final isFav = savedMeals.any((m) => m.name == r.title);

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    r.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(r.title),
                subtitle: Text('${r.calories} kcal'),
                trailing: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : Colors.grey,
                  ),
                  onPressed: () {
                    final meal = SavedMeal(
                      name: r.title,
                      image: r.image,
                      calories: r.calories.toString(),
                    );
                    ref.read(savedMealsProvider.notifier).toggle(meal);
                  },
                ),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipePage(recipeTitle: r.title),
                      ),
                    ),
              );
            },
          );
        },
      ),
    );
  }
}
