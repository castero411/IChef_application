import 'package:flutter/material.dart';
import 'package:i_chef_application/constants/colors.dart'; // if using for consistent theming

class IngredientWidget extends StatelessWidget {
  const IngredientWidget({
    super.key,
    this.itemName = 'Item',
    required this.itemImage,
  });

  final String itemName;
  final ImageProvider<Object> itemImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: InkWell(
        onTap: () {
          // TODO: Implement onTap functionality if needed
        },
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(image: itemImage, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              itemName,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
