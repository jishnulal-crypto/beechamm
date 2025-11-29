part of 'loginscreen_bloc.dart';
class LoginscreenState {
  final String email;
  final String password;
  final bool isLoading;
  final bool isPasswordVisible;
  final bool rememberMe;
  final String? errorMessage;
  final bool isLoginSuccess;
  final String? accessToken;  
  LoginscreenState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.rememberMe = false,
    this.errorMessage,
    this.isLoginSuccess = false,
    this.accessToken,
  });
  LoginscreenState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? isPasswordVisible,
    bool? rememberMe,
    String? errorMessage,
    bool? isLoginSuccess,
    String? accessToken,
  }) {
    return LoginscreenState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      errorMessage: errorMessage,  
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
      accessToken: accessToken,
    );
  }
}
