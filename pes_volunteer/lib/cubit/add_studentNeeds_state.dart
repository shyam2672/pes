part of 'add_studentNeeds_cubit.dart';

@immutable
abstract class AddStudentNeedsState {}

class AddStudentNeedsInitial extends AddStudentNeedsState {}

class AddStudentNeedsApplying extends AddStudentNeedsState {}

class AddStudentNeedsApplied extends AddStudentNeedsState {}

class AddStudentNeedsNotApplied extends AddStudentNeedsState {
  final String message;
  AddStudentNeedsNotApplied(this.message);
}
