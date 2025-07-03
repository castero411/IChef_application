bool isEmail(String input) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(input);
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'please enter your email';
  } else if (!(isEmail(value))) {
    return 'please enter a valid email';
  }

  return null;
}

String? usernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'please enter your username';
  }

  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'please enter your password';
  }
  return null;
}
