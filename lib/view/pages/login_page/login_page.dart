import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/view/commonWidgets/action_button.dart';
import 'package:i_chef_application/view/commonWidgets/login_form_field.dart';
import 'package:i_chef_application/view/commonWidgets/logo_container.dart';
import 'package:i_chef_application/view/text_styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static double gap = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  Center(child: logoWithBackground),
                  const Gap(40),
                  Text(
                    'Welcome Back!',
                    style: secondary20.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Log in to continue using iChef.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const Gap(30),
                  LoginFormField(icon: Icons.email_outlined, label: 'Email'),
                  const Gap(20),
                  LoginFormField(
                    icon: Icons.lock_outline,
                    label: 'Password',
                    isObscured: true,
                  ),
                  const Gap(10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: mainColor),
                      ),
                    ),
                  ),
                  const Gap(10),
                  ActionButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'home',
                        (Route<dynamic> route) => false,
                      );
                    },
                    text: 'Log in',
                    height: 50,
                  ),
                  const Gap(20),
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
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'signup');
                      },
                      child: Text(
                        "Don't have an account? Sign Up",
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
