class PersonnelValidators {
  /// Validates full name - must not be empty and at least 2 characters
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (value.trim().length > 100) {
      return 'Full name must not exceed 100 characters';
    }
    return null;
  }

  /// Validates address - must not be empty and at least 5 characters
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.trim().length < 5) {
      return 'Address must be at least 5 characters';
    }
    if (value.trim().length > 150) {
      return 'Address must not exceed 150 characters';
    }
    return null;
  }

  /// Validates suburb - must not be empty
  static String? validateSuburb(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Suburb is required';
    }
    if (value.trim().length < 2) {
      return 'Suburb must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Suburb must not exceed 50 characters';
    }
    return null;
  }

  /// Validates state code - must be 2-3 characters
  static String? validateStateCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'State is required';
    }
    if (value.trim().length < 2 || value.trim().length > 3) {
      return 'State must be 2-3 characters';
    }
    return null;
  }

  /// Validates post code - must be numeric and 4-6 digits
  static String? validatePostCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Post code is required';
    }
    if (!RegExp(r'^\d{4,6}$').hasMatch(value.trim())) {
      return 'Post code must be 4-6 digits';
    }
    return null;
  }

  /// Validates contact number - must be numeric and 7-15 digits
  static String? validateContactNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }
    if (!RegExp(r'^\d{7,15}$').hasMatch(value.trim())) {
      return 'Contact number must be 7-15 digits';
    }
    return null;
  }

  /// Validates role - at least one role must be selected
  static String? validateRole(Map<String, dynamic>? selectedRoles) {
    if (selectedRoles == null || selectedRoles.isEmpty) {
      return 'Please select at least one role';
    }
    return null;
  }

  /// Validates additional notes - optional but max 500 characters
  static String? validateAdditionalNotes(String? value) {
    if (value != null && value.length > 500) {
      return 'Additional notes must not exceed 500 characters';
    }
    return null;
  }

  /// Validates entire form - returns a map of field errors
  static Map<String, String> validateForm({
    required String fullName,
    required String address,
    required String suburb,
    required String stateCode,
    required String postCode,
    required String contactNumber,
    Map<String, dynamic>? selectedRoles,
    required String additionalNotes,
  }) {
    Map<String, String> errors = {};

    final fullNameError = validateFullName(fullName);
    if (fullNameError != null) errors['fullName'] = fullNameError;

    final addressError = validateAddress(address);
    if (addressError != null) errors['address'] = addressError;

    final suburbError = validateSuburb(suburb);
    if (suburbError != null) errors['suburb'] = suburbError;

    final stateCodeError = validateStateCode(stateCode);
    if (stateCodeError != null) errors['stateCode'] = stateCodeError;

    final postCodeError = validatePostCode(postCode);
    if (postCodeError != null) errors['postCode'] = postCodeError;

    final contactNumberError = validateContactNumber(contactNumber);
    if (contactNumberError != null) errors['contactNumber'] = contactNumberError;

    final roleError = validateRole(selectedRoles);
    if (roleError != null) errors['role'] = roleError;

    final notesError = validateAdditionalNotes(additionalNotes);
    if (notesError != null) errors['additionalNotes'] = notesError;

    return errors;
  }
}