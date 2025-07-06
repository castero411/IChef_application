import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/view/commonWidgets/action_button.dart';
import 'package:i_chef_application/view/text_styles.dart';

class CookMealPage extends StatefulWidget {
  const CookMealPage({
    super.key,
    required this.steps,
    required this.ingredients,
    required this.mealName,
  });

  final List<String> steps;
  final List<String> ingredients;
  final String mealName;

  @override
  State<CookMealPage> createState() => _CookMealPageState();
}

class _CookMealPageState extends State<CookMealPage> {
  int currentStep = -1; // -1 = show ingredients
  final FlutterTts tts = FlutterTts();

  void _nextStep() async {
    setState(() {
      currentStep++;
    });

    if (currentStep >= 0 && currentStep < widget.steps.length) {
      await tts.speak(widget.steps[currentStep]);
    }
  }

  void _speakCurrentStep() async {
    if (currentStep >= 0 && currentStep < widget.steps.length) {
      await tts.speak(widget.steps[currentStep]);
    }
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final totalSteps = widget.steps.length;

    if (currentStep > totalSteps - 1) {
      Navigator.pop(context);
    }

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ActionButton(
          onPressed: _nextStep,
          text:
              currentStep == -1
                  ? 'Start Cooking'
                  : (currentStep < totalSteps - 1 ? 'Next Step' : 'Finish'),
          height: 50,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width:
                        width *
                        (currentStep + 1) /
                        (totalSteps + 1), // +1 for ingredient screen
                    height: 5,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.mealName, style: black20),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Main Content
              Expanded(
                child:
                    currentStep == -1
                        ? _buildIngredientView()
                        : _buildStepView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ingredients to prepare:", style: secondarytitle25),
        const SizedBox(height: 12),
        ...widget.ingredients.map(
          (ing) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text("• $ing", style: black14),
          ),
        ),
      ],
    );
  }

  Widget _buildStepView() {
    final stepText = widget.steps[currentStep];
    final isLast = currentStep == widget.steps.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step ${currentStep + 1}/${widget.steps.length}",
          style: secondarytitle25.copyWith(color: mainColor),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(child: Text(stepText, style: black16)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.volume_up_rounded),
              onPressed: _speakCurrentStep,
            ),
          ],
        ),
        if (isLast)
          Center(
            child: Text(
              "You're done! 🎉\n",
              style: black16.copyWith(color: Colors.green),
            ),
          ),
      ],
    );
  }
}
