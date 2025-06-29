import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/view/commonWidgets/action_button.dart';
import 'package:i_chef_application/view/commonWidgets/login_form_field.dart';
import 'package:i_chef_application/view/text_styles.dart';

class SetupAccountPage extends StatefulWidget {
  const SetupAccountPage({super.key});

  @override
  State<SetupAccountPage> createState() => _SetupAccountPageState();
}

class _SetupAccountPageState extends State<SetupAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = 'Select Gender';
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Setup Your Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  Text(
                    'Tell us about yourself',
                    style: secondary20.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(20),
                  LoginFormField(
                    icon: Icons.person_outline,
                    label: 'Full Name',
                  ),
                  const Gap(20),
                  LoginFormField(
                    icon: Icons.calendar_today_outlined,
                    label: 'Age',
                  ),
                  const Gap(20),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: secondaryColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField<String>(
                      value:
                          _selectedGender == 'Select Gender'
                              ? null
                              : _selectedGender,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Gender',
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items:
                          _genders
                              .map(
                                (gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                  ),
                  const Gap(20),
                  LoginFormField(
                    icon: Icons.flag_outlined,
                    label: 'Dietary Goal (e.g. Lose weight)',
                  ),
                  const Gap(30),
                  ActionButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacementNamed(
                          context,
                          'home',
                        ); // or next setup screen
                      }
                    },
                    text: 'Continue',
                    height: 50,
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
