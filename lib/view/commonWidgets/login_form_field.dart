import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chef_application/constants/colors.dart';

class LoginFormField extends ConsumerWidget {
  LoginFormField({
    super.key,
    this.height = 70,
    this.width = double.infinity,
    this.isObscured = false,
    required this.label,
    required this.icon,
    required this.validator,
    required this.controller,
  });

  final double height;
  final double width;
  final String label;
  final IconData icon;
  final bool isObscured;
  final FormFieldValidator<String?> validator;
  final TextEditingController controller;

  static final obscureProvider = StateProvider<bool>((ref) => true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool obscureText = isObscured && ref.watch(obscureProvider);

    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: secondaryColor),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: TextFormField(
          validator: validator,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[700]),
            //labelText: label,
            hint: Text(
              label,
              style: TextStyle(color: Colors.black.withAlpha(100)),
            ),
            labelStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            suffixIcon:
                isObscured
                    ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        ref.read(obscureProvider.notifier).state = !obscureText;
                      },
                    )
                    : null,
          ),
        ),
      ),
    );
  }
}
