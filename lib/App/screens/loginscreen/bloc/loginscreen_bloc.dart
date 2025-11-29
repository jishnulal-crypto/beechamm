import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:projecy/App/core/enums/enums.dart';
import 'package:projecy/App/core/models/login_response_model.dart';
import 'package:projecy/App/core/models/user_model.dart';
import 'package:projecy/App/core/utils/token_security_hashing.dart';
part 'loginscreen_event.dart';
part 'loginscreen_state.dart';



class LoginResponse {
  final bool status;
  final String accessToken;
  final String refreshToken;
  final double expiresInSec;
  final User user;
  LoginResponse({
    required this.status,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresInSec,
    required this.user,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as bool,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresInSec: json['expires_in_sec'] as double,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}


class LoginscreenBloc extends Bloc<LoginscreenEvent, LoginscreenState> {
  LoginscreenBloc() : super(LoginscreenState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ToggleRememberMe>(_onToggleRememberMe);
    on<LoginRequested>(_onLoginRequested);
  }
  void _onEmailChanged(EmailChanged event, Emitter<LoginscreenState> emit) {
    emit(
      state.copyWith(email: event.email, errorMessage: null),
    );  
  }
  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<LoginscreenState> emit,
  ) {
    emit(
      state.copyWith(password: event.password, errorMessage: null),
    );  
  }
  void _onToggleRememberMe(
    ToggleRememberMe event,
    Emitter<LoginscreenState> emit,
  ) {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginscreenState> emit,
  ) async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(
        state.copyWith(errorMessage: 'Please enter both email and password.'),
      );
      return;
    }
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isLoginSuccess: false,
      ),
    );
    final Uri loginUri = Uri.parse('https://beechem.ishtech.live/api/login');
    final Map<String, dynamic> requestBody = {
      'email': state.email,
      'password': state.password,
      'mob_user':1,
      'web_user':0
    };
    try {
      
      final http.Response response = await http.post(
        loginUri,
        headers: {'Content-Type': 'application/json','Authorization': "${TokenEncrypt.bearertoken}"},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> apiResponse = jsonDecode(response.body);
        if (apiResponse['status'] == true) {
          final loginResponse = LoginResponse.fromJson(apiResponse);
          print("loginresponse${loginResponse.accessToken}");
          await TokenEncrypt.encryptToken(loginResponse.accessToken);
          print("fine it is here");
          emit(
            state.copyWith(
              isLoading: false,
              isLoginSuccess: true,
              accessToken: loginResponse.accessToken,
              errorMessage: null,
            ),
          );
          return;  
        }
        emit(
          state.copyWith(
            isLoading: false,
            isLoginSuccess: false,
            errorMessage:
                apiResponse['me ssage'] ?? 'Invalid email or password.',
          ),
        );
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMsg =
            errorBody['message'] ??
            'Login failed with status code ${response.statusCode}';
        emit(
          state.copyWith(
            isLoading: false,
            isLoginSuccess: false,
            errorMessage: errorMsg,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isLoginSuccess: false,
          errorMessage: 'Network error: Please check your internet connection.',
        ),
      );
    }
  }
}
