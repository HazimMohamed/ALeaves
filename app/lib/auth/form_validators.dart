String? emailValidator(String? email) {
  if (email == null || email.isEmpty) {
    return 'Must set an email';
  }
  final emailRegex = RegExp(r'^.+@.+\..+$');
  if (!emailRegex.hasMatch(email)) {
    return 'Email must be a valid email address';
  }
  return null;
}

String? requiredValidator(String? username) {
  if (username == null || username.isEmpty) {
    return 'Field must be set.';
  }
  return null;
}

String? validatePasswordContainsCharacterInList(
    String password, List<String> requiredCharacters) {
  var hasRequiredCharacter = false;
  for (var requiredCharacter in requiredCharacters) {
    if (password.contains(requiredCharacter)) {
      hasRequiredCharacter = true;
      break;
    }
  }
  if (!hasRequiredCharacter) {
    return 'Password must contain one of the following characters: ${requiredCharacters.join(',')}';
  }
  return null;
}

String? passwordValidator(String? password) {
  if (password == null) {
    return 'Must set a password';
  }
  if (password.length < 10) {
    return 'Password must be at least 10 characters';
  }
  if (password.length > 40) {
    return 'Password cannot be more than 40 characters';
  }
  final requiredCharacters = ['%', '!', '?', '@', '&'];
  return validatePasswordContainsCharacterInList(password, requiredCharacters);
}

String? repeatPasswordValidator(String? password, String? repeatPassword) {
  if (password != repeatPassword) {
    return 'Passwords do not match';
  }
  return null;
}