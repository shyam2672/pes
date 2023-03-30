part of 'student_needs_delete_cubit.dart';

@immutable
abstract class StudentNeedsDeleteState {}

class StudentNeedsDeleteInitial extends StudentNeedsDeleteState {}

class StudentNeedsDeleteLoading extends StudentNeedsDeleteState {}

class StudentNeedsSelectionActive extends StudentNeedsDeleteState {}

class ApplicationSubmitted extends StudentNeedsDeleteState {}

class ApplicationNotSubmitted extends StudentNeedsDeleteState {
  final String message;

  ApplicationNotSubmitted(this.message);
}
