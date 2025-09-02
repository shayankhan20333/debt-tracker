class MyValidators {
  static String? displayNamevalidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Display name must be between 3 and 20 characters';
    }

    return null; // Return null if display name is valid
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    ).hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? contactValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a contact number';
    }

    // If number starts with +
    if (value.startsWith('+')) {
      final RegExp plusPattern = RegExp(r'^\+[0-9]{12}$');
      // + followed by 12 digits = total length 13
      if (!plusPattern.hasMatch(value)) {
        return 'Contact must be 13 digits long starting with +';
      }
      return null; // valid
    }

    // If number starts with 0
    if (value.startsWith('0')) {
      final RegExp zeroPattern = RegExp(r'^03[0-9]{9}$');
      // must start with 03 and have 11 digits total
      if (!zeroPattern.hasMatch(value)) {
        return 'Contact must be 11 digits long and start with 03';
      }
      return null; // valid
    }

    return 'Contact must start with + or 03';
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? uploadProdTexts({String? value, String? toBeReturnedString}) {
    if (value!.isEmpty) {
      return toBeReturnedString;
    }
    return null;
  }
}
