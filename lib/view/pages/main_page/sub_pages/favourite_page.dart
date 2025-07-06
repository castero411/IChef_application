import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chef_application/provider/saved_meals_providedr.dart';
import 'package:i_chef_application/view/commonWidgets/item_widget.dart';
import 'package:i_chef_application/view/pages/recipe_page/recipe_page.dart';
import 'package:i_chef_application/view/text_styles.dart';
import 'package:i_chef_application/model/saved_meal.dart';

class FavouritePage extends ConsumerWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedMeals = ref.watch(savedMealsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Favourite', style: secondarytitle25)),
      body:
          savedMeals.isEmpty
              ? const Center(child: Text('No saved meals yet.'))
              : ListView.builder(
                itemCount: savedMeals.length,
                itemBuilder: (context, index) {
                  final meal = savedMeals[index];
                  return ItemWidget(
                    title: meal.name,
                    image: meal.image,
                    calories: meal.calories,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RecipePage(recipeTitle: meal.name),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
