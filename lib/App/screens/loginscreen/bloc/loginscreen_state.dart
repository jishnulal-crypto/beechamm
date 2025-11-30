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




class PasswordVisibilityState extends Equatable {
  final bool isObscured;

  const PasswordVisibilityState({required this.isObscured});

  PasswordVisibilityState copyWith({bool? isObscured}) {
    return PasswordVisibilityState(
      isObscured: isObscured ?? this.isObscured,
    );
  }

  @override
  List<Object?> get props => [isObscured];
}


class RememberMeState extends Equatable {
  final bool isEnabled;
  final bool isLoading;
  final String savedEmail;
  final String savedPassword;
  final bool hasSavedCredentials;
  final String? error;

  const RememberMeState({
    this.isEnabled = false,
    this.isLoading = false,
    this.savedEmail = '',
    this.savedPassword = '',
    this.hasSavedCredentials = false,
    this.error,
  });

  RememberMeState copyWith({
    bool? isEnabled,
    bool? isLoading,
    String? savedEmail,
    String? savedPassword,
    bool? hasSavedCredentials,
    String? error,
  }) {
    return RememberMeState(
      isEnabled: isEnabled ?? this.isEnabled,
      isLoading: isLoading ?? this.isLoading,
      savedEmail: savedEmail ?? this.savedEmail,
      savedPassword: savedPassword ?? this.savedPassword,
      hasSavedCredentials: hasSavedCredentials ?? this.hasSavedCredentials,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    isEnabled,
    isLoading,
    savedEmail,
    savedPassword,
    hasSavedCredentials,
    error,
  ];
}