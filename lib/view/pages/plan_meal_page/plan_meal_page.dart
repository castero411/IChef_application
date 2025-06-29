import 'package:flutter/material.dart';
import 'package:i_chef_application/view/text_styles.dart';

class PlanMealPage extends StatelessWidget {
  const PlanMealPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plan your meal', style: secondarytitle25)),
    );
  }
}
