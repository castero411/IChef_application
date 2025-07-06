import 'package:flutter/material.dart';

class IngredientItem extends StatelessWidget {
  final String text;
  final Color? color;

  const IngredientItem({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    // Split just once
    final parts = text.split(' ');
    final firstWord = parts.first;
    final rest = parts.skip(1).join(' ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // align multi‑line correctly
        children: [
          Text(firstWord, style: TextStyle(color: color ?? Colors.black)),
          const SizedBox(width: 6),
          // Expanded lets the text take remaining width and wrap
          Expanded(
            child: Text(
              rest,
              softWrap: true, // allow wrapping
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
