class TokenEncrypt {
  static String? encrypted;
  static String? bearertoken ='jadkjh89823hewf9u98w989888f8j98j98f9j98j9f8j98j';
  static String? justToken;
  // Encrypt
  static Future encryptToken(String text)async {
    List<int> bytes = text.codeUnits.map((c) => c ^ 42).toList(); 
    justToken = text;
    encrypted = String.fromCharCodes(bytes);
    print(encrypted.toString()+"this is the token acces from class");
  }

  // Decrypt
  static String decryptToken() {
    if (encrypted == null) return "";
    List<int> bytes = encrypted!.codeUnits.map((c) => c ^ 42).toList();
    return String.fromCharCodes(bytes);
  }
}
