class PersonelSavedResponse {
  final bool status;
  final int id;
  final String message;

  PersonelSavedResponse({
    required this.status,
    required this.id,
    required this.message,
  });

  factory PersonelSavedResponse.fromJson(Map<String, dynamic> json) {
    return PersonelSavedResponse(
      status: json["status"] ?? false,
      id: json["id"] ?? 0,
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "id": id,
      "message": message,
    };
  }
}
