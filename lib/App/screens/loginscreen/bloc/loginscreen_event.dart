part of 'loginscreen_bloc.dart';
abstract class LoginscreenEvent {}
class EmailChanged extends LoginscreenEvent { final String email; EmailChanged(this.email); }
class PasswordChanged extends LoginscreenEvent { final String password; PasswordChanged(this.password); }
class LoginRequested extends LoginscreenEvent {}
class ToggleRememberMe extends LoginscreenEvent {}
