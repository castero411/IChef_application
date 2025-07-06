import 'package:flutter/material.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/view/text_styles.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.height,
    this.color = mainColor,
  });
  final Function() onPressed;
  final String text;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Text(
            text,
            style:
                color == mainColor
                    ? white20.copyWith(fontWeight: FontWeight.w700)
                    : white20.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
          ),
        ),
      ),
    );
  }
}
