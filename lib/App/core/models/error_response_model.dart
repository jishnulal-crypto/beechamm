class ErrorResponse {
  final String? message;
  final Map<String, List<String>>? errors;

  ErrorResponse({
    this.message,
    this.errors,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'],
      errors: json['errors'] != null
          ? (json['errors'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                List<String>.from(value),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'errors': errors,
    };
  }
}
