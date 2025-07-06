import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/view/commonWidgets/action_button.dart';
import 'package:i_chef_application/view/text_styles.dart';

class PlanMealPage extends StatefulWidget {
  const PlanMealPage({super.key, required this.mealName});
  final String mealName;

  @override
  State<PlanMealPage> createState() => _PlanMealPageState();
}

class _PlanMealPageState extends State<PlanMealPage> {
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String? selectedDay;
  TimeOfDay? selectedTime;

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _confirmPlan() {
    if (selectedDay == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both day and time")),
      );
      return;
    }

    final timeText = selectedTime!.format(context);
    final message =
        'Meal "${widget.mealName}" planned for $selectedDay at $timeText';

    // You could send this to Firestore here or pass it back
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));

    Navigator.pop(context); // or move to another screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Plan your meal', style: secondarytitle25),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ActionButton(
          text: "Confirm Plan",
          onPressed: _confirmPlan,
          height: 48,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What day do you want to eat ${widget.mealName}?",
              style: black20,
            ),
            const Gap(16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  _days.map((day) {
                    final isSelected = selectedDay == day;
                    return ChoiceChip(
                      label: Text(day),
                      selected: isSelected,
                      selectedColor: mainColor.withOpacity(0.2),
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: isSelected ? mainColor : Colors.black,
                      ),
                      onSelected: (_) => setState(() => selectedDay = day),
                    );
                  }).toList(),
            ),
            const Gap(32),
            Text("What time?", style: black20),
            const Gap(12),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: mainColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : "Select Time",
                      style: black16,
                    ),
                    const Icon(Icons.schedule, color: mainColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
