part of 'studentNeeds_cubit.dart';

@immutable
abstract class StudentNeedsState {}

class StudentNeedsInitial extends StudentNeedsState {}

class StudentNeedsLoading extends StudentNeedsState {}

class StudentNeedsLoaded extends StudentNeedsState {}

class StudentNeedsAdded extends StudentNeedsState {}

class StudentNeedsNotAdded extends StudentNeedsState {}

class StudentNeedsDeleted extends StudentNeedsState {}

class StudentNeedsNotDeleted extends StudentNeedsState {}

class StudentNeedsError extends StudentNeedsState {
  String error;
  StudentNeedsError({required this.error});
}
