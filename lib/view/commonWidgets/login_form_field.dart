import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/constants/colors.dart';

class LoginFormField extends StatefulWidget {
  const LoginFormField({
    super.key,
    this.height = 70,
    this.width = double.infinity,
    this.isObscured = false,
    required this.label,
    required this.icon,
  });

  final double height;
  final double width;
  final String label;
  final IconData icon;
  final bool isObscured;

  @override
  State<LoginFormField> createState() => _LoginFormFieldState();
}

class _LoginFormFieldState extends State<LoginFormField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isObscured;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
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
          obscureText: _obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: Colors.grey[700]),
            labelText: widget.label,
            labelStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            suffixIcon:
                widget.isObscured
                    ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                    : null,
          ),
        ),
      ),
    );
  }
}
