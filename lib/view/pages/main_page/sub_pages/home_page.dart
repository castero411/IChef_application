import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/provider/user_data_provider.dart';
import 'package:i_chef_application/view/commonWidgets/home_item_widget.dart';
import 'package:i_chef_application/view/commonWidgets/ingredient_widget.dart';
import 'package:i_chef_application/view/text_styles.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String username = ref.watch(userDataProvider).name;

    String itemName = 'Spaghetti';
    ImageProvider itemImage = AssetImage("assets/bread.jpg");
    ImageProvider itemImage2 = AssetImage("assets/food.png");

    List<Widget> ingredients = [
      IngredientWidget(itemName: 'Celery', itemImage: itemImage2),
      IngredientWidget(itemName: 'Wood', itemImage: itemImage2),
      IngredientWidget(itemName: 'Fire', itemImage: itemImage2),
      IngredientWidget(itemName: 'Oil', itemImage: itemImage),
      IngredientWidget(itemName: 'Salt', itemImage: itemImage),
      IngredientWidget(itemName: 'Pepper', itemImage: itemImage2),
      IngredientWidget(itemName: 'Garlic', itemImage: itemImage2),
    ];

    Widget homeItem = HomeItemWidget(
      image: itemImage,
      itemName: itemName,
      time: '1h 30m',
      onTap: () {
        Navigator.pushNamed(context, 'recipe');
      },
    );

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
                // TODO: Replace with actual user name
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'chat');
        },
        backgroundColor: mainColor,
        tooltip: 'Ask iChef',
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      // Removed outer padding here
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionTitle("Popular Ingredients"),
            ),
            const Gap(10),
            SizedBox(
              height: 100,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: ingredients.length,
                separatorBuilder: (_, __) => const Gap(10),
                itemBuilder: (_, i) => ingredients[i],
              ),
            ),
            const Gap(30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionTitle("Recommended for You"),
            ),
            const Gap(12),
            _horizontalCardScroller([homeItem, homeItem, homeItem]),
            const Gap(30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionTitle("Based on Your Recent Meals"),
            ),
            const Gap(12),
            _horizontalCardScroller([homeItem, homeItem, homeItem]),
            const Gap(30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: black20.copyWith(fontWeight: FontWeight.w600));
  }

  Widget _horizontalCardScroller(List<Widget> items) {
    return SizedBox(
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
}
