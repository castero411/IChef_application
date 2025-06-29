import 'package:flutter/material.dart';

class IngredientItem extends StatelessWidget {
  final String text;
  final Color? color;

  const IngredientItem({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    //TODO : check on the ingredients
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            text.split(' ')[0],
            style: TextStyle(color: color ?? Colors.black),
          ),
          const SizedBox(width: 6),
          Text(
            text.split(' ').skip(1).join(' '),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
