part of 'loginscreen_bloc.dart';
abstract class LoginscreenEvent {}
class EmailChanged extends LoginscreenEvent { final String email; EmailChanged(this.email); }
class PasswordChanged extends LoginscreenEvent { final String password; PasswordChanged(this.password); }
class LoginRequested extends LoginscreenEvent {}
class ToggleRememberMe extends LoginscreenEvent {}

abstract class PasswordVisibilityEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TogglePasswordVisibility extends PasswordVisibilityEvent {}




abstract class RememberMeEvent extends Equatable {
  const RememberMeEvent();

  @override
  List<Object?> get props => [];
}

class RememberMeToggled extends RememberMeEvent {
  final bool isEnabled;

  const RememberMeToggled(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class SaveCredentials extends RememberMeEvent {
  final String email;
  final String password;

  const SaveCredentials({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoadCredentials extends RememberMeEvent {}

class ClearSavedCredentials extends RememberMeEvent {}