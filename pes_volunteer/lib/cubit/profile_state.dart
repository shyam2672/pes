part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile user;

  ProfileLoaded(this.user);
}

class LoadError extends ProfileState {
  final String error;

  LoadError(this.error);
}
