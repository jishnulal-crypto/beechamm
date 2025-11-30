import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:projecy/App/core/models/user_model.dart';
import 'package:projecy/App/screens/loginscreen/repository/loginscreen_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
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



class PasswordVisibilityBloc
    extends Bloc<PasswordVisibilityEvent, PasswordVisibilityState> {
  PasswordVisibilityBloc()
      : super(const PasswordVisibilityState(isObscured: true)) {
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isObscured: !state.isObscured));
    });
  }
}

// bloc/loginscreen_bloc.dart
class LoginscreenBloc extends Bloc<LoginscreenEvent, LoginscreenState> {
  final AuthRepository authRepository;

  LoginscreenBloc({required this.authRepository}) : super(LoginscreenState()) {
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
    // Validation
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(
        state.copyWith(errorMessage: 'Please enter both email and password.'),
      );
      return;
    }

    // Start loading
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isLoginSuccess: false,
      ),
    );

    try {
      // Call repository for API logic
      final loginResponse = await authRepository.login(
        email: state.email,
        password: state.password,
      );

      // Success
      emit(
        state.copyWith(
          isLoading: false,
          isLoginSuccess: true,
          accessToken: loginResponse.accessToken,
          errorMessage: null,
        ),
      );
      
    } on ApiException catch (e) {
      // Handle API errors
      emit(
        state.copyWith(
          isLoading: false,
          isLoginSuccess: false,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      // Handle unexpected errors
      emit(
        state.copyWith(
          isLoading: false,
          isLoginSuccess: false,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }
}






class RememberMeBloc extends Bloc<RememberMeEvent, RememberMeState> {
  late SharedPreferences prefs;

  RememberMeBloc({required pref}) : super(const RememberMeState()) {
    on<RememberMeToggled>(_onRememberMeToggled);
    on<SaveCredentials>(_onSaveCredentials);
    on<LoadCredentials>(_onLoadCredentials);
    on<ClearSavedCredentials>(_onClearSavedCredentials);
  }

  void _onRememberMeToggled(RememberMeToggled event, Emitter<RememberMeState> emit) {
    emit(state.copyWith(isEnabled: event.isEnabled));
    
    // If disabling, clear saved credentials
    if (!event.isEnabled) {
      add(ClearSavedCredentials());
    }
  }

  void _onSaveCredentials(SaveCredentials event, Emitter<RememberMeState> emit) async {
    if (!state.isEnabled) return;

    emit(state.copyWith(isLoading: true));

    try {
      await prefs.setString('remembered_email', event.email);
      await prefs.setString('remembered_password', event.password);
      await prefs.setBool('should_remember', true);

      emit(state.copyWith(
        isLoading: false,
        savedEmail: event.email,
        savedPassword: event.password,
        hasSavedCredentials: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to save credentials',
      ));
    }
  }

  void _onLoadCredentials(LoadCredentials event, Emitter<RememberMeState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final shouldRemember = prefs.getBool('should_remember') ?? false;
      final email = prefs.getString('remembered_email') ?? '';
      final password = prefs.getString('remembered_password') ?? '';
      
      final hasCredentials = email.isNotEmpty && password.isNotEmpty;

      emit(state.copyWith(
        isLoading: false,
        isEnabled: shouldRemember,
        savedEmail: email,
        savedPassword: password,
        hasSavedCredentials: hasCredentials,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load credentials',
      ));
    }
  }

  void _onClearSavedCredentials(ClearSavedCredentials event, Emitter<RememberMeState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      await prefs.remove('remembered_email');
      await prefs.remove('remembered_password');
      await prefs.setBool('should_remember', false);

      emit(state.copyWith(
        isLoading: false,
        savedEmail: '',
        savedPassword: '',
        hasSavedCredentials: false,
        isEnabled: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to clear credentials',
      ));
    }
  }
}