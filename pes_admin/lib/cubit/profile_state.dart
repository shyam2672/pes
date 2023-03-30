part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final VolunteerProfile volunteerProfile;

  ProfileLoaded(this.volunteerProfile);

}

class LoadError extends ProfileState {
  final String error;

  LoadError(this.error);
}
