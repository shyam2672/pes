part of 'attendance_cubit.dart';

@immutable
abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceMarking extends AttendanceState {}

class AttendanceMarked extends AttendanceState {}

class AttendanceNotMarked extends AttendanceState {
  final String message;

  AttendanceNotMarked(this.message);
}
