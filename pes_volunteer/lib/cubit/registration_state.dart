part of 'registration_cubit.dart';

@immutable
abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class ApplicationSubmitted extends RegistrationState {}

class ApplicationData extends RegistrationState {}

class RegistrationError extends RegistrationState {
  final String error;

  RegistrationError(this.error);
}
