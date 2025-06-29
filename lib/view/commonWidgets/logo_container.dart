import 'package:flutter/material.dart';
import 'package:i_chef_application/constants/colors.dart';

var logoWithBackground = Container(
  height: 120,
  width: 120,
  decoration: BoxDecoration(
    color: mainColor,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: .1),
        blurRadius: 1,
        offset: Offset(0, 4),
        spreadRadius: 1,
      ),
    ],
    image: DecorationImage(
      image: AssetImage('assets/logo.png'),
      fit: BoxFit.scaleDown,
      scale: 1.3,
    ),
  ),
);
