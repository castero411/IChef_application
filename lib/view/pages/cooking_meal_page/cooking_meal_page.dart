import 'package:flutter/material.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/view/commonWidgets/action_button.dart';
import 'package:i_chef_application/view/text_styles.dart';

class CookMealPage extends StatelessWidget {
  CookMealPage({super.key});
  final List<String> steps = [];
  final List<String> ingredients = [];
  final String mealName = 'BATATA and cheese sticks';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    int numberOfSteps = steps.length;
    int currentStep = 0;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ActionButton(
          onPressed: () {},
          text: 'Start',
          height: 44,
        ), //start the cooking
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(15),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: teritiaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: width,
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: (width / 5) * 2, // create progress bar
                    height: 5,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(mealName, style: black20),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // make it ask for closing first
                    },
                    icon: Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  const StepItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
