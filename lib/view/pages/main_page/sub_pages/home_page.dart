import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/model/saved_meal.dart';
import 'package:i_chef_application/provider/recipe_recomendation.dart';
import 'package:i_chef_application/provider/saved_meals_providedr.dart';
import 'package:i_chef_application/provider/user_data_provider.dart';
import 'package:i_chef_application/view/commonWidgets/home_item_widget.dart';
import 'package:i_chef_application/view/commonWidgets/ingredient_widget.dart';
import 'package:i_chef_application/view/pages/diet_plan_page/diet_plan_page.dart';
import 'package:i_chef_application/view/pages/recipe_page/recipe_page.dart';
import 'package:i_chef_application/view/text_styles.dart';

/// Home / dashboard page with **favourite‑toggle** support on every card.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(userDataProvider).name;

    // Needed for bottom‑nav currentIndex (if you use riverpod for nav state)
    ref.read(currentIndex.notifier).state = 0;

    final Map<String, String> popularIngredients = {
      'Chicken':
          'https://www.themealdb.com/images/ingredients/chicken-medium.png',
      'Beef': 'https://www.themealdb.com/images/ingredients/beef-medium.png',
      'Aubergine':
          'https://www.themealdb.com/images/ingredients/aubergine-medium.png',
      'Tomatoes':
          'https://www.themealdb.com/images/ingredients/tomato-medium.png',
      'Onion': 'https://www.themealdb.com/images/ingredients/onion-medium.png',
      'Eggs': 'https://www.themealdb.com/images/ingredients/egg-medium.png',
    };

    final ingredientEntries = popularIngredients.entries.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back 👋', style: grey10),
                Text(username, style: secondarytitle25.copyWith(fontSize: 24)),
              ],
            ),
            InkWell(
              onTap: () => Navigator.pushNamed(context, 'settings'),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: secondaryColor, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.person_outlined, size: 28),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(25),

            // ── Popular ingredients ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionTitle('Popular Ingredients'),
            ),
            const Gap(10),
            SizedBox(
              height: 100,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: ingredientEntries.length,
                separatorBuilder: (_, __) => const Gap(10),
                itemBuilder: (_, i) {
                  final entry = ingredientEntries[i];
                  return IngredientWidget(
                    itemImage: NetworkImage(entry.value),
                    itemName: entry.key,
                  );
                },
              ),
            ),

            const Gap(30),

            // ── Recommended for you ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionTitle('Recommended for You'),
            ),
            const Gap(12),
            Consumer(
              builder: (_, ref, __) {
                final asyncMatches = ref.watch(recipeRecommendationsProvider);
                final savedMeals = ref.watch(savedMealsProvider);

                return asyncMatches.when(
                  loading:
                      () => const SizedBox(
                        height: 175,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  error:
                      (err, __) => SizedBox(
                        height: 175,
                        child: Center(child: Text('Error: $err')),
                      ),
                  data: (matches) {
                    if (matches.isEmpty) {
                      return const SizedBox(
                        height: 175,
                        child: Center(child: Text('No matches today')),
                      );
                    }

                    final items =
                        matches.map((m) {
                          final isFavourite = savedMeals.any(
                            (meal) => meal.name == m.title,
                          );

                          return HomeItemWidget(
                            image: NetworkImage(m.image),
                            itemName: m.title,
                            time: '${m.calories} kcal',
                            isFavourite: isFavourite,
                            onFavourite: () {
                              final meal = SavedMeal(
                                name: m.title,
                                image: m.image,
                                calories: m.calories.toString(),
                              );
                              ref
                                  .read(savedMealsProvider.notifier)
                                  .toggle(meal);
                            },
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => RecipePage(recipeTitle: m.title),
                                  ),
                                ),
                          );
                        }).toList();

                    return _horizontalCardScroller(items);
                  },
                );
              },
            ),

            const Gap(30),

            // ── Recently viewed ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionTitle('Recently Viewed Meals'),
            ),
            const Gap(12),
            Consumer(
              builder: (_, ref, __) {
                final recent = ref.watch(recentMealsProvider);
                final savedMeals = ref.watch(savedMealsProvider);

                if (recent.isEmpty) {
                  return const SizedBox(
                    height: 175,
                    child: Center(child: Text('No recently viewed meals')),
                  );
                }

                final items =
                    recent.reversed.map((m) {
                      final isFavourite = savedMeals.any(
                        (meal) => meal.name == m.name,
                      );

                      return HomeItemWidget(
                        image: NetworkImage(m.image),
                        itemName: m.name,
                        time: '${m.calories} kcal',
                        isFavourite: isFavourite,
                        onFavourite:
                            () =>
                                ref.read(savedMealsProvider.notifier).toggle(m),
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipePage(recipeTitle: m.name),
                              ),
                            ),
                      );
                    }).toList();

                return _horizontalCardScroller(items);
              },
            ),

            const Gap(30),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────── helpers ─────────────────────────────
  Widget _sectionTitle(String title) =>
      Text(title, style: black20.copyWith(fontWeight: FontWeight.w600));

  Widget _horizontalCardScroller(List<Widget> items) => SizedBox(
    height: 175,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, __) => const Gap(15),
      itemBuilder: (_, i) => items[i],
    ),
  );
}
