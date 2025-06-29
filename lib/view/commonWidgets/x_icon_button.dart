import 'package:flutter/material.dart';
import 'package:i_chef_application/constants/colors.dart';

class XIconButton extends StatelessWidget {
  const XIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 30,
    this.iconColor = Colors.black,
  });
  final IconData icon;
  final Function() onTap;
  final double size;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: teritiaryColor.withAlpha(170),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(6),
        child: Center(child: Icon(icon, size: size, color: iconColor)),
      ),
    );
  }
}
