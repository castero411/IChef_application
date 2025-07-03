import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/functions/email_password_validator.dart';
import 'package:i_chef_application/view/commonWidgets/action_button.dart';
import 'package:i_chef_application/view/commonWidgets/login_form_field.dart';
import 'package:i_chef_application/view/commonWidgets/logo_container.dart';
import 'package:i_chef_application/view/text_styles.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  static const double gap = 30;

  final _formKey = GlobalKey<FormState>();
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

                  // Email
                  LoginFormField(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    controller: _usernameController,
                    validator: emailValidator,
                  ),
                  const Gap(20),

                  // Password
                  LoginFormField(
                    icon: Icons.lock_outline,
                    label: 'Password',
                    isObscured: true,
                    controller: _passwordController,
                    validator: passwordValidator,
                  ),
                  const Gap(10),

                  // Forgot password button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final TextEditingController emailController =
                            TextEditingController();
                        bool isSending = false;

                        await showDialog(
                          context: context,
                          barrierDismissible: !isSending,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text("Reset Password"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                          hintText: "Enter your email",
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        enabled: !isSending,
                                      ),
                                      if (isSending)
                                        const Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: CircularProgressIndicator(),
                                        ),
                                    ],
                                  ),
                                  actions: [
                                    if (!isSending)
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel"),
                                      ),
                                    if (!isSending)
                                      TextButton(
                                        onPressed: () async {
                                          final email =
                                              emailController.text.trim();
                                          final isValid = RegExp(
                                            r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                                          ).hasMatch(email);

                                          if (!isValid) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Please enter a valid email.",
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }

                                          setState(() => isSending = true);

                                          try {
                                            await FirebaseAuth.instance
                                                .sendPasswordResetEmail(
                                                  email: email,
                                                );

                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Reset link sent to $email",
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            setState(() => isSending = false);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Error: ${e.toString()}",
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: const Text("Send"),
                                      ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: mainColor),
                      ),
                    ),
                  ),
                  const Gap(10),

                  // Login Button
                  ActionButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                        );

                        try {
                          await _auth.signInWithEmailAndPassword(
                            email: _usernameController.text.trim(),
                            password: _passwordController.text,
                          );

                          Navigator.of(context).pop(); // remove loading
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            'home',
                            (Route<dynamic> route) => false,
                          );
                        } on FirebaseAuthException catch (e) {
                          Navigator.of(context).pop(); // remove loading

                          String message = 'Login failed. Please try again.';
                          if (e.code == 'user-not-found') {
                            message = 'No user found for that email.';
                          } else if (e.code == 'wrong-password') {
                            message = 'Wrong password provided.';
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } catch (e) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Something went wrong.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    text: 'Log in',
                    height: 50,
                  ),
                  const Gap(20),

                  // OR Divider
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

                  // Sign up redirect
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
