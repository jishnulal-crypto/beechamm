class LoginValidators {
  /// Validates email - must be valid email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    // Email regex pattern
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validates password - must not be empty and at least 6 characters
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    if (value.length > 50) {
      return 'Password must not exceed 50 characters';
    }
    
    return null;
  }

  /// Validates login form - returns a map of field errors
  static Map<String, String> validateLoginForm({
    required String email,
    required String password,
  }) {
    Map<String, String> errors = {};

    final emailError = validateEmail(email);
    if (emailError != null) errors['email'] = emailError;

    final passwordError = validatePassword(password);
    if (passwordError != null) errors['password'] = passwordError;

    return errors;
  }
}