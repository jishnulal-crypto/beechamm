
// repositories/auth_repository.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projecy/App/core/utils/token_security_hashing.dart';
import 'package:projecy/App/screens/loginscreen/bloc/loginscreen_bloc.dart';

class AuthRepository {
  final http.Client client;

  AuthRepository({http.Client? client}) : client = client ?? http.Client();

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final Uri loginUri = Uri.parse('https://beechem.ishtech.live/api/login');
    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
      'mob_user': 1,
      'web_user': 0,
    };

    try {
      final response = await client.post(
        loginUri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "${TokenEncrypt.bearertoken}"
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> apiResponse = jsonDecode(response.body);
        
        if (apiResponse['status'] == true) {
          final loginResponse = LoginResponse.fromJson(apiResponse);
          await TokenEncrypt.encryptToken(loginResponse.accessToken);
          return loginResponse;
        } else {
          throw ApiException(
            message: apiResponse['message'] ?? 'Invalid email or password.',
            statusCode: response.statusCode,
          );
        }
      } else {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          message: errorBody['message'] ?? 'Login failed with status code ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Network error: Please check your internet connection.',
        statusCode: 0,
      );
    }
  }

}

// Custom exception class
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}