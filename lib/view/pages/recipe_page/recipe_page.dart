import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/view/commonWidgets/ingredient_container.dart';
import 'package:i_chef_application/view/commonWidgets/ingredient_item.dart';
import 'package:i_chef_application/view/commonWidgets/x_icon_button.dart';
import 'package:i_chef_application/view/pages/cooking_meal_page/cooking_meal_page.dart';

class RecipePage extends StatefulWidget {
  RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    Image recipeImage = Image.asset(
      'assets/bread.jpg',
      width: double.infinity,
      height: 300,
      fit: BoxFit.cover,
    );

    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: 70,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement shopping cart navigation
                },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Shop Ingredients'),
              ),
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CookMealPage()),
                );
              },
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
      ),
      body: SafeArea(
        child: Stack(
          children: [
            recipeImage,
            Container(color: Colors.black.withAlpha(70), height: 300),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      XIconButton(
                        icon: Icons.arrow_back_ios_rounded,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        size: 24,
                      ),
                      XIconButton(
                        icon:
                            isFavourite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border,
                        onTap: () {
                          setState(() {
                            isFavourite = !isFavourite;
                          });
                        }, // TODO: Implement favourite functionality
                        size: 24,
                        iconColor:
                            isFavourite ? Colors.redAccent : Colors.black,
                      ),
                    ],
                  ),
                  const Gap(170),

                  // IngredientsGlassContainer with embedded Plan Meal button
                  IngredientsGlassContainer(
                    image: const AssetImage('assets/bread.jpg'),
                    height: 140,
                    calories: "200",
                    ingredientsNumber: '3',
                    minutes: '30',
                    recipeName: 'Baked Potato with cheese and bread',
                    onPlanMealPressed: () {
                      Navigator.pushNamed(context, 'plan_meal');
                      print('Plan Meal pressed!');
                    },
                  ),

                  const Gap(16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Divider(),
                  const IngredientItem(
                    text: '3/2 cup of refined wheat',
                    color: Colors.red,
                  ),
                  const IngredientItem(text: '1 Mashed Potato'),
                  const IngredientItem(text: '2 Pan bread'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
