part of 'studentNeeds_cubit.dart';

@immutable
abstract class StudentNeedsState {}

class StudentNeedsInitial extends StudentNeedsState {}

class StudentNeedsLoading extends StudentNeedsState {}

class StudentNeedsLoaded extends StudentNeedsState {}

class StudentNeedsError extends StudentNeedsState {
  final String error;

  StudentNeedsError({required this.error});
}
