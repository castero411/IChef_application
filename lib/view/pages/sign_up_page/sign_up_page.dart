import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/functions/email_password_validator.dart';
import 'package:i_chef_application/provider/user_data_provider.dart';
import 'package:i_chef_application/view/commonWidgets/action_button.dart';
import 'package:i_chef_application/view/commonWidgets/login_form_field.dart';
import 'package:i_chef_application/view/commonWidgets/logo_container.dart';
import 'package:i_chef_application/view/text_styles.dart';

class SignUpPage extends ConsumerWidget {
  SignUpPage({super.key});

  static const double gap = 30;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  Center(child: logoWithBackground),
                  const Gap(40),
                  Text(
                    'Create Account',
                    style: secondary20.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Let\'s get started with iChef!',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const Gap(30),

                  /// Email
                  LoginFormField(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    controller: _emailController,
                    validator: emailValidator,
                  ),
                  const Gap(20),

                  /// Username
                  LoginFormField(
                    icon: Icons.person_outline,
                    label: 'Username',
                    controller: _usernameController,
                    validator: usernameValidator,
                  ),
                  const Gap(20),

                  /// Password
                  LoginFormField(
                    icon: Icons.lock_outline,
                    label: 'Password',
                    isObscured: true,
                    controller: _passwordController,
                    validator: passwordValidator,
                  ),
                  const Gap(30),

                  /// Sign Up Button
                  ActionButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          // Create user with Firebase Auth
                          await _auth.createUserWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          );

                          // Update provider state
                          ref
                              .read(userDataProvider.notifier)
                              .setEmail(_emailController.text.trim());
                          ref
                              .read(userDataProvider.notifier)
                              .setUsername(_usernameController.text.trim());

                          // Navigate to setup screen
                          Navigator.pushNamed(context, 'setup_account');
                        } on FirebaseAuthException catch (e) {
                          String message = 'An error occurred';
                          if (e.code == 'email-already-in-use') {
                            message = 'Email already in use';
                          } else if (e.code == 'weak-password') {
                            message = 'Password is too weak';
                          }
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        }
                      }
                    },
                    text: 'Sign Up',
                    height: 50,
                  ),
                  const Gap(20),

                  /// Divider
                  Row(
                    children: const [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const Gap(20),

                  /// Switch to login
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      child: Text(
                        'Already have an account? Log In',
                        style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Gap(30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
