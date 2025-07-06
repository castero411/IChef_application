import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/functions/api_service.dart';
import 'package:i_chef_application/functions/get_instructions.dart';
import 'package:i_chef_application/model/recipe_details.dart';
import 'package:i_chef_application/model/saved_meal.dart';
import 'package:i_chef_application/provider/saved_meals_providedr.dart';
import 'package:i_chef_application/view/commonWidgets/ingredient_container.dart';
import 'package:i_chef_application/view/commonWidgets/ingredient_item.dart';
import 'package:i_chef_application/view/commonWidgets/x_icon_button.dart';
import 'package:i_chef_application/view/pages/cooking_meal_page/cooking_meal_page.dart';

class RecipePage extends ConsumerStatefulWidget {
  const RecipePage({super.key, required this.recipeTitle});

  final String recipeTitle;

  @override
  ConsumerState<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends ConsumerState<RecipePage> {
  late Future<RecipeDetails> _future;
  late List<String> instructions;
  late List<String> ingredients;
  late String mealName;

  @override
  void initState() {
    super.initState();
    _future = ChefApiService().fetchRecipeDetailsByTitle(
      userId: FirebaseAuth.instance.currentUser?.uid ?? '',
      title: widget.recipeTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomButtons(
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => CookMealPage(
                  steps: instructions,
                  ingredients: ingredients,
                  mealName: mealName,
                ),
          ),
        ),
      ),
      body: FutureBuilder<RecipeDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final recipe = snapshot.data!;
          instructions = extractInstructionsList(recipe.preparationSteps);
          mealName = recipe.title;
          ingredients = recipe.ingredients;
          //print(snapshot.data!.preparationSteps);

          // Insert into "recently viewed" history
          final historyNotifier = ref.read(recentMealsProvider.notifier);

          historyNotifier.add(
            SavedMeal(
              name: recipe.title,
              image: recipe.image,
              calories: recipe.calories.toString(),
            ),
          );

          return SafeArea(
            child: Stack(
              children: [
                Image.network(
                  recipe.image,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Container(color: Colors.black.withOpacity(0.5), height: 300),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(recipe),
                      const Gap(170),
                      IngredientsGlassContainer(
                        image: NetworkImage(recipe.image),
                        height: 140,
                        calories: recipe.calories.toString(),
                        ingredientsNumber: recipe.ingredients.length.toString(),
                        minutes: '30', // static placeholder
                        recipeName: recipe.title,
                        onPlanMealPressed:
                            () => Navigator.pushNamed(context, 'plan_meal'),
                      ),
                      const Gap(16),

                      // Scrollable container for ingredients & steps only
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 540,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionTitle('Ingredients'),
                              const Divider(),
                              ...recipe.ingredients
                                  .map(
                                    (i) => IngredientItem(
                                      text: i,
                                      color: Colors.red,
                                    ),
                                  )
                                  .toList(),
                              const Gap(16),
                              _sectionTitle('Steps'),
                              const Divider(),
                              ...buildStepWidgets(instructions),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ───────────────────────────────────────────────────── header / fav button
  Widget _buildHeader(RecipeDetails recipe) {
    final isFavourite = ref.watch(
      savedMealsProvider.select(
        (meals) => meals.any((m) => m.name == recipe.title),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        XIconButton(
          icon: Icons.arrow_back_ios_rounded,
          onTap: () => Navigator.pop(context),
          size: 24,
        ),
        XIconButton(
          icon: isFavourite ? Icons.favorite_rounded : Icons.favorite_border,
          iconColor: isFavourite ? Colors.redAccent : Colors.black,
          size: 24,
          onTap: () {
            final meal = SavedMeal(
              name: recipe.title,
              image: recipe.image,
              calories: recipe.calories.toString(),
            );
            ref.read(savedMealsProvider.notifier).toggle(meal);
          },
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────── section titles
  Widget _sectionTitle(String title) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );

  // ─────────────────────────────────────────────────── split steps into list
  List<Widget> buildStepWidgets(List<String> steps) =>
      steps.map((s) => IngredientItem(text: s, color: Colors.red)).toList();

  // ───────────────────────────────────────────────────── bottom action bar
  Widget _buildBottomButtons(Function() onCook) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    height: 70,
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Navigate to shopping cart page
            },
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Shop Ingredients'),
          ),
        ),
        const Gap(16),
        ElevatedButton(
          onPressed: onCook,
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
            padding: const EdgeInsets.symmetric(horizontal: 28),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Cook', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
