import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/provider/user_data_provider.dart';
import 'package:i_chef_application/view/commonWidgets/action_button.dart';
import 'package:i_chef_application/view/commonWidgets/login_form_field.dart';
import 'package:i_chef_application/view/text_styles.dart';

class SetupAccountPage extends ConsumerStatefulWidget {
  const SetupAccountPage({super.key});

  @override
  ConsumerState<SetupAccountPage> createState() => _SetupAccountPageState();
}

class _SetupAccountPageState extends ConsumerState<SetupAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();

  String _selectedGender = 'Select Gender';
  final List<String> _genders = ['Male', 'Female'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  String? _ageValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    }
    final age = int.tryParse(value);
    if (age == null || age <= 0 || age > 120) {
      return 'Enter a valid age';
    }
    return null;
  }

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

                  /// Full Name
                  LoginFormField(
                    icon: Icons.person_outline,
                    label: 'Full Name',
                    controller: _fullNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const Gap(20),

                  /// Age
                  LoginFormField(
                    icon: Icons.calendar_today_outlined,
                    label: 'Age',
                    controller: _ageController,
                    validator: _ageValidator,
                  ),
                  const Gap(20),

                  /// Gender Dropdown
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Gap(30),

                  /// Continue Button
                  ActionButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final notifier = ref.read(userDataProvider.notifier);

                        print("executing");
                        // Update local state
                        notifier.setName(_fullNameController.text);
                        notifier.setAge(int.parse(_ageController.text));
                        notifier.setGender(_selectedGender);

                        try {
                          // Save to Firestore
                          await notifier.createUserInFirebase();

                          // Go to home
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            'home',
                            (Route<dynamic> route) => false,
                          );
                        } catch (e) {
                          print('Failed to save user: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to save profile. Try again.',
                              ),
                            ),
                          );
                        }
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
