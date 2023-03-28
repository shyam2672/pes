part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoggedIn extends LoginState {}

class OTPSent extends LoginState {}

class SignIn extends LoginState {}

class LoginRequested extends LoginState {}

class Error extends LoginState {
  final String error;
  Error({required this.error});
}

class NoNetwork extends LoginState {}
