import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:glass/glass.dart';

class IngredientsGlassContainer extends StatelessWidget {
  const IngredientsGlassContainer({
    super.key,
    required this.image,
    required this.height,
    required this.recipeName,
    required this.ingredientsNumber,
    required this.minutes,
    required this.calories,
    required this.onPlanMealPressed,
  });

  final ImageProvider<Object> image;
  final double height;
  final String recipeName;
  final String ingredientsNumber;
  final String minutes;
  final String calories;
  final VoidCallback onPlanMealPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(
            image: image,
            width: MediaQuery.of(context).size.width,
            height: height,
            fit: BoxFit.cover,
          ),
          Container(
            height: height,
            decoration: BoxDecoration(color: Colors.white.withAlpha(160)),
          ).asGlass(clipBorderRadius: BorderRadius.circular(20)),
          SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    recipeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoStat(label: 'Ingredients', value: ingredientsNumber),
                      _InfoStat(label: 'Minutes', value: minutes),
                      _InfoStat(label: 'Calories', value: calories),
                      OutlinedButton(
                        onPressed: onPlanMealPressed,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black87),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'Plan Meal',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoStat extends StatelessWidget {
  final String label;
  final String value;

  const _InfoStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.black, fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }
}
